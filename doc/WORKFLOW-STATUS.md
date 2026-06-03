# 📋 navatation 项目稳定看板 (main 分支)

> 维护者：项目经理（PM）| 最后更新：2026-06-03T21:10
> 
> 🔗 关联开发看板：[开发进度看板 (dev 分支)](file:///e:/workspace/navatation/doc/WORKFLOW-STATUS-DEV.md)

---

## 当前主线稳定版本状态 (main 分支)

| 维度 | 状态 |
|------|------|
| 当前稳定版本 | v1.0 MVP |
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
| `LoginDialog.tsx` | 登录/注册弹窗 (已对接 authStore) | ✅ 已对接 API & 完美深色模式适配 |
| `LogoutConfirmDialog.tsx` | 账号管理与登出确认弹窗 (已对接 API) | ✅ 已对接 API & 完美深色模式适配 |
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
| 2026-06-03 | 职责隔离机制优化配置 | PM | ✅ 完成 | 修改 GEMINI.md 角色职责，允许项目经理（PM）在主会话中直接运行非源码、非 API 文档变动之外的所有管理任务（如服务启停、Git脚本等） |
| 2026-06-03 | 合并 dev 分支至 main 分支 | PM | ✅ 完成 | 成功由 PM 统筹、Git 子 Agent 执行合并脚本，将前端、后端、主仓库的 dev 分支合并至 main 并推送到远端，最后安全恢复至本地 dev 分支工作状态 |
| 2026-06-03 | 待办清单移动至屏幕右侧 | FE | ✅ 完成 | 将待办清单小组件（TodoListWidget）从屏幕左上角移至右上角，将待办事项抽屉面板（TodoPanel）从屏幕左侧移至右侧滑出，优化整体界面的右侧视觉联动 |
| 2026-06-02 | 修复设置面板保存不持久化 Bug | FE | ✅ 完成 | 修复由于 `useSettings` 钩子未在初始挂载或登录状态变更时调用 `fetchSettings`，且未将设置持久化到 `localStorage` 中，导致用户更改及后端配置刷新后失效的严重缺陷；引入完整的双模持久化机制（登录用户服务端秒级同步 + 游客本地 `localStorage` 长效保存），实现设置 100% 可靠持久化 |
| 2026-06-02 | 屏幕亮度面板向下垂直间距微调 | FE | ✅ 完成 | 响应用户界面交互视觉微调指令，将位于 TopDock 正下方的屏幕亮度卡片垂直定位（`top-[68px]` -> `top-[71px]`）向下位移 3px，提升小组件贴边和层次感 |
| 2026-06-02 | 首页顶部 TopDock 增加苹果鱼眼放大效果 | FE | ✅ 完成 | 仅对 TopDock 图标增加类似于 macOS Dock 的鱼眼悬浮放大动效，通过 React Refs、MouseMove 监听和平滑余弦（Bell Curve）插值公式实现极致丝滑的动态阻尼缩放，确保整体布局与其他文本完全不受影响，操作流畅自如 |
| 2026-05-26 | Git 双分支自动化研发工作流部署 | PM/FE | ✅ 完成 | 在三仓（主、前、后）部署同步本地与远端 dev 开发分支；设计并新建 scripts/push-dev.bat 实现对话结项自动增量 dev 提交；新建 scripts/main/merge-to-main.bat 合并脚本并规整开发规范至 GEMINI.md |
| 2026-05-26 | 扩展设置面板滑块调节范围 | FE | ✅ 完成 | 增加搜索框-上间距最大值至 600px；拓宽图标-上下间距取值范围为 8px - 120px，提升了高分辨率大屏设备上的布局可调性 |
| 2026-05-26 | 核心功能浅/深模式字体背景色彩大一统重构 | PM/FE | ✅ 完成 | 修复 TodoPanel 损坏语法截断并全局重构；统一待办功能、小组件工具栏（TopDock）、快捷网址图标底色（App/DraggableShortcut）、搜索框大功能（SearchBox/SearchEngineSelect）为全新自适应 HSL 主题色彩系统 |
| 2026-05-26 | 账户管理深色模式适配与主题色封装优化 | PM/FE | ✅ 完成 | 在 theme.css 中封装 glass-panel 和 glass-button 自适应毛玻璃工具类，统一右下角控制按钮外观；重构 LoginDialog 和 LogoutConfirmDialog，解决深色模式下偏白刺眼的视觉缺陷，提供高级磨砂暗色体验 |
| 2026-05-25 | 屏幕背景亮度控制位置及防抖 Hover 交互优化 | FE | ✅ 完成 | 重构亮度卡片位置为垂直 Flex 流布局，零间隙咬合在 TopDock 正下方；引入 200ms 微防抖缓冲机制防止滑入二级滑块时“移出即关”死锁；优化卡片为 bg-black/45 高透磨砂黑精致护眼视觉效果，并与浅色模式完美亮度隔离 |
| 2026-05-25 | 业务 ID 逻辑 UUID 化、自增 row_id 引入与超长内容校验优化 | PM | ✅ 完成 | 全量 7 张表升级引入 row_id 物理自增主键，将逻辑主键升级为带前缀的 VARCHAR(64) UUID（U 用户/UC 配置/TD 待办等前缀）并完成前后端及 JWT 框架重构；在 DTO 层通过 @Size(max=512) 彻底修复待办内容过长导致 500 的 Bug |
| 2026-05-25 | 待办面板排版样式优化与按钮隐藏 | FE | ✅ 完成 | 在待办详情面板中隐藏未完成项删除按钮，并对待办列表项内容应用 line-clamp-5 与 break-all，限制每一项最长换行显示 5 行以优化排版表现 |
| 2026-05-24 | JDK 版本及编辑器配置加固 | PM | ✅ 完成 | 显式在 parent pom.xml 中配置并加固编译参数，并为 VSCode 写入工作区及后端的 `.vscode/settings.json`，彻底将编辑器与构建环境切换至 JDK 17 |
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
| 2026-05-24 | 性能与代码规范深度优化重构 | PM | ✅ 完成 | 依据 Vercel React 最佳实践，创建 IconMap 消除 Lucide Barrel 导入，将主输入框 searchQuery 状态隔离到局部 SearchBox 杜绝全局重渲染，重写条件渲染 && 为三元，移除 TodoPanel 模块状态变量，打包体积剧降至 283KB |
| 2026-05-24 | 首页顶部新增 TopDock 多功能小组件工具栏 | FE | ✅ 完成 | 在首页顶部新增毛玻璃长方形工具栏，集成待办事项（隐藏右下角按钮并设置为第一个小组件）、随机壁纸（带优雅旋转动效）、一键皮肤切换、专注番茄倒计时（呼吸脉冲微动画）等多功能交互小组件 |
| 2026-05-24 | TopDock 工具栏样式细节调优 | FE | ✅ 完成 | 调整工具栏贴合浏览器顶部边沿（`top-0` + `rounded-b-2xl`），优化默认不透明度至优雅可见 of 70%（`opacity-70 backdrop-blur-md`）以防用户忽视，并实现移入时完全亮起（`opacity-100 backdrop-blur-xl`）的流畅毛玻璃悬浮动效 |
| 2026-05-24 | 扩展全局联动左上角待办看板小组件 | FE | ✅ 完成 | 设计自研响应式发布订阅 todoStore 全局共享数据，重构 TodoPanel 实现无缝联动；在首页左上角新增挂载胶囊长扁卡片 TodoListWidget（对齐 TopDock 的 70% opacity 悬停透亮交互），支持展示未完结待办事项，支持直接在主屏幕点击勾选快捷销项，点击空白处可一键开闭右侧管理抽屉 |
| 2026-05-24 | 待办面板侧边调整与看板交互抛光 | FE | ✅ 完成 | 将待办详情面板从右侧滑出修改为从左侧滑出（`left-0`），与左侧看板小组件位置对称；实现无未完结待办时左上角自动完全隐匿清单功能；应用 `line-clamp-3` 完美支持单行任务字数过长时自动最多折行 2 次（最多显示 3 行）的排版逻辑 |
| 2026-05-24 | 待办双击快捷复制与创建时间格式化显化 | FE | ✅ 完成 | 在待办详情面板双击编辑时，输入框右侧新增快捷复制按钮（`Copy` 图标，带 blur 防竞态拦截）；列表任务文字上方新增一行淡灰色极小号的创建时间信息，显示格式化为 `yyyy-MM-dd HH:mm:ss`，数据结构无缝对齐 |
| 2026-05-24 | 详情列表新增悬浮复制与已办事项一键恢复 | FE | ✅ 完成 | 在待办详情面板中，为所有（待办/已办）事项的悬浮操作组新增快捷复制按钮（`Copy` 图标），实现非编辑状态下一键复制；为已办事项的操作组额外新增一键恢复待办按钮（`RotateCcw` 旋转撤销图标），支持快捷驳回 |
| 2026-05-24 | 待办面板删除双击复制、支持专注详情视图与自适应暗色主题 | FE | ✅ 完成 | 移除行内双击复制；新增 FileText 详情按钮切换为沉浸式多行编辑卡片；重构面板及详情大卡片实现对 System 暗色主题的自适应优雅渲染，实现白昼与深夜模式完美呼应 |
| 2026-05-24 | 终极锁死待办列表与输入框的自适应黑/白自定义光标 | FE | ✅ 完成 | 通过 MutationObserver 实时监听 DOM 主题变化，在待办列表、双击 input、详情 textarea 全员绑定自适应 SVG 矢量工字形光标（Light下为高对比度黑色，Dark下为晶莹白色）；锁死 caret-gray-900/100 插入光标，彻底狙击并根治浅色/深色底下的鼠标隐匿Bug |
| 2026-05-24 | 夜间模式小图标背景色适配 | FE | ✅ 完成 | 修复 App.tsx 中编辑模式与正常模式下图标容器背景色硬编码为纯白的问题，统一改为 `bg-white dark:bg-neutral-700`，同时适配添加按钮的悬浮色为 `dark:hover:bg-neutral-600` |
| 2026-05-24 | base_rule 补充常量注释规范 | PM | ✅ 完成 | 在前端注释风格章节新增「常量注释」规则：所有 `const` 常量（含配置常量、枚举值、魔法数字）必须附带简洁的中文描述注释 |
| 2026-05-27 | 渐进式网址图标嗅探与提取性能重构 | PM/FE/BE | ✅ 完成 | 后端引入 Jsoup 依赖，重构为以浏览器 UA 进行 DOM 级图标提取，支持 `apple-touch-icon` 高清大图，并集成 Redis 7 天缓存层；前端在添加与编辑弹窗中引入「渐进式双路竞速」渲染机制，网址输入后毫秒级渲染 Google 64px CDN 图标进行瞬间预览，并在后台静默更新为后端获取的高清真实图标 |

---

## 文档同步记录

| 日期 | 文档 | 变更摘要 |
|------|------|----------|
| 2026-06-03 | `GEMINI.md` | 修改角色职责规范，授权 PM 直接执行日常运维与脚本，保留子 Agent 仅针对核心开发与 API 更新 |
| 2026-06-03 | `WORKFLOW-STATUS.md` | 看板同步：记录本次 dev 合并至 main 分支的归档记录 |
| 2026-06-03 | `WORKFLOW-STATUS.md` | 看板同步：记录待办清单小组件与详情抽屉面板移动到屏幕右侧的布局优化记录 |
| 2026-06-03 | `WORKFLOW-STATUS.md`, `base_rule.md`, `role-pm.md` | 看板同步：新增沟通称呼规则，限制项目经理（PM）在与用户（老板）沟通时均需显式称呼「老板」 |
| 2026-06-02 | `WORKFLOW-STATUS.md` | 看板同步：记录首页顶部 TopDock 快捷小组件工具栏中图标物理联动 macOS 阻尼鱼眼悬浮放大缩放效果的开发与上线记录 |
| 2026-05-27 | `WORKFLOW-STATUS.md` | 看板同步：记录基于前后端协作 of 渐进式网址图标探测优化、Jsoup 爬取加固及 Redis 缓存整合的开发记录 |
| 2026-05-26 | `WORKFLOW-STATUS.md` | 看板同步：记录三仓本地与远端 dev 分支一键初始化及双分支自动提交合并脚本部署的开发记录 |
| 2026-05-26 | `WORKFLOW-STATUS.md` | 看板同步：记录扩展搜索框上边距最大值及图标上下间距取值范围的参数调整记录 |
| 2026-05-26 | `WORKFLOW-STATUS.md` | 看板同步：记录待办、小组件、快捷图标、搜索框等核心功能浅/深模式字体与背景配色大一统自适应重构的开发记录 |
| 2026-05-26 | `WORKFLOW-STATUS.md` | 看板同步：记录全局自适应毛玻璃主题色彩搭配封装及账户管理弹窗深色模式适配优化开发记录 |
| 2026-05-25 | `WORKFLOW-STATUS.md` | 看板同步：记录屏幕背景亮度卡片紧贴小组件以及防抖 Hover 复合交互优化的开发记录 |
| 2026-05-25 | `ddl.sql`, `backend-architecture.md`, `WORKFLOW-STATUS.md` | 看板同步：记录业务 ID UUID 逻辑重塑、row_id 自增引入、超长内容参数校验加固以及建表规则写入架构设计文档的开发记录 |
| 2026-05-25 | `WORKFLOW-STATUS.md` | 看板同步：记录待办面板隐藏未完成项删除按钮以及列表 5 行折叠排版优化的开发记录 |
| 2026-05-24 | `WORKFLOW-STATUS.md` | 看板同步：记录夜间模式小图标背景色适配及 base_rule 常量注释规范新增 |
| 2026-05-24 | `WORKFLOW-STATUS.md` | 看板同步：追加添加与编辑网址弹窗自适应主题重构以及详情页边框纠正开发记录 |
| 2026-05-24 | `WORKFLOW-STATUS.md` | 看板同步：追加性能与 React 代码规范深度优化的开发记录 |
| 2026-05-24 | `WORKFLOW-STATUS.md` | 看板同步：追加删除双击复制并新增详情专注视图的开发与优化记录 |
| 2026-05-24 | `pom.xml`, `.vscode/settings.json`, `WORKFLOW-STATUS.md` | 在 parent pom.xml 中显式配置 JDK 17，配置编辑器 settings.json 锁定运行时为 JDK 17，并同步任务看板 |
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
