## Global Constraints

- 前端: React 18 (TypeScript) + Vite + Tailwind CSS 4 + shadcn/ui
- 后端: Spring Boot 3.3.5 + Java 17 + MyBatis-Plus + MySQL + Redis
- 严格遵循中英文排版规范
- 拖拽必须隔离管理员模式
- 收尾流程必须调用 custom-finish-development-task 技能

### Task 7: Overlap Detection & Merging Logic

**Files:**
- Modify: `c:/workspace/my-workspace/navatation/navatation-web/src/app/App.tsx`

**Interfaces:**
- Uses `@dnd-kit/core` hooks

- [ ] **Step 1: Update onDragEnd to merge on 50% overlap**

In `navatation-web/src/app/App.tsx`, inside `handleDragEndGrid` function:
- Ensure Admin Mode is isolated (if `isAdminMode`, return early or bypass stack logic).
- Look at the `DragEndEvent` parameter. You can access bounding rects via `event.active.rect.current.translated` and `event.over.rect`.
  ```typescript
  if (isAdminMode) {
    // existing admin logic...
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
    
    if (overlapArea / overArea > 0.5 && active.id !== over.id) {
        // 50% Overlap Detected - Perform Merge
        // 1. Find activeItem and overItem in tempHomeShortcuts
        // 2. If overItem is Single -> Create a new StackShortcut containing overItem and activeItem. Remove activeItem, replace overItem with the Stack. (Give the Stack the dragId of the overItem, or a new UUID).
        // 3. If overItem is Stack -> Push activeItem into overItem.children, remove activeItem from the top level.
        // 4. Update tempHomeShortcuts state via setTempHomeShortcuts.
        // 5. return immediately so standard sorting doesn't happen!
        
        // **IMPORTANT:** Since activeItem is being removed from the top level, be sure to filter it out.
        return; 
    }
  }
  
  // Proceed to normal sorting logic (arrayMove etc)...
  ```

- [ ] **Step 2: Commit**

```bash
git add navatation-web/src/app/App.tsx
git commit -m "feat: implement 50% overlap logic for merging items into stacks"
```
