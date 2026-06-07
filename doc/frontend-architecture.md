# Navatation 前端架构设计文档

## 1. 技术栈概览

- **核心框架**: React 18 + Vite
- **语言**: TypeScript
- **样式方案**: Tailwind CSS 4 + CSS Variables (主题切换)
- **UI 组件库**: shadcn/ui (Radix UI 底层) + Lucide React 图标库
- **动画**: Framer Motion
- **拖拽库**: react-dnd + react-dnd-html5-backend
- **包管理器**: npm

## 2. 核心目录树结构

经过模块化重构后的 `navatation-web/src` 核心目录结构如下：

```
src/
├── main.tsx                    # 应用入口，挂载 React 根节点与全局上下文
├── vite-env.d.ts               # Vite 环境变量与类型声明
├── config/                     # 全局配置
│   └── app.config.ts           # 应用级常量配置（默认壁纸、快捷方式预设等）
├── styles/                     # 全局样式系统
│   ├── index.css               # 样式总入口（汇总导入所有分层样式）
│   ├── tailwind.css            # Tailwind CSS v4 基础指令层
│   ├── theme.css               # 亮暗主题色 CSS 变量与自适应玻璃拟态工具类
│   └── globals.css             # 全局基础标签重置样式
└── app/
    ├── App.tsx                 # 主页面视图组件 (负责顶层交互组装与路由)
    ├── hooks/                  # 自定义业务逻辑 Hooks (负责状态管理分离)
    │   ├── useShortcuts.ts
    │   ├── useWidgets.ts
    │   ├── useSettings.ts
    │   ├── useClockMenu.ts
    │   └── useBrightness.ts
    ├── services/               # API 服务通信层 (负责调用后端接口)
    │   ├── api-client.ts       # 封装 Fetch 请求底座与拦截器
    │   ├── auth-service.ts
    │   ├── nav-service.ts
    │   ├── settings-service.ts
    │   ├── todo-service.ts
    │   └── widget-service.ts
    ├── stores/                 # 全局客户端状态库 (Zustand等)
    │   ├── auth-store.ts
    │   └── todo-store.ts
    └── components/             # 核心视图组件 (按业务域模块化划分)
        ├── search/             # [业务域] 搜索相关
        │   ├── SearchBox.tsx          # 页面中心搜索输入框
        │   ├── SearchEngineSelect.tsx # 搜索引擎切换面板
        │   └── AiSearchOverlay.tsx    # 聚合 AI 提炼面板 (流式渲染)
        ├── shortcut/           # [业务域] 快捷导航相关
        │   ├── DraggableShortcut.tsx  # 桌面快捷方式图标 (支持拖拽)
        │   ├── AddShortcutDialog.tsx  # 添加快捷方式弹窗
        │   └── EditShortcutDialog.tsx # 编辑快捷方式弹窗
        ├── todo/               # [业务域] 待办事项相关
        │   ├── TodoListWidget.tsx     # 桌面轻量级待办清单小组件
        │   └── TodoPanel.tsx          # 全局详情待办侧边抽屉
        ├── widgets/            # [业务域] 桌面微件相关
        │   ├── ClockWidget.tsx        # 时钟外壳容器
        │   ├── AnalogClock.tsx        # 模拟时钟视图
        │   ├── DigitalClock.tsx       # 数字时钟视图
        │   ├── FlipClock.tsx          # 翻页时钟视图
        │   ├── TraditionalClock.tsx   # 传统时钟视图
        │   ├── PomodoroWidget.tsx     # 番茄钟专注微件
        │   ├── BreatheWidget.tsx      # 呼吸冥想专注微件
        │   ├── CalendarWidget.tsx     # 日历外壳容器
        │   ├── MonthCalendar.tsx      # 月历视图
        │   ├── WeatherWidget.tsx      # 天气外壳容器
        │   └── SimpleWeather.tsx      # 简单天气视图
        ├── auth/               # [业务域] 账号授权相关
        │   ├── LoginDialog.tsx        # 登录与注册弹窗
        │   └── LogoutConfirmDialog.tsx# 登出确认与账户面板
        ├── settings/           # [业务域] 全局设置相关
        │   └── SettingsDialog.tsx     # 主题、壁纸、排版控制面板
        ├── dock/               # [业务域] 顶栏控制相关
        │   └── TopDock.tsx            # 顶部鱼眼放大快捷工具栏
        └── ui/                 # [底层域] 纯净基础 UI 组件库
            ├── IconMap.ts             # 矢量图标映射池
            └── utils.ts               # Tailwind 类名合并工具
```

## 3. 数据流架构设计

前端架构遵循严格的单向数据流与逻辑视图分离原则：

1. **Service 层 (`services/`)**：封装底层 HTTP 请求（基于 `api-client.ts`），处理 Request / Response 的转换以及 Token 的无感传递。禁止在此层操作 UI 或 LocalStorage（Token 持久化除外）。
2. **Store 层 (`stores/`)**：通过发布-订阅模式管理全局跨组件状态（如用户登录态 `auth-store.ts`，全局待办状态 `todo-store.ts`），保证多组件数据同源响应。
3. **Hook 层 (`hooks/`)**：将复杂的业务逻辑从组件中剥离，包含缓存同步、数据迁移和组件特有的编排逻辑（如 `useWidgets.ts` 负责云端/本地小组件双向同步及拖拽坐标缓存）。
4. **Component 层 (`components/`)**：完全按**业务功能域**划分为 7 大模块。组件仅负责视图渲染、事件绑定和读取 Hook 暴露的装配方法，实现 Dumb & Smart Component 彻底分离。

## 4. 样式管理体系

采用 Tailwind CSS 辅以 CSS Variables 的组合方案：
- **全局色彩响应**：在 `theme.css` 中注入了标准 HSL 色彩变量，实现 `text-text-primary`、`bg-widget-bg` 等语义化工具类，让全站对暗黑模式的自适应成本降到极低。
- **动态毛玻璃质感**：沉淀了如 `glass-panel`、`glass-button` 实用组合，利用 `backdrop-blur` 和带透明度的背景色结合实现高级质感，在性能与美学之间取得绝佳平衡。
