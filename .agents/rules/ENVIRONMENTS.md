# ENVIRONMENTS.md - Navatation 多环境区分配置指南

> **[AGENTS.md](../../AGENTS.md) 子规范：聚焦 dev/prd 双环境的配置对照与行为准则。**

为确保在与老板对话中提及 "dev环境" 或 "prd环境" 时，AI 能执行对应的精准操作，以下为双环境的核心配置对照与行为准则：

## 1. 环境配置对照表
| 维度 | 开发环境 (dev) | 生产环境 (prd) |
| :--- | :--- | :--- |
| **目标定位** | 本地联调、功能开发、小步构建 | 远程服务器发布、稳定性运行环境 |
| **Git 分支** | `dev` | `main` |
| **Spring 激活环境** | `dev` (默认) | `prd` |
| **服务器地址/IP** | 本地 `localhost` | 远程云服务器 `106.13.107.122` |
| **后端主端口** | `8080` | `8080` |
| **MySQL 密码** | `root` | `Wanggy@fuioupay.com` |
| **Redis 密码** | 无密码 | `Wanggy@fuioupay.com` |
| **日志级别** | `DEBUG` | `INFO` |
| **文件上传路径** | `../data/` 等相对路径 | `/www/wwwroot/navatation/data/` 绝对路径 |
| **前端 API 根路径**| `http://localhost:8080/api/v1` | `http://106.13.107.122:8080/api/v1` |
| **静态资源服务地址** | 默认使用后端地址（相对路径） | 走 `9909` 端口，通过 Nginx 直接读取 (`http://106.13.107.122:9909`) |
| **对应打包脚本** | 后端：`build-backend-dev.bat`<br>前端：`build-frontend-dev.bat` | 后端：`build-backend-main.bat`<br>前端：`build-frontend-main.bat` |

## 2. 行为准则与响应要求
* **主动环境识别**：当老板提及 "部署"、"打包"、"连接" 时，AI 必须确认当前的上下文是 **dev** 还是 **prd**。如果意图模糊，应主动向老板提问确认。
* **配置防污染**：严禁将 prd 的敏感密码（如 `Wanggy@fuioupay.com`）或绝对路径写入到 dev 环境配置文件中，也严禁将 dev 的 debug 日志等级或测试 key 提交到 main 分支。
* **构建闭环**：对于 prd 的操作，任何代码修改合并到 main 分支前均需在本地 dev 验证通过。
