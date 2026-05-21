# 📋 navatation 项目任务看板

> 维护者：项目经理（PM）| 最后更新：2026-05-20T22:04

---

## 当前版本状态

| 维度 | 状态 |
|------|------|
| 当前版本 | v1.0 MVP 进行中 |
| 数据库 | DDL 已执行 ✅ (7 张表已建) |
| 后端进度 | 用户认证 API ✅ \| 导航管理 API ✅ \| 设置 API ✅ \| 待办事项 API ✅ |
| 前端进度 | 项目初始化 ✅ \| 主页面 UI ✅ \| Service 层 ✅ \| 组件 ✅ \| 登录联调 ✅ \| 待办面板 ✅ \| 拖拽排序 ✅ \| 主题切换 ✅ |
| 测试状态 | 默认由用户手动确认，QA 角色保留作为被动指派验证 |

---

## 数据库表结构 (已执行 DDL)

| 表名 | 说明 | 状态 |
|------|------|------|
| `navatation_user` | 用户表 - 注册用户基本信息 | ✅ 已建 |
| `navatation_user_config` | 用户配置表 - 个性化显示设置(搜索引擎/壁纸/图标尺寸等) | ✅ 已建 |
| `navatation_nav_category` | 导航分类表 - 用户自定义快捷方式分组 | ✅ 已建 |
| `navatation_nav_shortcut` | 导航网址表 - 用户添加的网站快捷方式 | ✅ 已建 |
| `navatation_recommend_category` | 推荐分类表 - 系统预置的推荐网站分类 | ✅ 已建 |
| `navatation_recommend_site` | 推荐网址表 - 推荐分类下的具体网站 | ✅ 已建 |
| `navatation_todo_item` | 待办事项表 - 用户轻量级待办任务 | ✅ 已建 |

---

## 后端进度详情 (navatation-admin)

### 项目结构

| 模块 | 说明 | 状态 |
|------|------|------|
| `navatation-business` | 业务主模块 (Controller/Service/Mapper/Entity/DTO) | ✅ 已搭建 |
| `navatation-common` | 公共模块 (Result/BizException/ResultCode) | ✅ 已搭建 |
| `navatation-framework` | 框架模块 (Security/JWT/CORS/Redis/全局异常) | ✅ 已搭建 |

### 技术栈

- Spring Boot + MyBatis-Plus + Redis + JWT + RSA
- 端口: `8080`
- 数据库: `navatation` (MySQL)
- 密钥目录: `navatation-admin/rsa/` (自动生成)

### API 端点清单

#### AuthController (`/api/v1/auth`) ✅

| 方法 | 端点 | 说明 | 状态 |
|------|------|------|------|
| GET | `/nonce` | 获取 nonce + RSA 公钥 | ✅ |
| POST | `/register` | 用户注册（RSA 加密） | ✅ |
| POST | `/login` | 用户登录（RSA 加密） | ✅ |
| POST | `/refresh` | Token 刷新 | ✅ |
| POST | `/logout` | 用户登出 | ✅ |
| GET | `/me` | 获取当前用户信息 | ✅ |
| POST | `/reset-password` | 用户重置密码 (找回密码) | ✅ |

#### NavController (`/api/v1/nav`) ✅

| 方法 | 端点 | 说明 | 状态 |
|------|------|------|------|
| GET | `/categories` | 获取分类列表 | ✅ |
| POST | `/categories` | 创建分类 | ✅ |
| PUT | `/categories/{id}` | 更新分类 | ✅ |
| DELETE | `/categories/{id}` | 删除分类 | ✅ |
| GET | `/shortcuts` | 获取快捷方式列表 | ✅ |
| POST | `/shortcuts/batch` | 批量创建快捷方式 | ✅ |
| PUT | `/shortcuts/{id}` | 更新快捷方式 | ✅ |
| DELETE | `/shortcuts/{id}` | 删除快捷方式 | ✅ |
| PUT | `/shortcuts/sort` | 快捷方式排序 | ✅ |
| POST | `/favicon` | 获取网站 Favicon | ✅ |
| GET | `/recommended` | 获取推荐站点 | ✅ |

#### SettingsController (`/api/v1/settings`) ✅

