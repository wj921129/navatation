# 游客与常用网址图标本地化修复实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 解决生产（prd）和开发环境下，游客访问首页时，常用网址图标直接请求互联网上的外部链接（如 `https://github.com/favicon.ico`）的问题，调整为自动下载并读取本地配置的静态资源图标，实现历史外部图标的自愈下载与新图标的防污拦截。

**Architecture:** 
1. 在后端的 `HomeShortcutService` 注入 `FaviconFetcherHelper`。
2. 封装 `localizeIcon` 方法用于外部 Favicon 下载和本地化转换。
3. 在 `addHomeShortcut` 与 `updateHomeShortcut` 保存数据前拦截处理图标为本地路径。
4. 在 `toVO` 重载中对已经存在的外部 URL（如历史数据）自动触发下载和数据库更新，并清除游客 Redis 缓存，保证完全自愈。

**Tech Stack:** Java 17, Spring Boot, MyBatis-Plus, Redis

## Global Constraints
- 开发时需确保代码语法正确，测试能够正常编译通过。
- 所有的修改在提交前运行构建命令确保正确性。

---

### Task 1: 修改后端的 `HomeShortcutService` 以引入 `FaviconFetcherHelper` 并实现图标本地化及自愈逻辑

**Files:**
- Modify: [HomeShortcutService.java](file:///c:/workspace/my-workspace/navatation/navatation-admin/navatation-business/src/main/java/com/navatation/business/service/HomeShortcutService.java)

**Interfaces:**
- Consumes: `FaviconFetcherHelper.downloadToLocal(String url, String host)`
- Produces: 游客与用户的 Home Shortcuts API 图标路径全部变成本地 `/uploads/` 相对路径。

- [ ] **Step 1: 在 `HomeShortcutService.java` 中引入依赖和注解**
  修改 `HomeShortcutService.java` 类，加上 `@Slf4j` 并注入 `FaviconFetcherHelper`。

  ```java
  package com.navatation.business.service;
  
  import lombok.extern.slf4j.Slf4j;
  import com.navatation.business.helper.FaviconFetcherHelper;
  
  @Service
  @RequiredArgsConstructor
  @Slf4j
  public class HomeShortcutService {
      // ...
      private final FaviconFetcherHelper faviconFetcherHelper;
  ```

- [ ] **Step 2: 在 `HomeShortcutService.java` 中增加 `localizeIcon` 辅助方法**
  增加 `localizeIcon` 方法将外部图标下载到本地。

  ```java
      private String localizeIcon(String iconType, String iconValue, String shortcutUrl) {
          if (!"FAVICON".equals(iconType) || iconValue == null || iconValue.isEmpty()) {
              return iconValue;
          }
          if (iconValue.startsWith("/uploads/")) {
              return iconValue;
          }
          if (!iconValue.startsWith("http://") && !iconValue.startsWith("https://")) {
              return iconValue;
          }
          try {
              String host = null;
              if (shortcutUrl != null && !shortcutUrl.isEmpty()) {
                  if (!shortcutUrl.startsWith("http://") && !shortcutUrl.startsWith("https://")) {
                      shortcutUrl = "http://" + shortcutUrl;
                  }
                  host = new java.net.URI(shortcutUrl).getHost();
              }
              if (host == null) {
                  host = new java.net.URI(iconValue).getHost();
              }
              if (host != null) {
                  return faviconFetcherHelper.downloadToLocal(iconValue, host);
              }
          } catch (Exception e) {
              log.warn("常用网址本地图标化失败 url: {}, error: {}", iconValue, e.getMessage());
          }
          return iconValue;
      }
  ```

- [ ] **Step 3: 修改 `addHomeShortcut` 与 `updateHomeShortcut` 保存逻辑**
  在将实体数据持久化到数据库之前，对其 `iconValue` 进行本地化。

  ```java
      public HomeShortcutRespDTO addHomeShortcut(String userId, HomeShortcutReqDTO req) {
          if (isAdmin(userId)) {
              RecommendHomeShortcut hs = new RecommendHomeShortcut();
              hs.setShortcutId(IdUtils.genShortcutId());
              hs.setName(req.getName());
              hs.setUrl(req.getUrl());
              hs.setIconType(req.getIconType() != null ? req.getIconType() : "BUILTIN");
              String localVal = localizeIcon(hs.getIconType(), req.getIconValue(), req.getUrl());
              hs.setIconValue(localVal);
              hs.setIconColor(req.getIconColor());
              hs.setSortOrder(req.getSortOrder() != null ? req.getSortOrder() : BigDecimal.ZERO);
              recommendHomeShortcutMapper.insert(hs);
              redisTemplate.opsForHash().delete("navatation:guest_config", "home_shortcuts");
              return toVO(hs);
          }
  
          NavHomeShortcut hs = new NavHomeShortcut();
          hs.setShortcutId(IdUtils.genShortcutId());
          hs.setUserId(userId);
          hs.setName(req.getName());
          hs.setUrl(req.getUrl());
          hs.setIconType(req.getIconType() != null ? req.getIconType() : "BUILTIN");
          String localVal = localizeIcon(hs.getIconType(), req.getIconValue(), req.getUrl());
          hs.setIconValue(localVal);
          hs.setIconColor(req.getIconColor());
          hs.setSortOrder(req.getSortOrder() != null ? req.getSortOrder() : BigDecimal.ZERO);
          navHomeShortcutMapper.insert(hs);
          return toVO(hs);
      }
  ```
  在 `updateHomeShortcut` 相应部分也调用 `localizeIcon`：
  ```java
      public HomeShortcutRespDTO updateHomeShortcut(String userId, String shortcutId, HomeShortcutReqDTO req) {
          if (isAdmin(userId)) {
              RecommendHomeShortcut hs = recommendHomeShortcutMapper.selectById(shortcutId);
              if (hs == null) throw new BizException(ResultCode.NOT_FOUND);
              if (req.getName() != null) hs.setName(req.getName());
              if (req.getUrl() != null) hs.setUrl(req.getUrl());
              if (req.getIconType() != null) hs.setIconType(req.getIconType());
              if (req.getIconValue() != null) {
                  String localVal = localizeIcon(req.getIconType() != null ? req.getIconType() : hs.getIconType(), req.getIconValue(), req.getUrl() != null ? req.getUrl() : hs.getUrl());
                  hs.setIconValue(localVal);
              }
              if (req.getIconColor() != null) hs.setIconColor(req.getIconColor());
              if (req.getSortOrder() != null) hs.setSortOrder(req.getSortOrder());
              recommendHomeShortcutMapper.updateById(hs);
              redisTemplate.opsForHash().delete("navatation:guest_config", "home_shortcuts");
              return toVO(hs);
          }
  
          NavHomeShortcut hs = navHomeShortcutMapper.selectById(shortcutId);
          if (hs == null || !hs.getUserId().equals(userId)) throw new BizException(ResultCode.NOT_FOUND);
          if (req.getName() != null) hs.setName(req.getName());
          if (req.getUrl() != null) hs.setUrl(req.getUrl());
          if (req.getIconType() != null) hs.setIconType(req.getIconType());
          if (req.getIconValue() != null) {
              String localVal = localizeIcon(req.getIconType() != null ? req.getIconType() : hs.getIconType(), req.getIconValue(), req.getUrl() != null ? req.getUrl() : hs.getUrl());
              hs.setIconValue(localVal);
          }
          if (req.getIconColor() != null) hs.setIconColor(req.getIconColor());
          if (req.getSortOrder() != null) hs.setSortOrder(req.getSortOrder());
          navHomeShortcutMapper.updateById(hs);
          return toVO(hs);
      }
  ```

- [ ] **Step 4: 修改 `toVO` 重载以支持在线老数据的自动本地化下载（自愈）**
  在 `toVO` 中动态检测以 `http://` 或 `https://` 开头的图标，并在此阶段执行自动本地化下载和数据库同步，同时清除对应的 Redis 游客配置缓存以同步最新数据。

  ```java
      private HomeShortcutRespDTO toVO(RecommendHomeShortcut hs) {
          HomeShortcutRespDTO vo = new HomeShortcutRespDTO();
          vo.setShortcutId(hs.getShortcutId());
          vo.setName(hs.getName());
          vo.setUrl(hs.getUrl());
          vo.setIconType(hs.getIconType());
          
          String iconValue = hs.getIconValue();
          if ("FAVICON".equals(hs.getIconType()) && iconValue != null && (iconValue.startsWith("http://") || iconValue.startsWith("https://"))) {
              String localVal = localizeIcon(hs.getIconType(), iconValue, hs.getUrl());
              if (localVal != null && !localVal.equals(iconValue)) {
                  iconValue = localVal;
                  hs.setIconValue(localVal);
                  recommendHomeShortcutMapper.updateById(hs);
                  redisTemplate.opsForHash().delete("navatation:guest_config", "home_shortcuts");
              }
          }
          
          vo.setIconValue(iconValue);
          vo.setIconColor(hs.getIconColor());
          vo.setSortOrder(hs.getSortOrder());
          return vo;
      }
  
      private HomeShortcutRespDTO toVO(NavHomeShortcut hs) {
          HomeShortcutRespDTO vo = new HomeShortcutRespDTO();
          vo.setShortcutId(hs.getShortcutId());
          vo.setName(hs.getName());
          vo.setUrl(hs.getUrl());
          vo.setIconType(hs.getIconType());
          
          String iconValue = hs.getIconValue();
          if ("FAVICON".equals(hs.getIconType()) && iconValue != null && (iconValue.startsWith("http://") || iconValue.startsWith("https://"))) {
              String localVal = localizeIcon(hs.getIconType(), iconValue, hs.getUrl());
              if (localVal != null && !localVal.equals(iconValue)) {
                  iconValue = localVal;
                  hs.setIconValue(localVal);
                  navHomeShortcutMapper.updateById(hs);
              }
          }
          
          vo.setIconValue(iconValue);
          vo.setIconColor(hs.getIconColor());
          vo.setSortOrder(hs.getSortOrder());
          return vo;
      }
  ```

---

## Verification Plan

### Automated Tests
- 本地重新编译后端：
  ```bash
  cd navatation-admin
  mvn clean compile
  ```
  预期：编译成功，无任何报错或类型不匹配。

### Manual Verification
1. 启动后端 and 前端服务。
2. 以管理员账号登录，在设置里向首页添加一个含有外部 Favicon 图标的新快捷网址（例如 Bilibili 或 Github），或者编辑一个已有的常用网址图标。
3. 退出登录（进入游客模式），刷新页面。
4. 查看网络面板中该常用网址图标的请求路径。
   - 预期：图标路径已被修改为以 `/uploads/icon/sys/` 或 `/uploads/icon/` 开头的本地服务器地址，而不再直接向 `https://github.com/favicon.ico` 这样的外部互联网地址发送请求。
5. 验证是否生成了本地图标文件（通常位于服务器的指定本地上传文件夹中）。
