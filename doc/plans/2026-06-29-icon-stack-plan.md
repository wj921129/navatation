# Icon Stack Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement an iOS-style "Icon Stack" feature, allowing users to group multiple shortcuts into a 2x2 grid folder that expands into a centered modal upon click.

**Architecture:** Use discriminated unions to extend the existing `Shortcut` data structure into `SingleShortcut` and `StackShortcut`. Introduce a Glassmorphism choice modal for adding icons. Modify `@dnd-kit/core` drag lifecycle hooks to detect 50% overlap on `onDragEnd` to merge single icons into stacks, while strictly isolating Admin mode logic.

**Tech Stack:** React 18 (TypeScript), Vite, Tailwind CSS 4, shadcn/ui, @dnd-kit/core

## Global Constraints

- 前端: React 18 (TypeScript) + Vite + Tailwind CSS 4 + shadcn/ui
- 后端: Spring Boot 3.3.5 + Java 17 + MyBatis-Plus + MySQL + Redis
- 严格遵循中英文排版规范
- 拖拽必须隔离管理员模式
- 收尾流程必须调用 custom-finish-development-task 技能

---

### Task 1: Type Definitions Update

**Files:**
- Modify: `c:/workspace/my-workspace/navatation/navatation-web/src/app/constants/recommendedSitesData.ts` (or wherever the `Shortcut`/`RecommendedSite` is defined)

**Interfaces:**
- Produces: `SingleShortcut`, `StackShortcut`, `DesktopItem` types

- [ ] **Step 1: Update type definitions**

```typescript
export interface BaseShortcut {
  dragId: string;
  name: string;
  type?: 'single' | 'stack';
}

export interface SingleShortcut extends BaseShortcut {
  type: 'single' | undefined;
  url: string;
  iconType: 'FAVICON' | 'CUSTOM_UPLOAD' | 'BUILTIN' | 'CUSTOM_URL';
  iconValue?: string;
  color?: string;
  icon?: any; // To maintain compatibility
}

export interface StackShortcut extends BaseShortcut {
  type: 'stack';
  children: SingleShortcut[];
}

export type DesktopItem = SingleShortcut | StackShortcut;
```

- [ ] **Step 2: Commit**

```bash
git add navatation-web/src/app/constants/
git commit -m "feat: add StackShortcut types for icon stack feature"
```

---

### Task 2: Create IconEntryModal

**Files:**
- Create: `c:/workspace/my-workspace/navatation/navatation-web/src/app/components/shortcut/IconEntryModal.tsx`

**Interfaces:**
- Consumes: Nothing
- Produces: `IconEntryModal` React Component

- [ ] **Step 1: Create Glassmorphism UI Component**

```typescript
import { X, Globe, Layers } from 'lucide-react';

export function IconEntryModal({
  isOpen,
  onClose,
  onSelectSingle,
  onSelectStack
}: {
  isOpen: boolean;
  onClose: () => void;
  onSelectSingle: () => void;
  onSelectStack: () => void;
}) {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm animate-in fade-in duration-200">
      <div className="bg-white/80 dark:bg-gray-900/80 backdrop-blur-md rounded-2xl p-6 shadow-2xl w-full max-w-sm border border-white/20">
        <div className="flex justify-between items-center mb-6">
          <h2 className="text-xl font-semibold text-gray-800 dark:text-gray-100">添加图标</h2>
          <button onClick={onClose} className="text-gray-500 hover:text-gray-800 dark:hover:text-gray-200"><X size={20} /></button>
        </div>
        <div className="grid grid-cols-2 gap-4">
          <button onClick={onSelectSingle} className="flex flex-col items-center gap-3 p-4 rounded-xl bg-white/50 dark:bg-gray-800/50 hover:bg-white/80 dark:hover:bg-gray-700/80 transition-all border border-transparent hover:border-blue-500/30">
            <div className="w-12 h-12 rounded-full bg-blue-100 dark:bg-blue-900/30 flex items-center justify-center"><Globe className="text-blue-500" /></div>
            <span className="font-medium text-gray-700 dark:text-gray-200">单一网址</span>
          </button>
          <button onClick={onSelectStack} className="flex flex-col items-center gap-3 p-4 rounded-xl bg-white/50 dark:bg-gray-800/50 hover:bg-white/80 dark:hover:bg-gray-700/80 transition-all border border-transparent hover:border-purple-500/30">
            <div className="w-12 h-12 rounded-full bg-purple-100 dark:bg-purple-900/30 flex items-center justify-center"><Layers className="text-purple-500" /></div>
            <span className="font-medium text-gray-700 dark:text-gray-200">图标堆叠</span>
          </button>
        </div>
      </div>
    </div>
  );
}
```

