# 极简网页浏览器新标签页 — 全量 RESTful API 接口文档

> 版本：v1.1 | 基础路径：`/api/v1` | 最后更新：2026-05-18

---

## 一、通用规范

### 1.1 基础 URL

```
开发环境: http://localhost:8080/api/v1
生产环境: https://api.navatation.com/api/v1
```

### 1.2 统一响应结构

所有接口返回以下 JSON 结构：

```json
{
  "code": 200,
  "message": "success",
  "data": { },
  "timestamp": 1715760000000
}
```

### 1.3 鉴权方式

除 `/auth/register`、`/auth/login`、`/auth/nonce` 外，所有接口需在 Header 中携带 JWT Token：

```
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...
```

> 登录/注册/改密接口使用 RSA 加密传输密码，详见 [RSA 加密登录设计](rsa-login-encryption-design.md)

### 1.4 状态码说明

| HTTP Status | code | 说明 |
|-------------|------|------|
| 200 | 200 | 请求成功 |
| 201 | 200 | 创建成功 |
| 400 | 400 | 请求参数校验失败 |
| 400 | 40003 | 请求已过期，请重新操作（nonce 无效或已消费） |
| 400 | 40004 | 数据解密失败（RSA 解密异常） |
| 401 | 401 | 未认证或 Token 过期 |
| 403 | 403 | 无权限 |
| 404 | 404 | 资源不存在 |
| 409 | 409 | 数据冲突 |
| 500 | 500 | 服务器内部错误 |

---

## 二、认证模块 `/auth`

### 2.1 获取加密参数 (Nonce + 公钥)

```
GET /api/v1/auth/nonce
```

无需登录。前端在调用登录/注册/改密前，先请求此接口获取一次性 nonce 和 RSA 公钥。

**Response (200):**

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "nonce": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "publicKey": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA...\n-----END PUBLIC KEY-----"
  },
  "timestamp": 1715760000000
}
```

| 字段 | 类型 | 说明 |
|------|------|------|
| nonce | String | 一次性 UUID v4，有效期 5 分钟，使用后立即失效 |
| publicKey | String | RSA 公钥 PEM 字符串，用于前端加密密码 |

> nonce 与加密数据绑定，防止重放攻击。详见 [RSA 加密登录设计](rsa-login-encryption-design.md)

**Error Response (400):**

```json
{
  "code": 40003,
  "message": "请求已过期，请重新操作",
  "data": null,
  "timestamp": 1715760000000
}
```

---

### 2.2 用户注册

```
POST /api/v1/auth/register
```

**Request Body:**

```json
{
  "username": "john_doe",
  "encryptedData": "<RSA-OAEP-256 加密后的 Base64 数据>",
  "nonce": "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
}
```

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| username | String | 是 | 用户名，3-20 字符，字母数字下划线 |
| encryptedData | String | 是 | RSA 加密数据：`password|confirmPassword|nonce` |
| nonce | String | 是 | 一次性挑战码，从 `/auth/nonce` 获取 |

> 加密流程：前端先请求 `GET /auth/nonce` 获取 nonce 和 RSA 公钥，然后用公钥加密 `password|confirmPassword|nonce`，将结果 Base64 编码后传入 `encryptedData`。详见 [RSA 加密登录设计](rsa-login-encryption-design.md)

**Response (201):**

```json
{
  "code": 200,
  "message": "注册成功",
  "data": {
    "userId": 10001,
    "username": "john_doe"
  },
  "timestamp": 1715760000000
}
```

**Error Response (409):**

```json
{
  "code": 409,
  "message": "用户名已存在",
  "data": null,
  "timestamp": 1715760000000
}
```

---

### 2.3 用户登录

```
POST /api/v1/auth/login
```

**Request Body:**

```json
{
  "username": "john_doe",
  "encryptedData": "<RSA-OAEP-256 加密后的 Base64 数据>",
  "nonce": "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
}
```

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| username | String | 是 | 用户名 |
| encryptedData | String | 是 | RSA 加密数据：`password|nonce` |
| nonce | String | 是 | 一次性挑战码，从 `/auth/nonce` 获取 |

> 加密流程：前端先请求 `GET /auth/nonce` 获取 nonce 和 RSA 公钥，然后用公钥加密 `password|nonce`，将结果 Base64 编码后传入 `encryptedData`。详见 [RSA 加密登录设计](rsa-login-encryption-design.md)

**Response (200):**

```json
{
  "code": 200,
  "message": "登录成功",
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMDAwMSIsI...",
    "refreshToken": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMDAwMSIsI...",
    "tokenType": "Bearer",
    "expiresIn": 7200,
    "userInfo": {
      "userId": 10001,
      "username": "john_doe",
      "avatar": null
    }
  },
  "timestamp": 1715760000000
}
```

**Error Response (401):**

```json
{
  "code": 401,
  "message": "用户名或密码错误",
  "data": null,
  "timestamp": 1715760000000
}
```

---

### 2.4 刷新 Token

```
POST /api/v1/auth/refresh
```

**Request Body:**

```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMDAwMSIsI..."
}
```

**Response (200):**

```json
{
  "code": 200,
  "message": "Token 刷新成功",
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMDAwMSIsI...",
    "refreshToken": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMDAwMSIsI...",
    "tokenType": "Bearer",
    "expiresIn": 7200
  },
  "timestamp": 1715760000000
}
```

---

### 2.5 用户登出

```
POST /api/v1/auth/logout
Authorization: Bearer {accessToken}
```

**Response (200):**

```json
{
  "code": 200,
  "message": "登出成功",
  "data": null,
  "timestamp": 1715760000000
}
```

---

### 2.6 获取当前用户信息

```
GET /api/v1/auth/me
Authorization: Bearer {accessToken}
```

**Response (200):**

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "userId": 10001,
    "username": "john_doe",
    "avatar": "https://oss.example.com/avatars/10001.png",
    "createdAt": "2026-01-15T10:30:00Z"
  },
  "timestamp": 1715760000000
}
```

