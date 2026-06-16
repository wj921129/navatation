# Antigravity Tool Mapping

Skills use Claude Code tool names. When you encounter these in a skill, use your platform equivalent:

| Skill references | Antigravity equivalent |
|-----------------|------------------------|
| `Read` (file reading) | `view_file` |
| `Write` (file creation) | `write_to_file` |
| `Edit` (file editing, single block) | `replace_file_content` |
| `Edit` (file editing, multiple non-adjacent blocks) | `multi_replace_file_content` |
| `Bash` (run commands) | `run_command` (Shell: PowerShell on Windows) |
| `Grep` (search file content) | `grep_search` |
| `Glob` (search files by name) | `list_dir` + `grep_search` (combined) |
| `TodoWrite` (task tracking) | `write_to_file` to create `task.md` artifact |
| `Skill` tool (invoke a skill) | `view_file` with `IsSkillFile: true` (degraded mode — no native `activate_skill`) |
| `WebSearch` | `search_web` |
| `WebFetch` | `read_url_content` |
| `Task` tool (dispatch subagent) | `invoke_subagent` + `define_subagent` |
| Multiple `Task` calls (parallel) | Single `invoke_subagent` call with multiple entries in the `Subagents` array |
| Task status / output | `manage_subagents` + `send_message` |
| `EnterPlanMode` / `ExitPlanMode` | Built-in Planning Mode (system-managed, no manual switch needed) |

## Subagent support

Antigravity supports subagents natively via `invoke_subagent`. Use `define_subagent` first if you need a custom agent type, then invoke it.

| Skill instruction | Antigravity equivalent |
|-------------------|------------------------|
| `Task tool (superpowers:implementer)` | `invoke_subagent` with `TypeName: "self"` and the filled implementer prompt |
| `Task tool (superpowers:spec-reviewer)` | `invoke_subagent` with `TypeName: "research"` and the filled review prompt |
| `Task tool (superpowers:code-reviewer)` | `invoke_subagent` with `TypeName: "self"` and the filled code-reviewer prompt |
| `Task tool (general-purpose)` with inline prompt | `invoke_subagent` with `TypeName: "self"` and your inline prompt |

### Parallel dispatch

Antigravity supports parallel subagent dispatch. When a skill asks you to dispatch multiple independent subagent tasks in parallel, pass all of them as entries in the `Subagents` array in a single `invoke_subagent` call. Keep dependent tasks sequential.

### Subagent lifecycle

After dispatching, use `manage_subagents` to track status and `send_message` to communicate. Terminate completed subagents with `manage_subagents` (Action: "kill") to free resources.

## Additional Antigravity tools

These tools are available in Antigravity but have no Claude Code equivalent:

| Tool | Purpose |
|------|---------|
| `list_dir` | List files and subdirectories in a path |
| `ask_question` | Ask the user structured multiple-choice questions |
| `ask_permission` | Request permissions for file reads/writes or commands after a permission error |
| `generate_image` | Generate or edit images from a text prompt |
| `list_permissions` | List all current permission grants |
| `manage_task` | Manage background tasks (list, kill, status, send_input) |
| `manage_subagents` | Manage subagent lifecycle (list, kill, kill_all) |
| `schedule` | Set one-shot timers or recurring cron jobs for notifications |

## Skill activation (degraded mode)

Antigravity has no native `activate_skill` tool. Instead, read skill files directly:

```
view_file(
  AbsolutePath: "~/.gemini/extensions/superpowers/skills/<skill-name>/SKILL.md",
  IsSkillFile: true
)
```

The `IsSkillFile: true` flag signals that this read is a skill activation, not a regular file read. This is equivalent to invoking the `Skill` tool in Claude Code.