- [ ] **Step 2: Commit**

```bash
git add navatation-web/src/app/components/shortcut/IconEntryModal.tsx
git commit -m "feat: add IconEntryModal for stack vs single choice"
```

---

### Task 3: Integrate IconEntryModal in ShortcutGrid

**Files:**
- Modify: `c:/workspace/my-workspace/navatation/navatation-web/src/app/components/shortcut/ShortcutGrid.tsx`

**Interfaces:**
- Consumes: `IconEntryModal`

- [ ] **Step 1: Add state and render modal**
Update `ShortcutGrid.tsx` to handle the choice before popping up the old AddShortcutDialog.

```typescript
// Add these lines inside the component
const [isEntryModalOpen, setIsEntryModalOpen] = useState(false);

// Modify the Plus button onClick:
// <button onClick={() => setIsEntryModalOpen(true)} ...>

// Render the modal at the bottom of ShortcutGrid
<IconEntryModal 
  isOpen={isEntryModalOpen} 
  onClose={() => setIsEntryModalOpen(false)}
  onSelectSingle={() => {
    setIsEntryModalOpen(false);
    setIsAddShortcutOpen(true);
  }}
  onSelectStack={() => {
    setIsEntryModalOpen(false);
    // TODO in later tasks: Add an empty stack to the list
  }}
/>
```

- [ ] **Step 2: Commit**

```bash
git add navatation-web/src/app/components/shortcut/ShortcutGrid.tsx
git commit -m "feat: integrate IconEntryModal into ShortcutGrid"
```

---

### Task 4: Create ShortcutStackItem Component

**Files:**
- Create: `c:/workspace/my-workspace/navatation/navatation-web/src/app/components/shortcut/ShortcutStackItem.tsx`

**Interfaces:**
- Consumes: `StackShortcut`

- [ ] **Step 1: Implement 2x2 grid visual component**
This component renders the 2x2 iOS-style folder preview.

```typescript
import { StackShortcut } from '../../constants/recommendedSitesData';
import { resolveAssetUrl } from '../../services/api-client';

export function ShortcutStackItem({ 
  shortcut, 
  iconSize, 
  borderRadius,
  onClick
}: { 
  shortcut: StackShortcut, 
  iconSize: number, 
  borderRadius: string,
  onClick: () => void
}) {
  const innerIcons = shortcut.children.slice(0, 4);
  const gap = 4;
  const padding = 6;
  const itemSize = (iconSize - padding * 2 - gap) / 2;

  return (
    <div 
      onClick={onClick}
      className="bg-white/20 dark:bg-black/20 backdrop-blur-md border border-white/10 dark:border-white/5 flex items-center justify-center shadow-lg hover:shadow-xl transition-all duration-200 cursor-pointer overflow-hidden relative"
      style={{
        width: `${iconSize}px`,
        height: `${iconSize}px`,
        borderRadius,
        padding: `${padding}px`
      }}
    >
      <div className="w-full h-full flex flex-wrap content-start" style={{ gap: `${gap}px` }}>
        {innerIcons.map((child, idx) => (
           <div key={child.dragId || idx} style={{ width: `${itemSize}px`, height: `${itemSize}px`, borderRadius: '4px', overflow: 'hidden', backgroundColor: child.color || '#e2e8f0', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
             {child.iconType === 'CUSTOM_URL' || child.iconType === 'FAVICON' || child.iconType === 'CUSTOM_UPLOAD' ? (
                <img src={resolveAssetUrl(child.iconValue!)} alt="" style={{ width: '60%', height: '60%', objectFit: 'contain' }} />
             ) : (
                <span className="text-xs text-white">...</span>
             )}
           </div>
        ))}
      </div>
    </div>
  );
}
```