---

### 2.7 修改密码

```
POST /api/v1/auth/change-password
Authorization: Bearer {accessToken}
```

**Request Body:**

```json
{
  "encryptedData": "<RSA-OAEP-256 加密后的 Base64 数据>",
  "nonce": "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
}
```

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| encryptedData | String | 是 | RSA 加密数据：`oldPassword|newPassword|confirmPassword|nonce` |
| nonce | String | 是 | 一次性挑战码，从 `/auth/nonce` 获取 |

> 加密流程：前端先请求 `GET /auth/nonce` 获取 nonce 和 RSA 公钥，然后用公钥加密 `oldPassword|newPassword|confirmPassword|nonce`，将结果 Base64 编码后传入 `encryptedData`。详见 [RSA 加密登录设计](rsa-login-encryption-design.md)

**Response (200):**

```json
{
  "code": 200,
  "message": "密码修改成功",
  "data": null,
  "timestamp": 1715760000000
}
```

---

### 2.8 用户重置密码 (找回密码)

```
POST /api/v1/auth/reset-password
```

**Request Body:**

```json
{
  "username": "john_doe",
  "email": "john_doe@example.com",
  "newPassword": "NewSecure@123",
  "confirmPassword": "NewSecure@123"
}
```

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| username | String | 是 | 用户名 |
| email | String | 是 | 绑定的邮箱 |
| newPassword | String | 是 | 新密码，6-32 字符 |
| confirmPassword | String | 是 | 确认新密码，需与 newPassword 一致 |

**Response (200):**

```json
{
  "code": 200,
  "message": "密码重置成功",
  "data": null,
  "timestamp": 1715760000000
}
```

**Error Response (400):**

```json
{
  "code": 40001,
  "message": "用户名与绑定邮箱不匹配",
  "data": null,
  "timestamp": 1715760000000
}
```

或

