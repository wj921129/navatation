# PROJECT-STRUCTURE.md - Navatation 项目结构地图

> **[AGENTS.md](../../AGENTS.md) 子规范：项目目录结构的静态参考。**

```
navatation/
├── navatation-web/              # 前端 React 项目
│   └── src/
│       ├── app/                 # 应用主体
│       │   ├── components/      # shadcn/ui 组件
│       │   ├── hooks/           # 自定义 Hooks
│       │   ├── services/        # API 调用层 (api-client.ts)
│       │   ├── stores/          # 状态管理
│       │   └── constants/       # 常量定义
│       ├── config/              # 项目配置
│       └── styles/              # 样式资源
├── navatation-admin/            # 后端 Spring Boot 项目
│   ├── navatation-business/     # 业务主模块（Controller/Service/Mapper/Entity/DTO）
│   ├── navatation-common/       # 公共模块（工具类/常量/异常定义）
│   ├── navatation-framework/    # 框架模块（配置/拦截器/安全）
│   ├── ddl.sql                  # 表结构变更记录
│   └── dml.sql                  # 数据变更记录
├── doc/                         # 项目文档
│   ├── PRD.md                   # 产品需求文档
│   ├── api-specification.md     # 接口协议
│   ├── backend-architecture.md  # 后端架构设计
│   ├── frontend-architecture.md # 前端架构设计
│   ├── WORKFLOW-STATUS-DEV.md   # 开发任务看板
│   ├── USER-GUIDE.md            # 用户手册 & 版本更新日志
│   ├── plans/                   # 实施计划唯一存放路径（覆盖全局 fallback）
│   └── specs/                   # 设计方案唯一存放路径（覆盖全局 fallback）
├── scripts/                     # 自动化脚本
│   ├── dashboard.bat            # 可视化管理仪表盘
│   ├── git/                     # Git 推送/合并脚本
│   ├── service/                 # 服务启停脚本
│   ├── metrics/                 # AI 度量分析脚本
│   └── tools/                   # 辅助工具（包含 install-codebase-memory.bat 代码图谱安装）
├── .agents/                     # AI 助手配置与规范
│   ├── rules/                   # 项目级规则规范
│   │   ├── WORKFLOW.md          # 工作流与 Pipeline 规范
│   │   ├── CODING-STANDARDS.md  # 核心编码与安全规范
│   │   ├── DEBUGGING-GUIDE.md   # 调试与反馈循环指南
│   │   ├── ENVIRONMENTS.md      # 多环境配置指南
│   │   └── PROJECT-STRUCTURE.md # 项目结构地图（本文件）
├── AGENTS.md                   # 项目总入口（最高宪法）
```
