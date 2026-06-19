---
name: custom-launch-services
description: Quickly starts all required backend and frontend services (Redis, Spring Boot, React UI) in the background without user intervention.
---

# 🚀 极速启动与服务管理 (Fast Launch Guide)

当用户要求启动系统、启动前后端或者当前环境服务宕机时，调用本技能以静默、安全、防重的方式拉起服务。

## 启动规程 (Launch Protocol)

### 1. 防重判断
首先，检查对应服务的端口或进程是否已经在运行。本项目中 agy 在 SessionStart 时可能已经托管拉起了服务。
* Redis 端口：`6379`
* Spring Boot 后端端口：`8080`
* Vite 前端端口：`5173`
如果你探测到它们处于监听状态，请直接告知用户服务已在运行，无需重复拉起。

### 2. 严格顺序启动
如果服务确实未启动，**必须使用 `run_command` 工具**按 `Redis -> 后端(be) -> 前端(fe)` 的严格顺序依次拉起各个服务脚本，以确保依赖就绪。
- 必须将 `WaitMsBeforeAsync` 设置为较短的时间（如 500ms），让其挂载到后台执行。
- 必须先拉起 Redis，接着拉起后端，最后拉起前端。
- 不要使用 `start-all.bat`，因其弹窗模式在 AI 无头终端中会导致阻塞或死亡。
- **执行命令顺序列表** (Cwd 保持项目根目录 `.`):
  1. 首先启动 Redis：`scripts\service\start-redis.bat`
  2. 然后启动 Backend：`scripts\service\start-be.bat`
  3. 最后启动 Frontend：`scripts\service\start-fe.bat`

### 3. 汇报就绪
在发送完后台任务后，简单向用户汇报“Redis、后端和前端服务已在后台启动中，请等待几秒后即可访问”。