```json
{
  "code": 40002,
  "message": "用户未绑定邮箱，无法找回密码",
  "data": null,
  "timestamp": 1715760000000
}
```
---

## 三、导航管理模块 `/nav`

> **【全局权限说明】**：对于 `/api/v1/nav/categories` 和 `/api/v1/nav/shortcuts` 系列所有操作接口，如果当前登录用户为 `ADMIN`，则所有增删改查操作会被静默路由至 **推荐表 (`navatation_recommend_category` / `navatation_recommend_site`)**，而不是用户的私人表，从而实现“管理员的首页即全局推荐首页”。

### 3.1 分类管理

#### 3.1.1 获取导航分类列表

```
GET /api/v1/nav/categories
Authorization: Bearer {accessToken}
```

**Response (200):**

```json
{
  "code": 200,
  "message": "success",
  "data": [
    {
      "categoryId": 1,
      "name": "常用",
      "sortOrder": 1,
      "shortcutCount": 9
    },
    {
      "categoryId": 2,
      "name": "工具",
      "sortOrder": 2,
      "shortcutCount": 4
    }
  ],
  "timestamp": 1715760000000
}
```

#### 3.1.2 创建导航分类

```
POST /api/v1/nav/categories
Authorization: Bearer {accessToken}
```

**Request Body:**

```json
{
  "name": "常用",
  "sortOrder": 1
}
```

**Response (201):**

```json
{
  "code": 200,
  "message": "创建成功",
  "data": {
    "categoryId": 3,
    "name": "常用",
    "sortOrder": 1
  },
  "timestamp": 1715760000000
}
```

#### 3.1.3 更新导航分类

```
PUT /api/v1/nav/categories/{categoryId}
Authorization: Bearer {accessToken}
```

**Request Body:**

```json
{
  "name": "工作常用",
  "sortOrder": 2
}
```

#### 3.1.4 删除导航分类

```
DELETE /api/v1/nav/categories/{categoryId}
Authorization: Bearer {accessToken}
```

**Response (200):**

```json
{
  "code": 200,
  "message": "删除成功",
  "data": null,
  "timestamp": 1715760000000
}
```

注：删除分类会同时删除该分类下所有快捷方式。

---

### 3.2 快捷方式管理

#### 3.2.1 获取快捷方式列表

```
GET /api/v1/nav/shortcuts
Authorization: Bearer {accessToken}
```

**Query Parameters:**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| categoryId | Long | 否 | 按分类筛选，不传返回全部 |

**Response (200):**

```json
{
  "code": 200,
  "message": "success",
  "data": [
    {
      "shortcutId": 1,
      "categoryId": 1,
      "name": "Google",
      "url": "https://google.com",
      "iconType": "BUILTIN",
      "iconValue": "Search",
      "iconColor": "#4285F4",
      "sortOrder": 1,
      "createdAt": "2026-01-15T10:30:00Z"
    },
    {
      "shortcutId": 2,
      "categoryId": 1,
      "name": "GitHub",
      "url": "https://github.com",
      "iconType": "BUILTIN",
      "iconValue": "Github",
      "iconColor": "#181717",
      "sortOrder": 2,
      "createdAt": "2026-01-15T10:30:00Z"
    },
    {
      "shortcutId": 3,
      "categoryId": 1,
      "name": "我的博客",
      "url": "https://myblog.com",
      "iconType": "FAVICON",
      "iconValue": "https://myblog.com/favicon.ico",
      "iconColor": null,
      "sortOrder": 3,
      "createdAt": "2026-01-20T08:15:00Z"
    }
  ],
  "timestamp": 1715760000000
}
```

**iconType 枚举说明：**

| 值 | 说明 |
|------|------|
| BUILTIN | 内置图标（对应 Lucide React 图标名） |
| FAVICON | 自动抓取的网站 Favicon |
| CUSTOM_URL | 用户自定义图标 URL |
| CUSTOM_UPLOAD | 用户上传的图片 |

---

#### 3.2.2 批量添加快捷方式