- [ ] **Step 2: Commit**

```bash
git add navatation-web/src/app/components/shortcut/ShortcutStackItem.tsx
git commit -m "feat: create ShortcutStackItem for 2x2 folder rendering"
```

---

### Task 5: Implement Center Expanded Modal

**Files:**
- Create: `c:/workspace/my-workspace/navatation/navatation-web/src/app/components/shortcut/ShortcutStackExpandedModal.tsx`

**Interfaces:**
- Consumes: `StackShortcut`

- [ ] **Step 1: Implement the Modal**

```typescript
import { StackShortcut } from '../../constants/recommendedSitesData';

export function ShortcutStackExpandedModal({
  stack,
  isOpen,
  onClose,
  settings
}: {
  stack: StackShortcut | null;
  isOpen: boolean;
  onClose: () => void;
  settings: any;
}) {
  if (!isOpen || !stack) return null;

  return (
    <div className="fixed inset-0 z-[100] flex items-center justify-center bg-black/60 backdrop-blur-sm animate-in fade-in duration-200" onClick={onClose}>
      <div className="bg-white/70 dark:bg-gray-900/70 backdrop-blur-xl rounded-3xl p-8 shadow-2xl min-w-[300px] min-h-[300px] max-w-2xl max-h-[80vh] overflow-y-auto border border-white/20" onClick={e => e.stopPropagation()}>
         <h2 className="text-white text-2xl font-bold mb-6 text-center">{stack.name || '未命名文件夹'}</h2>
         <div className="flex flex-wrap justify-center gap-6">
            {/* We will map children and reuse the existing Shortcut renderer here */}
            {stack.children.map(child => (
               <div key={child.dragId} className="text-white">{child.name}</div>
            ))}
         </div>
      </div>
    </div>
  );
}
```

- [ ] **Step 2: Commit**

```bash
git add navatation-web/src/app/components/shortcut/ShortcutStackExpandedModal.tsx
git commit -m "feat: add center modal for expanded stack"
```

---

### Task 6: Overlap Detection & Merging Logic

**Files:**
- Modify: `c:/workspace/my-workspace/navatation/navatation-web/src/app/App.tsx`

**Interfaces:**
- Uses `@dnd-kit/core` hooks

- [ ] **Step 1: Update onDragEnd to merge on 50% overlap**

```typescript
// Inside handleDragEndGrid function in App.tsx
// Ensure Admin Mode is isolated
if (isAdminMode) {
  // admin logic
  return;
}

if (!isEditMode) return;

const activeRect = event.active.rect.current.translated;
const overRect = event.over.rect;

if (activeRect && overRect) {
  // Calculate overlap area
  const overlapX = Math.max(0, Math.min(activeRect.right, overRect.right) - Math.max(activeRect.left, overRect.left));
  const overlapY = Math.max(0, Math.min(activeRect.bottom, overRect.bottom) - Math.max(activeRect.top, overRect.top));
  const overlapArea = overlapX * overlapY;
  const overArea = overRect.width * overRect.height;
  
  if (overlapArea / overArea > 0.5) {
      // 50% Overlap Detected - Perform Merge
      // Find activeItem and overItem in customShortcuts
      // If overItem is Single -> Create Stack containing overItem and activeItem
      // If overItem is Stack -> Push activeItem into overItem.children
      // Update customShortcuts state and return!
      console.log('MERGE TRIGGERED');
      return; 
  }
}

// Proceed to normal sorting logic...
```

- [ ] **Step 2: Commit**

```bash
git add navatation-web/src/app/App.tsx
git commit -m "feat: implement 50% overlap logic for merging items into stacks"
```
