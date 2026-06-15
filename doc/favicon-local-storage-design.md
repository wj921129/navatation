# 推荐图标本地化存储设计

> 日期：2026-06-15
> 方案：Admin 触发本地化（方案 A）

## 1. 背景与目标

### 问题
- recommend 表中 `icon_value` 全部指向外部 CDN（DuckDuckGo / Google CDN）
- 客户端浏览器直接请求外部 URL 获取图标，在国内网络环境下频繁加载失败
- `/api/v1/nav/favicon` 只返回单个图标 URL，用户无多候选选择

### 目标
1. Admin 确认的图标下载到本地存储，客户端从本服务器加载，彻底消除外部依赖
2. 后端 HTML 解析增强，返回页面中所有图标候选，供用户选择
3. 图标路径通过配置文件管理，使用相对路径存储

## 2. 架构设计

### 数据流

```
改造前：Admin 刷新 → 后端返回 1 个外部 URL → 保存到 DB → 客户端请求外部 CDN
改造后：Admin 刷新 → 后端解析 HTML 返回多候选 URL → Admin 选择 → 保存时后端下载到本地 → DB 存本地路径 → 客户端请求本服务器
```

### 变更范围

| 层级 | 文件 | 变更点 |
|------|------|--------|
| 配置 | `application.yml` | 新增 `sys-icon-path` 配置项 |
| 配置 | `ResourceConfig.java` | 新增 `/uploads/icon/sys/**` 静态资源映射 |
| DTO | `FaviconRespDTO.java` | `faviconUrl` → `faviconUrls`（List） |
| Helper | `FaviconFetcherHelper.java` | HTML 多图标解析 + `downloadToLocal()` 方法 |
| Service | `NavShortcutService.java` | 保存时自动下载外部图标到本地 |
| 前端类型 | `nav-service.ts` | 适配 `faviconUrls` 数组响应 |
| 前端 Hook | `useFaviconDetector.ts` | 遍历数组注册多候选图标 |
| 前端 Hook | `useManageHomepageIcons.ts` | 同上 |

## 3. 后端详细设计

### 3.1 配置层

`application.yml` 新增：

```yaml
app:
  upload:
    sys-icon-path: ${APP_UPLOAD_SYS_ICON_PATH:../data/sys_data/icon}
```

物理路径：`navatation-admin/data/sys_data/icon/`

### 3.2 静态资源映射

`ResourceConfig.java` 新增：

```java
@Value("${app.upload.sys-icon-path}")
private String sysIconPath;

// addResourceHandlers 中追加
registry.addResourceHandler("/uploads/icon/sys/**")
        .addResourceLocations("file:" + new File(sysIconPath).getAbsolutePath() + "/");
```

### 3.3 DTO 变更

`FaviconRespDTO.java`：

```java
// 改造前
private String faviconUrl;

// 改造后
private List<String> faviconUrls;
```

### 3.4 FaviconFetcherHelper 改造

#### HTML 多图标解析

`tryExtractFromHtml` 返回值从 `String` 改为 `List<String>`：

```java
// CSS 选择器覆盖所有图标类型
Elements iconElements = doc.select(
    "link[rel~=(?i)^(apple-touch-icon|apple-touch-icon-precomposed|icon|shortcut icon)$]"
);
// 遍历提取 href，解析为绝对路径，去重后返回
```

#### 新增 downloadToLocal 方法

```java
/**
 * 将外部图标 URL 下载到本地 sys-icon-path 目录。
 * @param externalUrl 外部图标 URL
 * @param host 目标网站 host，作为文件名（如 youtube.com）
 * @return 本地相对路径（如 /uploads/icon/sys/youtube.com.png），失败时返回原始 externalUrl
 */
public String downloadToLocal(String externalUrl, String host);
```

实现要点：
- `HttpURLConnection` 下载图标字节流，超时 5 秒
- 根据 Content-Type 推断扩展名（image/png → `.png`，image/x-icon → `.ico`，默认 `.png`）
- 文件命名：`{host}.{ext}`（如 `youtube.com.png`）
- 文件已存在则跳过（幂等）
- 下载失败静默降级，返回原始 `externalUrl`

#### fetchFavicon 响应调整

```java
public FaviconRespDTO fetchFavicon(String url) {
    // ...
    List<String> faviconUrls = tryExtractAllFromHtml(url, scheme, host);
    if (faviconUrls.isEmpty()) {
        faviconUrls.add(scheme + "://" + host + "/favicon.ico");
    }
    // Redis 缓存改为 JSON 数组
    FaviconRespDTO vo = new FaviconRespDTO();
    vo.setFaviconUrls(faviconUrls);
    vo.setSourceUrl(url);
    return vo;
}
```

#### Redis 缓存

- Key 不变：`nav:favicon:{host}`
- Value 从 `String` 改为 JSON 序列化的 `List<String>`
- TTL 保持 7 天

### 3.5 NavShortcutService 保存时本地化

在 admin 保存快捷方式时（`addShortcut` / `updateShortcut` / `batchAddShortcuts`）：

```java
// 保存前检查
if ("FAVICON".equals(item.getIconType()) && isExternalUrl(item.getIconValue())) {
    String host = extractHost(item.getIconValue());
    String localPath = faviconFetcherHelper.downloadToLocal(item.getIconValue(), host);
    item.setIconValue(localPath);
}
```

`isExternalUrl` 判断：以 `http://` 或 `https://` 开头，且非本服务器路径。

## 4. 前端详细设计

### 4.1 类型适配

`nav-service.ts`：

```typescript
// 改造前
interface FaviconResult {
  faviconUrl: string;
  sourceUrl: string;
}

// 改造后
interface FaviconResult {
  faviconUrls: string[];
  sourceUrl: string;
}
```

### 4.2 Hook 适配

`useFaviconDetector.ts` 和 `useManageHomepageIcons.ts` 中：

```typescript
// 改造前
navService.fetchFavicon(fullUrl).then(res => {
  if (res.code === 200 && res.data?.faviconUrl) {
    updateIcon(res.data.faviconUrl);
  }
});

// 改造后
navService.fetchFavicon(fullUrl).then(res => {
  if (res.code === 200 && res.data?.faviconUrls) {
    res.data.faviconUrls.forEach(url => updateIcon(url));
  }
});
```

Google CDN 和 DuckDuckGo CDN 的前端探测逻辑保持不变，作为补充候选源。

## 5. 文件命名规则

本地存储的图标以目标网站 host 命名：

| 网站 URL | 本地文件名 |
|-----------|------------|
| `https://youtube.com` | `youtube.com.png` |
| `https://chat.openai.com` | `chat.openai.com.png` |
| `https://bilibili.com` | `bilibili.com.png` |

## 6. 初始数据迁移

Admin 首次执行批量刷新后，所有 recommend 表图标将本地化。需同步更新 `dml.sql` 初始化脚本中的 `icon_value`，将外部 CDN URL 替换为本地路径格式：

```sql
-- 改造前
('RS1', 'RC1', 'YouTube', 'https://youtube.com', 'FAVICON', 'https://icons.duckduckgo.com/ip3/youtube.com.ico', '#FF0000', 1, 0)

-- 改造后
('RS1', 'RC1', 'YouTube', 'https://youtube.com', 'FAVICON', '/uploads/icon/sys/youtube.com.ico', '#FF0000', 1, 0)
```

同时将对应的图标文件提交到 `navatation-admin/data/sys_data/icon/` 目录，纳入版本控制。

## 7. 文档同步

- `doc/api-specification.md`：更新 Favicon 接口响应结构（`faviconUrl` → `faviconUrls`）