```
POST /api/v1/nav/shortcuts/batch
Authorization: Bearer {accessToken}
```

**Request Body:**

```json
{
  "categoryId": 1,
  "shortcuts": [
    {
      "name": "Google",
      "url": "https://google.com",
      "iconType": "BUILTIN",
      "iconValue": "Search",
      "iconColor": "#4285F4"
    },
    {
      "name": "ChatGPT",
      "url": "https://chat.openai.com",
      "iconType": "FAVICON",
      "iconValue": "",
      "iconColor": "#10A37F"
    }
  ]
}
```

**Response (201):**

```json
{
  "code": 200,
  "message": "成功添加 2 个快捷方式",
  "data": [
    { "shortcutId": 10, "name": "Google" },
    { "shortcutId": 11, "name": "ChatGPT" }
  ],
  "timestamp": 1715760000000
}
```

---

#### 3.2.3 更新快捷方式

```
PUT /api/v1/nav/shortcuts/{shortcutId}
Authorization: Bearer {accessToken}
```

**Request Body:**

```json
{
  "name": "Google Search",
  "url": "https://google.com",
  "iconType": "CUSTOM_URL",
  "iconValue": "https://example.com/google-icon.png",
  "iconColor": null
}
```

**Response (200):**

```json
{
  "code": 200,
  "message": "更新成功",
  "data": {
    "shortcutId": 1,
    "name": "Google Search",
    "url": "https://google.com",
    "iconType": "CUSTOM_URL",
    "iconValue": "https://example.com/google-icon.png",
    "iconColor": null
  },
  "timestamp": 1715760000000
}
```

---

#### 3.2.4 删除快捷方式

```
DELETE /api/v1/nav/shortcuts/{shortcutId}
Authorization: Bearer {accessToken}
```

---

#### 3.2.5 拖拽排序

```
PUT /api/v1/nav/shortcuts/sort
Authorization: Bearer {accessToken}
```

**Request Body:**

```json
{
  "items": [
    { "shortcutId": 3, "sortOrder": 1 },
    { "shortcutId": 1, "sortOrder": 2 },
    { "shortcutId": 2, "sortOrder": 3 }
  ]
}
```

**Response (200):**

```json
{
  "code": 200,
  "message": "排序更新成功",
  "data": null,
  "timestamp": 1715760000000
}
```

---

### 3.3 Favicon 抓取

#### 3.3.1 根据 URL 抓取 Favicon

```
POST /api/v1/nav/favicon
Authorization: Bearer {accessToken}
```

**Request Body:**

```json
{
  "url": "https://github.com"
}
```

**Response (200):**

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "faviconUrl": "https://github.com/favicon.ico",
    "sourceUrl": "https://github.com"
  },
  "timestamp": 1715760000000
}
```

抓取策略：
1. 请求目标页面 HTML，解析 `<link rel="icon">` 标签提取真实图标地址
2. 若解析失败，回退到 `{origin}/favicon.ico`
3. 超时 5 秒，网络异常时静默降级回退

#### 3.3.2 批量根据 URL 抓取 Favicon

```
POST /api/v1/nav/favicon/batch
Authorization: Bearer {accessToken}
```

**Request Body:**

```json
{
  "urls": [
    "https://github.com",
    "https://google.com"
  ]
}
```

**Response (200):**

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "https://github.com": {
      "faviconUrl": "https://github.com/favicon.ico",
      "sourceUrl": "https://github.com"
    },
    "https://google.com": {
      "faviconUrl": "https://www.google.com/favicon.ico",
      "sourceUrl": "https://google.com"
    }
  },
  "timestamp": 1715760000000
}
```

**防 OOM 与性能设计：**
1. **线程池隔离**：使用独立的有界线程池 `faviconExecutor`（核心池大小 5，最大值 10，有界队列 200）。
2. **限速反压**：当有界队列满载时，采用 `CallerRunsPolicy` 拒绝策略，使用 Tomcat 调用者线程串行处理以实现前台反压，防止 JVM 内存膨胀。
3. **接口级拦截**：单次批量请求最多接受 100 个 URL，去重后执行。
4. **超时与容错**：全局 15 秒超时拦截，超出时间自动截断，单个任务失败自动回退并返回，绝不阻塞 Tomcat 服务。