| 方法 | 端点 | 说明 | 状态 |
|------|------|------|------|
| GET | `/` | 获取用户设置 | ✅ |
| PUT | `/` | 保存用户设置(全量) | ✅ |
| PATCH | `/` | 局部更新用户设置 | ✅ |
| POST | `/wallpaper/upload` | 上传壁纸 | ✅ |

#### TodoController (`/api/v1/todo`) ✅

| 方法 | 端点 | 说明 | 状态 |
|------|------|------|------|
| GET | `/` | 获取待办列表 | ✅ |
| POST | `/` | 创建待办 | ✅ |
| PUT | `/{id}` | 更新待办 | ✅ |
| PATCH | `/{id}/toggle` | 切换完成状态 | ✅ |
| DELETE | `/{id}` | 删除待办 | ✅ |
| PUT | `/sort` | 待办排序 | ✅ |
| DELETE | `/completed` | 清除已完成待办 | ✅ |

### 后端实体/DTO 清单

| 类型 | 文件 | 说明 |
|------|------|------|
| Entity | `User`, `NavCategory`, `NavShortcut`, `TodoItem`, `UserConfig` | 数据库实体类 |
| DTO | `LoginRequest`, `RegisterRequest`, `RefreshTokenRequest` | 认证请求 |
| DTO | `EncryptedLoginRequest`, `EncryptedRegisterRequest`, `EncryptedChangePasswordRequest` | 加密认证请求 |
| DTO | `CategoryRequest`, `BatchCreateRequest`, `UpdateShortcutRequest`, `SortRequest`, `FaviconRequest` | 导航请求 |
| DTO | `SettingsRequest`, `TodoCreateRequest`, `TodoUpdateRequest`, `TodoSortRequest` | 设置/待办请求 |
| VO | `LoginVO`, `UserVO`, `CategoryVO`, `ShortcutVO`, `BatchCreateItemVO`, `FaviconVO`, `RecommendCategoryVO`, `RecommendSiteVO` | 响应数据 |
| VO | `SettingsVO`, `WallpaperVO`, `TodoVO`, `ToggleVO`, `DeleteCountVO` | 响应数据 |

---

## 前端进度详情 (navatation-web)

### 技术栈

- React 18 + Vite + TypeScript + TailwindCSS 4 + shadcn/ui + Radix UI
- 动画: motion (framer-motion)
- 图标: lucide-react
- 拖拽: react-dnd

### 业务组件

| 组件 | 说明 | 状态 |
|------|------|------|
| `App.tsx` | 主页面 (搜索框 + 快捷方式网格 + 背景壁纸 + 底部控制栏) | ✅ UI 完成 |
| `LoginDialog.tsx` | 登录/注册弹窗 (已对接 authStore) | ✅ 已对接 API |
| `AddShortcutDialog.tsx` | 添加快捷方式弹窗 (推荐站点 + 自定义输入) | ✅ UI 完成 (本地硬编码推荐数据) |
| `EditShortcutDialog.tsx` | 编辑快捷方式弹窗 | ✅ UI 完成 |
| `SettingsDialog.tsx` | 设置面板 (壁纸/搜索框/图标/文字配置) | ✅ UI 完成 (未对接 API) |
| `SearchEngineSelect.tsx` | 搜索引擎下拉选择 | ✅ |

### Service 层 (API 调用)

| Service | 说明 | 状态 |
|---------|------|------|
| `api-client.ts` | HTTP 客户端 (Bearer Token / 401 自动刷新 / 统一错误处理) | ✅ |
| `auth-service.ts` | 认证 API (登录/注册/刷新/登出/获取当前用户) | ✅ |
| `crypto-service.ts` | RSA 加密服务 (Web Crypto API 加密密码) | ✅ |
| `nav-service.ts` | 导航 API (分类 CRUD / 快捷方式 CRUD+排序 / Favicon / 推荐) | ✅ |
| `settings-service.ts` | 设置 API (获取/保存/局部更新/上传壁纸) | ✅ |
| `todo-service.ts` | 待办 API (CRUD / 排序 / 切换完成 / 清除已完成) | ✅ |

### Store 层

| Store | 说明 | 状态 |
|-------|------|------|
| `auth-store.ts` | 认证状态管理 (登录/注册/登出/fetchUser) | ✅ |

### UI 基础组件 (shadcn/ui)

已集成 40+ 个 Radix UI 基础组件 (button, dialog, input, select, tabs, slider, tooltip 等)

---

