# 📋 navatation 项目开发看板 (dev 分支)

> 维护者：项目经理（PM）| 最后更新：2026-05-26T23:59
> 
> 🔗 关联主线稳定看板：[主线稳定看板 (main 分支)](file:///e:/workspace/navatation/doc/WORKFLOW-STATUS.md)

---

## 当前开发版本状态 (dev 分支)

| 维度 | 状态 |
|------|------|
| 当前开发版本 | v1.0 MVP + 聚合AI搜索（增量已推 ✅） |
| 数据库 | DDL 已执行 ✅ (7 张表已建) |
| 后端进度 | 用户认证 API ✅ \| 导航管理 API ✅ \| 设置 API ✅ \| 待办事项 API ✅ |
| 前端进度 | 项目初始化 ✅ \| 主页面 UI ✅ \| Service 层 ✅ \| 组件 ✅ \| 登录联调 ✅ \| 待办面板 ✅ \| 拖拽排序 ✅ \| 主题切换 ✅ \| **聚合AI搜索层 ✅** |
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

---

## 前端进度详情 (navatation-web - dev 分支)

### 技术栈

- React 18 + Vite + TypeScript + TailwindCSS 4 + shadcn/ui + Radix UI
- 动画: motion (framer-motion)
- 图标: lucide-react
- 拖拽: react-dnd

### 业务组件

| 组件 | 说明 | 状态 |
|------|------|------|
| `App.tsx` | 主页面 (已添加 AI 搜索 Overlay 状态与联动组件) | ✅ UI/功能已完成 |
| `AiSearchOverlay.tsx` | **[NEW]** 聚合 AI 搜索看板（单轨/三轨并列/大师提炼/多轮追问） | ✅ 完美适配毛玻璃质感与流式渲染 |
| `SearchBox.tsx` | 搜索框组件 (已接入 AI 引擎拦截，支持应用内快捷搜索) | ✅ 已接入 |
| `SearchEngineSelect.tsx` | 引擎选择器 (已扩充 ChatGPT、通义千问、豆包、聚合AI搜索) | ✅ 已接入品牌 SVG 图标 |
| `LoginDialog.tsx` | 登录/注册弹窗 | ✅ 已对接 API & 完美深色模式适配 |
| `LogoutConfirmDialog.tsx` | 账号管理与登出确认弹窗 | ✅ 已对接 API & 完美深色模式适配 |
| `AddShortcutDialog.tsx` | 添加快捷方式弹窗 (推荐站点 + 自定义输入) | ✅ UI 完成 |
| `EditShortcutDialog.tsx` | 编辑快捷方式弹窗 | ✅ UI 完成 |
| `SettingsDialog.tsx` | 设置面板 (已支持排版/壁纸草稿存储与批量持久化) | ✅ UI 完成 |
| `TodoPanel.tsx` | 待办详情管理面板（支持复制/一键恢复/自适应矢量光标） | ✅ UI 完成 |

---

## 待完成事项 🔧 (dev 分支)

### 研发
- 无（聚合 AI 搜索研发第一阶段已完美收官，全部推送至 `dev`）

### 部署与集成
- [ ] 等待用户确认，执行合并至 `main` 主线分支

---

## 任务历史 (dev 分支)

| 日期 | 任务 | 角色 | 状态 | 备注 |
|------|------|------|------|------|
| 2026-05-26 | 聚合AI搜索与对比平台功能开发 | PM/FE | ✅ 完成 (已推dev) | 扩展搜索引擎选择器与输入框拦截机制；创建ChatGPT/通义千问/豆包/聚合SVG品牌图标；编写毛玻璃材质交互Overlay支持单轨专注与三分栏并列流式展示；集成“大师提炼总结”与二次提问功能；全量同步推送至dev分支 |
| 2026-05-26 | Git 双分支自动化研发工作流部署 | PM/FE | ✅ 完成 | 在三仓（主、前、后）部署同步本地与远端 dev 开发分支；设计并新建 scripts/push-dev.bat 实现对话结项自动增量 dev 提交；新建 scripts/main/merge-to-main.bat 合并脚本并规整开发规范至 GEMINI.md |
| 2026-05-26 | 扩展设置面板滑块调节范围 | FE | ✅ 完成 | 增加搜索框-上间距最大值至 600px；拓宽图标-上下间距取值范围为 8px - 120px，提升了高分辨率大屏设备上的布局可调性 |
| 2026-05-26 | 核心功能浅/深模式字体背景色彩大一统重构 | PM/FE | ✅ 完成 | 修复 TodoPanel 损坏语法截断并全局重构；统一待办功能、小组件工具栏（TopDock）、快捷网址图标底色（App/DraggableShortcut）、搜索框大功能（SearchBox/SearchEngineSelect）为全新自适应 HSL 主题色彩系统 |
| 2026-05-26 | 账户管理深色模式适配与主题色封装优化 | PM/FE | ✅ 完成 | 在 theme.css 中封装 glass-panel 和 glass-button 自适应毛玻璃工具类，统一右下角控制按钮外观；重构 LoginDialog 和 LogoutConfirmDialog，解决深色模式下偏白刺眼的视觉缺陷，提供高级磨砂暗色体验 |
| 2026-05-25 | 屏幕背景亮度控制位置及防抖 Hover 交互优化 | FE | ✅ 完成 | 重构亮度卡片位置为垂直 Flex 流布局，零间隙咬合在 TopDock 正下方；引入 200ms 微防抖缓冲机制防止滑入二级滑块时“移出即关”死锁；优化卡片为 bg-black/45 高透磨砂黑精致护眼视觉效果，并与浅色模式完美亮度隔离 |
| 2026-05-25 | 业务 ID 逻辑 UUID 化、自增 row_id 引入与超长内容校验优化 | PM | ✅ 完成 | 全量 7 张表升级引入 row_id 物理自增主键，将逻辑主键升级为带前缀的 VARCHAR(64) UUID（U 用户/UC 配置/TD 待办等前缀）并完成前后端及 JWT 框架重构；在 DTO 层通过 @Size(max=512) 彻底修复待办内容过长导致 500 的 Bug |
| 2026-05-25 | 待办面板排版样式优化与按钮隐藏 | FE | ✅ 完成 | 在待办详情面板中隐藏未完成项删除按钮，并对待办列表项内容应用 line-clamp-5 与 break-all，限制每一项最长换行显示 5 行以优化排版表现 |
| 2026-05-24 | JDK 版本及编辑器配置加固 | PM | ✅ 完成 | 显式在 parent pom.xml 中配置并加固编译参数，并为 VSCode 写入工作区及后端的 `.vscode/settings.json`，彻底将编辑器与构建环境切换至 JDK 17 |
| 2026-05-18 | 工作流初始化 | PM | ✅ 完成 | 建立四角色协作体系 |

---

## 文档同步记录 (dev 分支)

| 日期 | 文档 | 变更摘要 |
|------|------|----------|
| 2026-05-26 | `WORKFLOW-STATUS-DEV.md` | 新建看板：全新创立 dev 专版开发进度文档，实现开发分支与稳定分支进度的双向彻底隔离 |
| 2026-05-26 | `WORKFLOW-STATUS.md` | 看板同步：新增聚合AI搜索与对比平台开发记录，并显式区分 Git dev 与 main 分支的开发隔离状态 |
| 2026-05-26 | `WORKFLOW-STATUS.md` | 看板同步：记录三仓本地与远端 dev 分支一键初始化及双分支自动提交合并脚本部署的开发记录 |
| 2026-05-26 | `WORKFLOW-STATUS.md` | 看板同步：记录扩展搜索框上边距最大值及图标上下间距取值范围的参数调整记录 |
| 2026-05-26 | `WORKFLOW-STATUS.md` | 看板同步：记录待办、小组件、快捷图标、搜索框等核心功能浅/深模式字体与背景配色大一统自适应重构的开发记录 |
| 2026-05-26 | `WORKFLOW-STATUS.md` | 看板同步：记录全局自适应毛玻璃主题色彩搭配封装及账户管理弹窗深色模式适配优化开发记录 |
| 2026-05-25 | `WORKFLOW-STATUS.md` | 看板同步：记录屏幕背景亮度卡片紧贴小组件以及防抖 Hover 复合交互优化的开发记录 |
| 2026-05-25 | `ddl.sql`, `backend-architecture.md`, `WORKFLOW-STATUS.md` | 看板同步：记录业务 ID UUID 逻辑重塑、row_id 自增引入、超长内容参数校验加固以及建表规则写入架构设计文档的开发记录 |