---

### 3.4 图标上传

#### 3.4.1 上传图标文件

```
POST /api/v1/nav/icon/upload
Authorization: Bearer {accessToken}
Content-Type: multipart/form-data
```

**Request:**

| 字段 | 类型 | 说明 |
|------|------|------|
| file | File | 图标文件，支持 PNG/JPEG/GIF/WebP/ICO/SVG，最大 200KB |

**安全限制：**
1. 文件类型白名单：仅允许图片格式
2. 文件大小上限：200KB
3. 上传频率限制：每用户每小时最多 30 次（Redis 计数器）

**Response (200):**

```json
{
  "code": 200,
  "message": "上传成功",
  "data": {
    "iconUrl": "/uploads/icons/user_1/a1b2c3d4-e5f6-7890-abcd-ef1234567890.png"
  }
}
```

---

### 3.5 推荐分类数据

#### 3.5.1 获取推荐分类列表

```
GET /api/v1/public/guest-config
```

该接口固定读取全局推荐配置，无需登录即可访问。

**Response (200):**

```json
{
  "code": 200,
  "message": "success",
  "data": [
    {
      "categoryId": 101,
      "categoryName": "看视频",
      "categoryIcon": "Video",
      "sites": [
        {
          "name": "YouTube",
          "url": "https://youtube.com",
          "iconType": "BUILTIN",
          "iconValue": "Video",
          "iconColor": "#FF0000"
        },
        {
          "name": "Netflix",
          "url": "https://netflix.com",
          "iconType": "BUILTIN",
          "iconValue": "Video",
          "iconColor": "#E50914"
        }
      ]
    },
    {
      "categoryId": 102,
      "categoryName": "AI工具",
      "categoryIcon": "Cpu",
      "sites": [
        {
          "name": "ChatGPT",
          "url": "https://chat.openai.com",
          "iconType": "BUILTIN",
          "iconValue": "Cpu",
          "iconColor": "#10A37F"
        }
      ]
    }
  ],
  "timestamp": 1715760000000
}
```

---

## 四、用户配置模块 `/settings`

### 4.1 获取用户配置

```
GET /api/v1/settings
Authorization: Bearer {accessToken}
```

> **权限说明 (v1.0 更新)**：若当前登录用户角色为 `ADMIN`，此接口将静默读取并返回**全局推荐配置 (`navatation_recommend_config`)**，而非个人配置。

