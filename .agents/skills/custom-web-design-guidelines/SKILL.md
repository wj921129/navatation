---
name: custom-web-design-guidelines
description: Use when reviewing or building UI components. Audits accessibility (A11y), UX, interactions, and aesthetic details.
---

# Web UI & Design Guidelines

在编写前端 UI 代码时，严格遵守以下用户体验与界面交互最佳实践，确保应用具备“现代、精致、可访问”的特质：

## 1. 无障碍访问 (Accessibility / A11y) - CRITICAL
- **语义化标签**：能用 `<button>` 的地方绝不使用带有 `onClick` 的 `<div>`。
- **键盘导航**：所有交互元素必须可以通过 `Tab` 键获取焦点。对于自定义交互组件（如弹窗、下拉菜单），需要正确实现 `Esc` 关闭逻辑和焦点陷阱（Focus Trap）。
- **Aria 属性**：仅凭图标无法理解的按钮（如 X 图标的关闭按钮），必须加上 `aria-label="Close"` 或 `title="Close"`。

## 2. 焦点与状态可见性 (Focus & State) - HIGH
- **不要移除焦点环**：严禁全局设置 `outline: none;`，必须保留或自定义 `:focus-visible` 样式，确保键盘用户知道当前在哪。
- **操作反馈**：所有按钮、卡片、链接必须有清晰的 `:hover`、`:active`（按下）和 `:disabled`（禁用）状态样式。禁止用户在禁用按钮上操作时没有视觉提示。

## 3. 动画与交互 (Animation & Interaction) - MEDIUM
- **微动效 (Micro-interactions)**：使用 CSS `transition` 为 Hover 状态、展开/折叠、模态框弹出等提供 150ms-300ms 的平滑过渡。
- **性能友好的动画**：尽量只对 `transform` 和 `opacity` 进行动画处理，避免对 `width`、`height` 或 `margin` 制作动画（以防止频繁触发 Layout 回流）。
- **防抖与节流**：涉及滚动监听（Scroll）、窗口缩放（Resize）或搜索框连续输入的场景，必须强制包裹防抖（Debounce）或节流（Throttle）函数。

## 4. 表单与排版 (Forms & Typography) - MEDIUM
- **原生验证与错误提示**：输入框发生错误时，边框应变红，并提供明确的文字提示（不仅仅是图标）。
- **防重复提交**：表单在提交（请求后端接口）期间，必须将按钮设置为 Loading 或 Disabled 状态，防止用户狂点导致脏数据。
- **深色模式支持**：在定义颜色时，优先考虑使用设计系统的 CSS Variables（如 `var(--bg-primary)`）或者 Tailwind 的暗黑修饰符（如 `dark:bg-slate-800`），避免硬编码导致暗黑模式失效。
