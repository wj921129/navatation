param (
    [string]$ConversationId
)

$brainPath = "$env:USERPROFILE\.gemini\antigravity-cli\brain"

if ([string]::IsNullOrWhiteSpace($ConversationId)) {
    Write-Host "Please provide a Conversation ID." -ForegroundColor Yellow
    Write-Host "Example: .\analyze-ai-metrics.ps1 -ConversationId 'a96e721d-b33e-4a8d-9acd-d9e7a32d102f'"
    Write-Host ""
    Write-Host "Available conversations (Top 5 recent):" -ForegroundColor Cyan
    if (Test-Path $brainPath) {
        Get-ChildItem -Path $brainPath -Directory | Select-Object Name, LastWriteTime | Sort-Object LastWriteTime -Descending | Select-Object -First 5 | Format-Table -AutoSize
    } else {
        Write-Host "Brain path not found: $brainPath" -ForegroundColor Red
    }
    exit
}

$logPath = Join-Path $brainPath "$ConversationId\.system_generated\logs\transcript.jsonl"

if (-Not (Test-Path $logPath)) {
    Write-Host "Log file not found: $logPath" -ForegroundColor Red
    exit
}

Write-Host "Analyzing tool metrics for conversation: $ConversationId" -ForegroundColor Cyan
Write-Host "--------------------------------------------------------"

$toolCounts = @{}
$mcpCounts = @{}

Get-Content $logPath | ForEach-Object {
    try {
        $logObj = $_ | ConvertFrom-Json
        if ($null -ne $logObj.tool_calls -and $logObj.tool_calls.Count -gt 0) {
            foreach ($call in $logObj.tool_calls) {
                $toolName = $call.name
                if ($null -eq $toolCounts[$toolName]) {
                    $toolCounts[$toolName] = 1
                } else {
                    $toolCounts[$toolName]++
                }
                
                # Check for MCP or specific arguments if needed
                # Check for Eager loaded MCP
                if ($toolName.StartsWith("mcp_")) {
                    $parts = $toolName.Split("_")
                    if ($parts.Length -ge 3) {
                        $mcpTarget = $parts[1]
                        if ($null -eq $mcpCounts[$mcpTarget]) {
                            $mcpCounts[$mcpTarget] = 1
                        } else {
                            $mcpCounts[$mcpTarget]++
                        }
                    }
                }
            }
        }
        
        # Check for lazy loaded MCP tool ServerName via raw regex match on the line to bypass JSON un-stringification issues
        if ($_ -match 'ServerName\\?["'']\s*:\s*\\?["'']([a-zA-Z0-9_-]+)') {
            $mcpTarget = $matches[1]
            if ($null -eq $mcpCounts[$mcpTarget]) {
                $mcpCounts[$mcpTarget] = 1
            } else {
                $mcpCounts[$mcpTarget]++
            }
        }
    } catch {
        # ignore parse errors
    }
}

Write-Host "Top Tools Used:" -ForegroundColor Yellow
$toolCounts.GetEnumerator() | Sort-Object Value -Descending | Format-Table -AutoSize

Write-Host "MCP/Servers Targets Used:" -ForegroundColor Green
if ($mcpCounts.Count -gt 0) {
    $mcpCounts.GetEnumerator() | Sort-Object Value -Descending | Format-Table -AutoSize
} else {
    Write-Host "No explicit MCP tool usage detected or missing specific arguments mapping."
}

Write-Host "--------------------------------------------------------"
Write-Host "Analysis Complete." -ForegroundColor Cyan