**Response (200):**

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "searchEngine": "google",
    "backgroundImage": "https://images.unsplash.com/photo-1598439473183-42c9301db5dc?w=2400",
    "backgroundType": "URL",
    "searchBoxWidth": 100,
    "searchBoxHeight": 64,
    "searchBoxMarginTop": 192,
    "iconSize": 64,
    "iconRadius": 50,
    "iconSpacingX": 32,
    "iconSpacingY": 48,
    "iconTextGap": 12,
    "textSize": 14,
    "iconsMarginTop": 64,
    "theme": "dark"
  },
  "timestamp": 1715760000000
}
```

### 4.2 保存/更新用户配置

```
PUT /api/v1/settings
Authorization: Bearer {accessToken}
```

**Request Body (全量覆盖):**

```json
{
  "searchEngine": "baidu",
  "backgroundImage": "https://images.unsplash.com/photo-new.jpg",
  "backgroundType": "URL",
  "searchBoxWidth": 80,
  "searchBoxHeight": 56,
  "searchBoxMarginTop": 200,
  "iconSize": 72,
  "iconRadius": 25,
  "iconSpacingX": 40,
  "iconSpacingY": 52,
  "iconTextGap": 14,
  "textSize": 16,
  "iconsMarginTop": 72,
  "theme": "dark"
}
```

**Response (200):**

```json
{
  "code": 200,
  "message": "配置保存成功",
  "data": null,
  "timestamp": 1715760000000
}
```

### 4.3 上传壁纸

```
POST /api/v1/settings/wallpaper/upload
Authorization: Bearer {accessToken}
Content-Type: multipart/form-data
```

**Request (form-data):**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| file | File | 是 | 图片文件，支持 jpg/png/webp，最大 10MB |

**Response (200):**

```json
{
  "code": 200,
  "message": "上传成功",
  "data": {
    "wallpaperUrl": "https://oss.navatation.com/wallpapers/user_10001/abc123.jpg"
  },
  "timestamp": 1715760000000
}
```

### 4.4 部分更新配置

```
PATCH /api/v1/settings
Authorization: Bearer {accessToken}
```

**Request Body (仅传需更新的字段):**

```json
{
  "searchEngine": "bing",
  "theme": "light"
}
```

---

## 五、待办事项模块 `/todo`

### 5.1 获取待办列表

```
GET /api/v1/todo
Authorization: Bearer {accessToken}
```

**Query Parameters:**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| status | String | 否 | 筛选：`all` / `active` / `completed`，默认 `all` |

**Response (200):**

```json
{
  "code": 200,
  "message": "success",
  "data": [
    {
      "todoId": 1,
      "content": "完成 Q4 报告",
      "completed": false,
      "sortOrder": 1,
      "createdAt": "2026-05-10T09:00:00Z",
      "completedAt": null
    },
    {
      "todoId": 2,
      "content": "回复客户邮件",
      "completed": true,
      "sortOrder": 2,
      "createdAt": "2026-05-10T09:01:00Z",
      "completedAt": "2026-05-11T14:30:00Z"
    }
  ],
  "timestamp": 1715760000000
}
```

### 5.2 创建待办事项

```
POST /api/v1/todo
Authorization: Bearer {accessToken}
```

**Request Body:**

```json
{
  "content": "完成 Q4 报告"
}
```

**Response (201):**

```json
{
  "code": 200,
  "message": "创建成功",
  "data": {
    "todoId": 1,
    "content": "完成 Q4 报告",
    "completed": false,
    "sortOrder": 1,
    "createdAt": "2026-05-15T10:00:00Z",
    "completedAt": null
  },
  "timestamp": 1715760000000
}
```

### 5.3 更新待办内容

```
PUT /api/v1/todo/{todoId}
Authorization: Bearer {accessToken}
```

**Request Body:**

```json
{
  "content": "完成 Q4 报告并提交审核"
}
```

### 5.4 切换完成状态

```
PATCH /api/v1/todo/{todoId}/toggle
Authorization: Bearer {accessToken}
```

**Response (200):**

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "todoId": 1,
    "completed": true,
    "completedAt": "2026-05-15T12:00:00Z"
  },
  "timestamp": 1715760000000
}
```

### 5.5 删除待办事项

```
DELETE /api/v1/todo/{todoId}
Authorization: Bearer {accessToken}
```

### 5.6 待办排序

```
PUT /api/v1/todo/sort
Authorization: Bearer {accessToken}
```

**Request Body:**

```json
{
  "items": [
    { "todoId": 3, "sortOrder": 1 },
    { "todoId": 1, "sortOrder": 2 },
    { "todoId": 2, "sortOrder": 3 }
  ]
}
```

### 5.7 清空已完成

```
DELETE /api/v1/todo/completed
Authorization: Bearer {accessToken}
```

**Response (200):**

```json
{
  "code": 200,
  "message": "已清空 3 条已完成待办",
  "data": {
    "deletedCount": 3
  },
  "timestamp": 1715760000000
}
```

---

## 六、组件模块 `/widgets`

### 6.1 获取组件列表

```
GET /api/v1/widgets
Authorization: Bearer {accessToken}
```

**Response (200):**