## 待完成事项 🔧

### 后端

| 优先级 | 任务 | 状态 |
|--------|------|------|
| P0 | 后端服务启动验证 (确认编译通过 + 接口可访问) | ✅ 已验证 |
| P0 | BUG-001 修复: MySQL JDBC characterEncoding 参数错误 | ✅ 已修复 |
| P1 | 推荐站点数据初始化 (INSERT 种子数据到 recommend 表) | ✅ 已有数据 |

### 前端

| 优先级 | 任务 | 状态 |
|--------|------|------|
| P0 | 主页面对接后端 API (快捷方式列表从服务器加载) | ✅ 已完成 |
| P0 | 设置面板对接 settingsService | ✅ 已完成 |
| P1 | 添加快捷方式弹窗对接后端 (推荐数据从 API 加载 + 批量创建调用) | ✅ 已完成 |
| P1 | 待办事项 UI 组件 + 对接 todoService | ✅ 已完成 |
| P2 | 拖拽排序 (react-dnd 接入) | ✅ 已完成 |
| P2 | 主题切换 (light/dark/auto) | ✅ 已完成 |

### 集成

| 优先级 | 任务 | 状态 |
|--------|------|------|
| P0 | 前后端联调测试 (登录流程) | ✅ 已通过 |
| P0 | 后端全 API 冒烟测试 (8 个端点) | ✅ 已通过 |

---

## 任务历史

| 日期 | 任务 | 角色 | 状态 | 备注 |
|------|------|------|------|------|
| 2026-05-18 | 工作流初始化 | PM | ✅ 完成 | 建立四角色协作体系 |
| 2026-05-21 | `.claude/settings.local.json`, `CLAUDE.md`, `GEMINI.md` | - | ✅ 完成 | 精简脚本至 4 个，完全移除了所有旧 `.sh` 脚本和冗余脚本，重新对齐 hooks 及其余说明 |
| 2026-05-21 | `EditShortcutDialog.tsx`, `App.tsx` | FE | ✅ 完成 | 重构编辑网址弹窗，对接后端上传 `uploadIcon` 与自动 Favicon 嗅探服务，并修复 `App.tsx` 保存快捷键时未解构更新图标属性的 Bug |
| 2026-05-21 | `GEMINI.md` | PM | ✅ 完成 | 新增免去环境变量读取的 AI 启动指令及 Windows 一键启动脚本使用说明 |
| 2026-05-18 | `base_rule.md` | PM | ✅ 完成 | 添加四角色工作流激活指令 |
| 2026-05-18 | `WORKFLOW-STATUS.md` | PM | ✅ 完成 | 全面更新：同步 DDL/后端/前端代码进度 |
| 2026-05-18 | `WORKFLOW-STATUS.md` | PM | ✅ 完成 | 同步 QA 测试结果、Bug 修复记录 |
| 2026-05-18 | `WORKFLOW-STATUS.md` | PM | ✅ 完成 | 添加 /reset-password 接口与忘记密码开发记录 |
| 2026-05-18 | `application.yml` | BE | ✅ 完成 | 修复 characterEncoding=utf8mb4 → UTF-8 |
| 2026-05-19 | `NavController.java`, `NavService.java` | BE | ✅ 完成 | 新增 POST /nav/icon/upload：文件类型白名单/200KB/Redis 30次/小时频率限制 |
| 2026-05-19 | `AddShortcutDialog.tsx` | FE | ✅ 完成 | 图标上传改为调用后端接口，替换 FileReader Base64 方案 |
| 2026-05-19 | `api-specification.md` | BE | ✅ 完成 | 新增图标上传 API 文档 |
| 2026-05-20 | `tsconfig.json` | FE | ✅ 完成 | 新增前端 TS 配置文件，修复 IDE 引用 `@/` 路径别名报红的异常 |
| 2026-05-20 | `logback-spring.xml` | BE | ✅ 完成 | 重塑 CONSOLE 与 FILE 全局日志格式为 `[level] [traceId] [time] [class.method] msg` 规整中括号形式 |
| 2026-05-20 | `RequestLogAspect.java` | BE | ✅ 完成 | 新建最高优先级切面，动态解析 token 提取用户 ID 并使用 32 位 UUID MDC 进行链路追踪 |
| 2026-05-20 | `Maven 多模块打包构建` | BE | ✅ 完成 | 解决因子模块直接启动未包含最新 framework 切面字节码导致 AOP 未生效问题，全局 clean install 并验证通过 |
| 2026-05-20 | `NavService.java`, `vite.config.ts`, `App.tsx`, `AddShortcutDialog.tsx` | FE/BE | ✅ 完成 | 修复上传文件 FileNotFound 异常（转绝对路径）；为 Vite 增加 `/uploads` 静态代理修复回显 404；调整图标渲染为 `60% contain` 比例并优化添加网址弹窗右侧的圆形实时预览 UI |
| 2026-05-20 | `WORKFLOW-STATUS.md` | PM | ✅ 完成 | 同步项目看板，追加编辑器配置、AOP MDC 链路追踪及图标上传相关修复记录 |
| 2026-05-21 | `App.tsx` | FE | ✅ 完成 | 仅在编辑状态下显示添加网址按钮，并重构添加网址及保存重排的机制，保障全局保存一致性 |
| 2026-05-21 | `App.tsx` | PM | ✅ 完成 | 修复首页编辑状态下仅更换图标（iconType/iconValue）或颜色点击保存没有调用后端接口的 Bug (BUG-009) |
| 2026-05-21 | Windows 脚本精简及引用更新 | PM | ✅ 完成 | 删除了全部冗余及旧 `.sh` 脚本，仅保留 4 个核心 Windows `.bat` 启停脚本，并完成了所有项目及配置引用更新 |
| 2026-05-21 | 壁纸与图标上传绝对路径及工具类重构 | PM | ✅ 完成 | 修复前端壁纸上传未对接后端接口问题；重构壁纸和图标物理存储为绝对路径，并支持配置文件动态修改；实现按 `userId` 物理隔离目录；引入 3次重试安全目录创建与 UUID 长字符串命名，避免重名覆盖 |
| 2026-05-21 | 游客模式隐藏编辑图标按钮 | FE | ✅ 完成 | 隐藏未登录用户的快捷图标编辑按钮；同时增加登出安全副作用，在用户登出时强制清除临时修改状态并退出编辑模式 |
| 2026-05-21 | 设置草稿化与保存按钮生效重构 | FE | ✅ 完成 | 实现所有设置（包括排版尺寸、壁纸上传、随机壁纸、主题选择）的本地草稿管理，重命名“完成”按钮为“保存”，只有点击保存才批量保存生效并网络持久化，非保存关闭安全回滚 |
| 2026-05-21 | 三仓一键推送脚本开发与工作流整合 | PM | ✅ 完成 | 编写 scripts/push-all.bat 实现主仓、前端仓、后端仓一键提交推送，并将该命令及规范写入 GEMINI.md/CLAUDE.md 的 AI 引导工作流中 |

