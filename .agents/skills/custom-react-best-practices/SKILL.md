---
name: custom-react-best-practices
description: Use when creating or refactoring React components. Contains critical performance rules and hooks best practices.
---

# React Best Practices (Vite/Client-side SPA)

当编写、重构或审查 React 代码时，必须严格遵守以下优化规则，避免性能“水桶效应”：

## 1. 消除网络瀑布流 (Eliminate Waterfalls) - CRITICAL
- **不要串行拉取数据**：如果一个组件需要加载多个相互独立的数据源，必须使用 `Promise.all()` 并发请求，不要写成连续的 `await`。
- **状态提升或预拉取**：如果子组件的数据依赖父组件的数据，尽可能在父级并发拉取所有所需数据并通过 props 传递，避免子组件在父组件渲染完成后才开始请求。

## 2. 重新渲染优化 (Re-render Optimization) - HIGH
- **局部状态管理**：将频繁变化的状态（如输入框内容、拖拽坐标）封装在最小的可独立渲染子组件中，防止引起全局或大范围的 Re-render。
- **慎用 useMemo/useCallback**：不要盲目给所有函数加 `useCallback`。只有当把函数作为 Prop 传给经过 `React.memo` 包装的子组件，或者函数是某个 `useEffect` 的依赖项时，才需要使用它们。
- **Key 的正确使用**：列表渲染中绝对禁止使用 `index` 作为 `key`（除非列表永不重排序、新增或删除），必须使用唯一 ID。

## 3. 组件设计与状态 (Component Architecture) - MEDIUM
- **单一职责**：当一个组件超过 200 行代码或承担多种视觉/逻辑职责时，必须拆分。
- **衍生状态计算**：不要在 `useEffect` 中根据一个 state 去 `setState` 另一个 state。任何可以在渲染阶段直接计算出来的值，都应该直接计算（必要时用 `useMemo` 包裹）。

## 4. 依赖优化 (Bundle Size) - HIGH
- 永远不要全量引入图标库（例如 `import * as Icons`），仅按需导入所需的具体模块。
- 复杂运算库（如庞大的 Excel 导出、PDF 生成模块）应使用 React 的 `lazy` 和 `Suspense` 进行动态按需加载。
