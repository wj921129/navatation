# 图标堆叠 (Icon Stack) 功能设计规范

## 1. 业务目标与背景
为现有的导航网站桌面图标系统引入「图标堆叠（Icon Stack）」功能。用户可以将多个单一网页图标聚合成一个类似文件夹的“堆叠组”，从而更高效地管理桌面空间。

## 2. 核心数据模型 (JSON 结构)
采用辨识联合类型 (Discriminated Union) 区分“普通图标”和“堆叠组”，并向下兼容现有的数据结构。

```typescript
// 基础节点
export interface BaseShortcut {
  dragId: string; // 用于 DND 的唯一标识
  name: string;
  type?: 'single' | 'stack'; // 历史数据默认为 single
}

// 单一图标 (继承原有 RecommendedSite 结构)
export interface SingleShortcut extends BaseShortcut {
  type: 'single' | undefined;
  url: string;
  iconType: 'FAVICON' | 'CUSTOM_UPLOAD' | 'BUILTIN' | 'CUSTOM_URL';
  iconValue?: string;
  color?: string;
}

// 堆叠组
export interface StackShortcut extends BaseShortcut {
  type: 'stack';
  children: SingleShortcut[]; // 内部包含的单一图标列表
}

export type DesktopItem = SingleShortcut | StackShortcut;
```

## 3. 视觉与交互规范

### 3.1 添加入口重构 (磨玻璃弹窗)
* **触发方式**：在【编辑模式】下点击“添加图标”占位符按钮。
* **表现形式**：全局居中的磨玻璃效果 (Glassmorphism) 弹窗。
* **包含选项**：
  1. 「添加单一网址」：点击后进入原有的添加流程。
  2. 「创建图标堆叠」：点击后直接在桌面上生成一个匿名的空壳【堆叠组】图标。

### 3.2 桌面的堆叠组视图
* **未展开形态**：采用 **iOS 文件夹样式 (2x2 网格)**。在与普通图标同等大小的毛玻璃方块内，缩小显示其 `children` 数组中的前 4 个图标。若无图标则留空。
* **展开交互**：非编辑模式或编辑模式下点击该【堆叠组】，背景整体变暗模糊，在**屏幕正中央弹出一个大尺寸毛玻璃面板 (Center Modal)**，以标准网格形式展示内部的所有 `SingleShortcut`。

### 3.3 拖拽合并逻辑 (Overlap Detection)
* **重叠判定**：基于 `@dnd-kit/core` 的 `onDragEnd` 事件。
* **触发条件**：当用户松开拖拽的图标时，计算 `active` 节点与目标 `over` 节点的矩形相交面积。若**相交面积 / 目标面积 > 50%**，判定为触发“合并并入”动作。
* **合并规则**：
  * `Single` -> `Single`：创建一个全新的 `Stack`，将两者作为 `children` 放入。
  * `Single` -> `Stack`：将拖拽的 `Single` 推入目标的 `children` 数组中。
  * *暂不考虑 `Stack` 合并到 `Stack`。*

### 3.4 逻辑隔离 (编辑模式与管理员模式)
由于系统中同时存在管理员维度的排序功能，必须在拖拽回调的顶端进行严格的权限拦截：
```typescript
function handleDragEnd(event: DragEndEvent) {
  // 1. 如果是管理员模式，交由管理员专用逻辑处理并退出
  if (isAdminMode) {
    return handleAdminDragEnd(event);
  }
  
  // 2. 如果不是编辑模式，直接退出
  if (!isEditMode) return;
  
  // 3. 执行上述的碰撞面积检测与 Stack 合并逻辑
  // ...
}
```

## 4. 组件拆分建议
1. **`IconEntryModal`**: 负责取代直接弹出原添加框的中间磨玻璃选项弹窗组件。
2. **`ShortcutStackItem`**: 负责在 `ShortcutGrid` 中渲染 2x2 样式的堆叠组外观。
3. **`ShortcutStackExpandedModal`**: 负责居中展示堆叠组内部列表的全屏遮罩大弹窗组件。

## 5. 待确定事项 / TODO
- (无，规范清晰明确，直接按方案 B 判定合并，无需 setTimeout 计时器)
