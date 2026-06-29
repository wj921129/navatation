## Global Constraints

- 前端: React 18 (TypeScript) + Vite + Tailwind CSS 4 + shadcn/ui
- 后端: Spring Boot 3.3.5 + Java 17 + MyBatis-Plus + MySQL + Redis
- 严格遵循中英文排版规范
- 拖拽必须隔离管理员模式
- 收尾流程必须调用 custom-finish-development-task 技能

### Task 6: Create ShortcutStackItem Component

**Files:**
- Create: `c:/workspace/my-workspace/navatation/navatation-web/src/app/components/shortcut/ShortcutStackItem.tsx`
- Modify: `c:/workspace/my-workspace/navatation/navatation-web/src/app/components/shortcut/ShortcutGrid.tsx`

**Interfaces:**
- Consumes: `StackShortcut`

- [ ] **Step 1: Implement 2x2 grid visual component**

Create `ShortcutStackItem.tsx` that renders the 2x2 iOS-style folder preview for a stack.

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
           <div key={child.dragId || idx} style={{ width: `${itemSize}px`, height: `${itemSize}px`, borderRadius: '4px', overflow: 'hidden', backgroundColor: 'color' in child ? child.color : '#e2e8f0', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
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

- [ ] **Step 2: Use in ShortcutGrid**
In `ShortcutGrid.tsx`, where `StackShortcut` icons are currently rendered (e.g., using `Layers`), replace it with `<ShortcutStackItem>` if the shortcut type is a stack. Pass `onClick={() => handleShortcutClick(shortcut)}` or similar.

- [ ] **Step 3: Commit**
```bash
git add navatation-web/src/app/components/shortcut/ShortcutStackItem.tsx
git add navatation-web/src/app/components/shortcut/ShortcutGrid.tsx
git commit -m "feat: implement 2x2 grid visual component for StackShortcut"
```
