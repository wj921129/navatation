# 📋 navatation 项目任务看板

> 维护者：项目经理（PM）| 最后更新：2026-05-18T21:00

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
| 2026-05-18 | DDL 执行 | 后端 | ✅ 完成 | 7 张业务表已建 |
| 2026-05-18 | 后端 API 开发 | 后端 | ✅ 完成 | 4 个 Controller / 4 个 Service / 5 个 Mapper |
| 2026-05-18 | 前端 Service 层 | 前端 | ✅ 完成 | api-client + 4 个业务 service + auth-store |
| 2026-05-18 | 前端主页面 UI | 前端 | ✅ 完成 | 搜索框/快捷方式网格/设置面板/登录弹窗 |
| 2026-05-18 | 进度同步 | PM | ✅ 完成 | 更新 WORKFLOW-STATUS.md |
| 2026-05-18 | 前后端启动 | 后端/前端 | ✅ 完成 | 后端 :8080 / 前端 :5173 |
| 2026-05-18 | BUG-001 修复 | 后端 | ✅ 完成 | characterEncoding=utf8mb4 → UTF-8 |
| 2026-05-18 | 首轮 QA 测试 | QA | ✅ 完成 | 14/14 通过，含 API 测试 + UI 测试 |
| 2026-05-18 | 前端核心 API 对接 | FE | ✅ 完成 | 主页面/设置面板/添加弹窗 对接后端 |
| 2026-05-18 | 二轮 QA 测试 | QA | ✅ 完成 | 状态持久化、用户登录等已验证通过 |
| 2026-05-18 | 工作流优化（被动QA模式） | PM | ✅ 完成 | 调整 QA 为被动角色，仅在用户指派时执行测试，默认由用户手动确认 |
| 2026-05-18 | 忘记密码功能开发 | FE/BE | ✅ 完成 | 完善前后端忘记密码及邮箱验证重置密码功能 |
| 2026-05-18 | 首次登录网址同步 | FE | ✅ 完成 | 首次登录且云端列表为空时，自动同步游客模式下的定制快捷网址 |
| 2026-05-18 | 编辑与删除网址持久化 | FE | ✅ 完成 | 修复用户在编辑模式下的修改与删除无法同步至云端数据库的 Bug |
| 2026-05-18 | CORS 跨域问题修复 | BE | ✅ 完成 | 删除冲突的 WebMvcConfig，SecurityConfig 放行 OPTIONS，CorsFilter 为主 |
| 2026-05-18 | 待办事项 UI 组件开发 | FE | ✅ 完成 | TodoPanel 组件 + todoService 对接 + 云端同步 |
| 2026-05-18 | 拖拽排序功能开发 | FE | ✅ 完成 | react-dnd 集成到编辑模式快捷方式排序 |
| 2026-05-18 | 主题切换功能开发 | FE | ✅ 完成 | next-themes + SettingsDialog 主题选择器 |
| 2026-05-18 | RSA 加密登录 | BE/FE | ✅ 完成 | RSA-OAEP-256 + 一次性 Nonce，保护登录/注册/改密接口 |
| 2026-05-19 | BUG-004 修复 + Redis 版本适配 | BE | ✅ 完成 | NonceService 移除 GETDEL，兼容 Redis 3.2.100 |
| 2026-05-19 | BUG-005 修复: RSA OAEP MGF1 参数对齐 | BE | ✅ 完成 | 显式指定 MGF1 SHA-256，对齐前端 Web Crypto API |
| 2026-05-19 | 自动检测网站图标功能 | BE/FE | ✅ 完成 | 后端增强 fetchFavicon 爬取页面解析 <link rel="icon">；前端输入 URL 防抖自动检测并填充图标 |
| 2026-05-19 | 图标上传功能改造 | BE/FE | ✅ 完成 | 新增 POST /nav/icon/upload；文件类型/大小/频率三关卡安全限制；前端上传流从 Base64 改为后端上传 |

---

## 文档同步记录

| 日期 | 文档 | 变更摘要 |
|------|------|----------|
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
| 2026-05-18 | `App.tsx` | 集成 TodoPanel、react-dnd 拖拽、next-themes 主题
| 2026-05-18 | `rsa-login-encryption-design.md` | 新建：RSA 加密登录设计方案 |
| 2026-05-18 | `api-specification.md` | 新增 /auth/nonce 端点，更新登录/注册/改密为 RSA 加密传输 |
| 2026-05-19 | `backend-architecture.md` | Redis 版本从 7.x 更新为 3.2.100 |
| 2026-05-18 | `backend-architecture.md` | 安全设计章节引用 RSA 加密设计文档 |
| 2026-05-18 | `WORKFLOW-STATUS.md` | 同步 RSA 加密开发记录 |
| 2026-05-19 | `NavService.java` | 增强 fetchFavicon：实际请求页面 HTML 解析 <link rel="icon"> 标签提取真实图标，超时 5s 回退 /favicon.ico |
| 2026-05-19 | `AddShortcutDialog.tsx` | 自定义网址输入框增加防抖自动检测网站图标，显示加载/成功/失败状态 |
| 2026-05-19 | `ResourceConfig.java` | 新增：映射 /uploads/** 到文件系统，使上传文件可 HTTP 访问 |
| 2026-05-19 | `NavController.java`, `NavService.java` | 新增 POST /nav/icon/upload：文件类型白名单/200KB/Redis 30次/小时频率限制 |
| 2026-05-19 | `AddShortcutDialog.tsx` | 图标上传改为调用后端接口，替换 FileReader Base64 方案 |
| 2026-05-19 | `api-specification.md` | 新增图标上传 API 文档 |

---

## Bug 追踪

| ID | 严重级别 | 描述 | 状态 | 修复日期 |
|----|----------|------|------|----------|
| BUG-001 | 🔴 P0 阻塞 | MySQL JDBC `characterEncoding=utf8mb4` 不被 Connector-J 识别，首次数据库操作 500 | ✅ 已修复 | 2026-05-18 |
| BUG-002 | 🟠 P1 严重 | 前端快捷方式与设置无持久化（页面刷新即丢失） | ✅ 已修复 | 2026-05-18 |
| BUG-003 | 🟠 P1 严重 | 登录注册入口 Profile 按钮无效 | ✅ 已修复 | 2026-05-18 |
| BUG-004 | 🔴 P0 阻塞 | 登录接口 500：`GETDEL` 命令不兼容 Redis 3.2.100 | ✅ 已修复 | 2026-05-19 |
| BUG-005 | 🔴 P0 阻塞 | 登录 RSA 解密失败：Java MGF1 默认 SHA-1 与前端 Web Crypto SHA-256 不匹配 | ✅ 已修复 | 2026-05-19 |