---



## 文档同步记录

| 日期 | 文档 | 变更摘要 |
|------|------|----------|
| 2026-05-21 | `WORKFLOW-STATUS.md` | 看板同步：更新仅编辑模式显示添加按钮及批量新建重排机制的开发记录 |
| 2026-05-21 | `WORKFLOW-STATUS.md` | 修复首页编辑状态下仅更换图标/颜色点击保存没有调用后端接口的 Bug，并同步更新任务看板与 Bug 追踪表 |
| 2026-05-21 | `WORKFLOW-STATUS.md` | 看板同步：更新壁纸与图标上传绝对路径及重试目录创建工具类重构的开发记录 |
| 2026-05-21 | `WORKFLOW-STATUS.md` | 看板同步：未登录状态下隐藏首页图标编辑按钮及登出强制退出编辑态的优化记录 |
| 2026-05-21 | `WORKFLOW-STATUS.md` | 看板同步：设置草稿化与保存按钮批量生效重构的开发记录 |
| 2026-05-21 | `GEMINI.md`, `CLAUDE.md`, `WORKFLOW-STATUS.md` | 同步一键推送脚本到 AI 引导文档与工作流中，确保未来 Agent 能快速定位并按需执行 |
| 2026-05-21 | `.claude/settings.local.json`, `CLAUDE.md`, `GEMINI.md` | 精简脚本至 4 个，完全移除了所有旧 `.sh` 脚本和冗余脚本，重新对齐 hooks 及其余说明 |
| 2026-05-21 | `GEMINI.md` | 新增免去环境变量读取的 AI 启动指令及 Windows 一键启动脚本使用说明 |
| 2026-05-18 | `base_rule.md` | 添加四角色工作流激活指令 |
| 2026-05-18 | `WORKFLOW-STATUS.md` | 全面更新：同步 DDL/后端/前端代码进度 |
| 2026-05-18 | `WORKFLOW-STATUS.md` | 同步 QA 测试结果、Bug 修复记录 |
| 2026-05-18 | `WORKFLOW-STATUS.md` | 添加 /reset-password 接口与忘记密码开发记录 |
| 2026-05-18 | `application.yml` | 修复 characterEncoding=utf8mb4 → UTF-8 |
| 2026-05-18 | 工作流配置文件 | 细化 QA 被动触发机制，默认用户手动验证，保留 QA 角色 |
| 2026-05-18 | 工作流配置文件 | 修改后端接口同步规范，强制所有接口 100% 实时同步至 api-specification.md |
| 2026-05-18 | `WORKFLOW-STATUS.md` | 新增首次登录网址同步开发记录 |
| 2026-05-18 | `WORKFLOW-STATUS.md` | 新增快捷网址编辑与删除同步持久化开发记录 |
| 2026-05-18 | `WORKFLOW-STATUS.md` | 新增待办面板/拖拽排序/主题切换开发记录 |
| 2026-05-18 | `TodoPanel.tsx` | 新创建：待办事项组件含本地存储+云端同步 |
| 2026-05-18 | `App.tsx` | 集成 TodoPanel、react-dnd 拖拽、next-themes 主题 |
| 2026-05-18 | `rsa-login-encryption-design.md` | 新建：RSA 加密登录设计方案 |
| 2026-05-18 | `api-specification.md` | 新增 /auth/nonce 端点，更新登录/注册/改密为 RSA 加密传输 |
| 2026-05-19 | `backend-architecture.md` | Redis 版本从 7.x 更新为 3.2.100 |
| 2026-05-18 | `backend-architecture.md` | 安全设计章节引用 RSA 加密设计文档 |
| 2026-05-18 | `WORKFLOW-STATUS.md` | 同步 RSA 加密开发记录 |
| 2026-05-19 | `NavService.java` | 增强 fetchFavicon：实际请求页面 HTML 解析 <link rel="icon"> 标签提取真实图标，超时 5s 回退 /favicon.ico |
| 2026-05-19 | `AddShortcutDialog.tsx` | 自定义网址输入框增加防抖自动检测网站图标，显示加载/成功/失败状态 |
| 2026-05-19 | `ResourceConfig.java` | 新增：映射 /uploads/** 到文件系统，使上传文件可 HTTP 访问 |
| 2026-05-19 | `NavController.java`, `NavService.java` | 新增 POST /nav/icon/upload：文件类型 whiteList/200KB/Redis 30次/小时频率限制 |
| 2026-05-19 | `AddShortcutDialog.tsx` | 图标上传改为调用后端接口，替换 FileReader Base64 方案 |
| 2026-05-19 | `api-specification.md` | 新增图标上传 API 文档 |
| 2026-05-20 | `tsconfig.json` | 新增前端 TS 配置文件，修复 IDE 引用 `@/` 路径别名报红的异常 |
| 2026-05-20 | `logback-spring.xml` | 重塑 CONSOLE 与 FILE 全局日志格式为 `[level] [traceId] [time] [class.method] msg` 规整中括号形式 |
| 2026-05-20 | `RequestLogAspect.java` | 新建最高优先级切面，动态解析 token 提取用户 ID 并使用 32 位 UUID MDC 进行链路追踪 |
| 2026-05-20 | `Maven 多模块打包构建` | 解决因子模块直接启动未包含最新 framework 切面字节码导致 AOP 未生效问题，全局 clean install 并验证通过 |
| 2026-05-20 | `NavService.java`, `vite.config.ts`, `App.tsx`, `AddShortcutDialog.tsx` | 修复上传文件 FileNotFound 异常（转绝对路径）；为 Vite 增加 `/uploads` 静态代理修复回显 404；调整图标渲染为 `60% contain` 比例并优化添加网址弹窗右侧的圆形实时预览 UI |
| 2026-05-20 | `WORKFLOW-STATUS.md` | 同步项目看板，追加编辑器配置、AOP MDC 链路追踪及图标上传相关修复记录 |