```json
{
  "code": 200,
  "message": "success",
  "data": [
    {
      "widgetId": "WG1234567890123456789012",
      "type": "clock",
      "style": "analog",
      "x": 40.50,
      "y": 30.00,
      "meta": {}
    },
    {
      "widgetId": "WG9876543210987654321098",
      "type": "clock",
      "style": "digital",
      "x": 10.00,
      "y": 80.00,
      "meta": {
        "timeFormat": "24h"
      }
    }
  ],
  "timestamp": 1715760000000
}
```

### 6.2 批量保存组件列表 (全量覆盖)

```
PUT /api/v1/widgets
Authorization: Bearer {accessToken}
```

**Request Body:**

```json
[
  {
    "widgetId": "WG1234567890123456789012",
    "type": "clock",
    "style": "analog",
    "x": 45.00,
    "y": 32.50,
    "meta": {}
  }
]
```

**Response (200):**

```json
{
  "code": 200,
  "message": "组件配置保存成功",
  "data": null,
  "timestamp": 1715760000000
}
```

---

## 七、接口汇总表

| 模块 | 方法 | 路径 | 鉴权 | 说明 |
|------|------|------|------|------|
| 认证 | GET | `/auth/nonce` | 否 | 获取 nonce + RSA 公钥 |
| 认证 | POST | `/auth/register` | 否 | 用户注册（RSA 加密） |
| 认证 | POST | `/auth/login` | 否 | 用户登录（RSA 加密） |
| 认证 | POST | `/auth/change-password` | 是 | 修改密码（RSA 加密） |
| 认证 | POST | `/auth/refresh` | 否 | 刷新 Token |
| 认证 | POST | `/auth/logout` | 是 | 用户登出 |
| 认证 | GET | `/auth/me` | 是 | 获取当前用户信息 |
| 认证 | POST | `/auth/reset-password` | 否 | 用户重置密码 (找回密码) |
| 导航 | GET | `/nav/categories` | 是 | 获取分类列表 |
| 导航 | POST | `/nav/categories` | 是 | 创建分类 |
| 导航 | PUT | `/nav/categories/{id}` | 是 | 更新分类 |
| 导航 | DELETE | `/nav/categories/{id}` | 是 | 删除分类 |
| 导航 | GET | `/nav/shortcuts` | 是 | 获取快捷方式列表 |
| 导航 | POST | `/nav/shortcuts/batch` | 是 | 批量添加快捷方式 |
| 导航 | PUT | `/nav/shortcuts/{id}` | 是 | 更新快捷方式 |
| 导航 | DELETE | `/nav/shortcuts/{id}` | 是 | 删除快捷方式 |
| 导航 | PUT | `/nav/shortcuts/sort` | 是 | 拖拽排序 |
| 导航 | POST | `/nav/favicon` | 是 | 抓取 Favicon |
| 导航 | POST | `/nav/icon/upload` | 是 | 上传图标文件（200KB 上限，30次/小时限流） |
| 导航 | GET | `/nav/recommended` | 否 | 获取推荐分类 |
| 设置 | GET | `/settings` | 是 | 获取用户配置 |
| 设置 | PUT | `/settings` | 是 | 全量更新配置 |
| 设置 | PATCH | `/settings` | 是 | 部分更新配置 |
| 设置 | POST | `/settings/wallpaper/upload` | 是 | 上传壁纸 |
| 待办 | GET | `/todo` | 是 | 获取待办列表 |
| 待办 | POST | `/todo` | 是 | 创建待办 |
| 待办 | PUT | `/todo/{id}` | 是 | 更新待办 |
| 待办 | PATCH | `/todo/{id}/toggle` | 是 | 切换完成状态 |
| 待办 | DELETE | `/todo/{id}` | 是 | 删除待办 |
| 待办 | PUT | `/todo/sort` | 是 | 待办排序 |
| 待办 | DELETE | `/todo/completed` | 是 | 清空已完成 |
| 组件 | GET | `/widgets` | 是 | 获取用户小组件列表 |
| 组件 | PUT | `/widgets` | 是 | 全量覆盖保存用户小组件列表 |

