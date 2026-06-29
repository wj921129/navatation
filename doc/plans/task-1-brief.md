## Global Constraints

- 前端: React 18 (TypeScript) + Vite + Tailwind CSS 4 + shadcn/ui
- 后端: Spring Boot 3.3.5 + Java 17 + MyBatis-Plus + MySQL + Redis
- 严格遵循中英文排版规范
- 拖拽必须隔离管理员模式
- 收尾流程必须调用 custom-finish-development-task 技能

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
