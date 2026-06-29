## Global Constraints

- 前端: React 18 (TypeScript) + Vite + Tailwind CSS 4 + shadcn/ui
- 后端: Spring Boot 3.3.5 + Java 17 + MyBatis-Plus + MySQL + Redis
- 严格遵循中英文排版规范
- 拖拽必须隔离管理员模式
- 收尾流程必须调用 custom-finish-development-task 技能

### Task 3: Create StackExpandModal

**Files:**
- Create: `c:/workspace/my-workspace/navatation/navatation-web/src/app/components/shortcut/StackExpandModal.tsx`

**Interfaces:**
- Consumes: `StackShortcut`
- Produces: `StackExpandModal` React Component

- [ ] **Step 1: Create Full-Screen Blur Modal**

```typescript
import { StackShortcut } from '../../constants/recommendedSitesData';

export function StackExpandModal({
  isOpen,
  onClose,
  stack
}: {
  isOpen: boolean;
  onClose: () => void;
  stack: StackShortcut | null;
}) {
  if (!isOpen || !stack) return null;

  return (
    <div 
      className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-xl animate-in fade-in duration-300"
      onClick={onClose}
    >
      <div 
        className="w-[80vw] h-[80vh] bg-transparent flex flex-col"
        onClick={e => e.stopPropagation()}
      >
        <div className="text-center mb-8">
          <h2 className="text-3xl font-bold text-white drop-shadow-md">{stack.name}</h2>
        </div>
        
        {/* Render grid reusing existing ShortcutGrid if possible, or mapping items */}
        <div className="flex-1 overflow-y-auto p-4">
          <div className="grid grid-cols-4 md:grid-cols-6 lg:grid-cols-8 gap-8 justify-items-center">
            {stack.children.map(child => (
              <div key={child.dragId} className="flex flex-col items-center gap-3 group">
                <a 
                  href={child.url}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="w-16 h-16 rounded-2xl bg-white/10 backdrop-blur-md flex items-center justify-center text-white group-hover:bg-white/20 group-hover:scale-105 transition-all cursor-pointer shadow-lg border border-white/5"
                >
                   {/* Simplified icon rendering, matching original desktop logic */}
                   <span className="text-2xl font-semibold">{child.name[0]}</span>
                </a>
                <span className="text-white text-sm font-medium drop-shadow-md truncate max-w-[80px] text-center">{child.name}</span>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
```

- [ ] **Step 2: Commit**

```bash
git add navatation-web/src/app/components/shortcut/StackExpandModal.tsx
git commit -m "feat: add StackExpandModal for rendering icon stack contents"
```
