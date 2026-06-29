## Global Constraints

- 前端: React 18 (TypeScript) + Vite + Tailwind CSS 4 + shadcn/ui
- 后端: Spring Boot 3.3.5 + Java 17 + MyBatis-Plus + MySQL + Redis
- 严格遵循中英文排版规范
- 拖拽必须隔离管理员模式
- 收尾流程必须调用 custom-finish-development-task 技能

### Task 4: Enhance ShortcutGrid logic (Add/Click)

**Files:**
- Modify: `c:/workspace/my-workspace/navatation/navatation-web/src/app/components/shortcut/ShortcutGrid.tsx`

**Interfaces:**
- Consumes: `IconEntryModal`, `StackExpandModal`

- [ ] **Step 1: Integrate Modals**

- Import and add `IconEntryModal` and `StackExpandModal` to the JSX rendering.
- State: `isIconEntryOpen`, `isStackExpandOpen`, `activeStack`.
- When clicking "Add Shortcut" (the plus button), open `IconEntryModal` instead of old prompt logic (if in edit mode).
- When clicking a `StackShortcut`, open `StackExpandModal`.
- When clicking a `SingleShortcut`, open the URL as usual.
- Ensure dragging a StackShortcut is possible in edit mode (handled generically by `DraggableShortcut`).

- [ ] **Step 2: Commit**

```bash
git add navatation-web/src/app/components/shortcut/ShortcutGrid.tsx
git commit -m "feat: integrate IconEntryModal and StackExpandModal into ShortcutGrid"
```
