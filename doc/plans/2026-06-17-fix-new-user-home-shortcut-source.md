# Fix New User Homepage Shortcut Icons Source Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fix the data source logic for homepage shortcut icons so that newly registered users do not incorrectly display category-based shortcuts under their search box.

**Architecture:** 
1. In `HomeShortcutService.java`, add `.isNull(NavHomeShortcut::getCategoryId)` constraint when regular users retrieve homepage shortcuts, ensuring only shortcuts without category associations are fetched.
2. In `NavShortcutService.java`, add `.isNotNull(NavHomeShortcut::getCategoryId)` constraint when regular users retrieve category-based shortcuts with an empty/null `categoryId` query parameter, ensuring homepage shortcuts are excluded.

**Tech Stack:** Java 17, Spring Boot 3, MyBatis-Plus, MySQL

## Global Constraints
- Keep responses concise and use standard markdown.
- Ensure all business logic remains encapsulated in the `Service` layer.
- Strictly follow the coding standards including guard clauses and maximum 3 layers of indentation.
- Run `.\push-dev.bat` as the last step of this implementation.

---

### Task 1: Fix HomeShortcutService Homepage Shortcut Retrieval
Ensure only homepage shortcuts (with a null `category_id`) are retrieved.

**Files:**
- Modify: `navatation-admin/navatation-business/src/main/java/com/navatation/business/service/HomeShortcutService.java`

- [ ] **Step 1: Write implementation change in HomeShortcutService.java**

Modify `getHomeShortcuts` method in `HomeShortcutService.java`:
```java
    public List<HomeShortcutRespDTO> getHomeShortcuts(String userId) {
        if (isAdmin(userId)) {
            return recommendHomeShortcutMapper.selectList(
                    new LambdaQueryWrapper<RecommendHomeShortcut>()
                            .orderByAsc(RecommendHomeShortcut::getSortOrder)
            ).stream().map(this::toVO).collect(Collectors.toList());
        }

        return navHomeShortcutMapper.selectList(
                new LambdaQueryWrapper<NavHomeShortcut>()
                        .eq(NavHomeShortcut::getUserId, userId)
                        .isNull(NavHomeShortcut::getCategoryId)
                        .orderByAsc(NavHomeShortcut::getSortOrder)
        ).stream().map(this::toVO).collect(Collectors.toList());
    }
```

- [ ] **Step 2: Compile the backend to verify correctness**

Run in `C:\workspace\my-workspace\navatation\navatation-admin`:
`mvn clean compile`
Expected: BUILD SUCCESS

- [ ] **Step 3: Commit task changes**
```bash
git add navatation-admin/navatation-business/src/main/java/com/navatation/business/service/HomeShortcutService.java
git commit -m "fix: retrieve only category-free shortcuts for homepage icons"
```

---

### Task 2: Fix NavShortcutService Category Shortcut Retrieval
Exclude homepage shortcuts when querying category-based shortcuts with an empty/null categoryId.

**Files:**
- Modify: `navatation-admin/navatation-business/src/main/java/com/navatation/business/service/NavShortcutService.java`

- [ ] **Step 1: Write implementation change in NavShortcutService.java**

Modify `getShortcuts` method in `NavShortcutService.java`:
```java
    public List<ShortcutRespDTO> getShortcuts(String userId, String categoryId) {
        if (isAdmin(userId)) {
            LambdaQueryWrapper<RecommendShortcut> wrapper = new LambdaQueryWrapper<RecommendShortcut>()
                    .orderByAsc(RecommendShortcut::getSortOrder);
            if (StringUtils.hasText(categoryId)) {
                wrapper.eq(RecommendShortcut::getCategoryId, categoryId);
            }
            List<RecommendShortcut> list = recommendShortcutMapper.selectList(wrapper);
            return list.stream().map(this::toShortcutVO).collect(Collectors.toList());
        } else {
            LambdaQueryWrapper<NavHomeShortcut> wrapper = new LambdaQueryWrapper<NavHomeShortcut>()
                    .eq(NavHomeShortcut::getUserId, userId)
                    .orderByAsc(NavHomeShortcut::getSortOrder);
            if (StringUtils.hasText(categoryId)) {
                wrapper.eq(NavHomeShortcut::getCategoryId, categoryId);
            } else {
                wrapper.isNotNull(NavHomeShortcut::getCategoryId);
            }
            List<NavHomeShortcut> list = shortcutMapper.selectList(wrapper);
            return list.stream().map(this::toShortcutVO).collect(Collectors.toList());
        }
    }
```

- [ ] **Step 2: Compile the backend to verify correctness**

Run in `C:\workspace\my-workspace\navatation\navatation-admin`:
`mvn clean compile`
Expected: BUILD SUCCESS

- [ ] **Step 3: Commit and Push**
Run in `C:\workspace\my-workspace\navatation\scripts\git` or from workspace root:
`.\push-dev.bat "fix: newly registered user homepage shortcut icons data source"`
Expected: Push successfully to dev.
