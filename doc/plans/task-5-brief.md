## Global Constraints

- 前端: React 18 (TypeScript) + Vite + Tailwind CSS 4 + shadcn/ui
- 后端: Spring Boot 3.3.5 + Java 17 + MyBatis-Plus + MySQL + Redis
- 严格遵循中英文排版规范
- 拖拽必须隔离管理员模式
- 收尾流程必须调用 custom-finish-development-task 技能

### Task 5: Implement Stack Creation Flow

**Files:**
- Modify: `c:/workspace/my-workspace/navatation/navatation-web/src/app/components/shortcut/ShortcutGrid.tsx`

**Interfaces:**
- Consumes: `IconEntryModal` `onSelectStack` callback.

- [ ] **Step 1: Create a Stack creation utility**

When `IconEntryModal` triggers `onSelectStack`, the user is intending to create a new empty stack.
- Generate a new UUID for `dragId`.
- Set default name to "未命名文件夹".
- Insert a new `StackShortcut` into the shortcuts list.
  ```typescript
  import { v4 as uuidv4 } from 'uuid';

  const newStack: StackShortcut = {
    type: 'stack',
    dragId: uuidv4(),
    name: '未命名文件夹',
    children: []
  };
  ```
- Dispatch state update to append this to the user's shortcuts list. Ensure you use the exact function provided by the context or props to save the new shortcut list (e.g. `onOrderChange` or however the component handles adding a new item).

- [ ] **Step 2: Commit**

```bash
git add navatation-web/src/app/components/shortcut/ShortcutGrid.tsx
git commit -m "feat: implement stack creation flow"
```
