# RSA 加密登录设计方案

## 概述

解决登录、注册、修改密码接口中密码明文传输的安全问题，采用 **RSA-OAEP-256 + 一次性 Nonce** 方案实现应用层加密。

## 涉及接口

| 接口 | 方法 | 当前问题 | 变更内容 |
|------|------|---------|---------|
| `/api/v1/auth/login` | POST | 密码明文传输 | 改为加密传输 |
| `/api/v1/auth/register` | POST | 密码明文传输 | 改为加密传输 |
| `/api/v1/auth/change-password` | POST | 密码明文传输 | 改为加密传输 |
| `/api/v1/auth/nonce` | GET | 新增 | 获取一次性 nonce 和 RSA 公钥 |

## 加密方案

### 算法选择

- **非对称加密**: RSA-OAEP-256 (SHA-256)
- **密钥长度**: 2048 bits
- **编码**: Base64 传输

### Nonce 机制

- 每次登录/注册/改密前，前端先请求 nonce
- nonce 为 UUID v4，存入 Redis（key: `nonce:{uuid}`，TTL: 5 分钟）
- 后端先校验 nonce 存在 → 立即从 Redis 删除 → 处理业务
- 防止重放攻击

### 密钥管理

- 首次启动自动生成密钥对，持久化到 `{working-dir}/rsa/` 目录
- `rsa_private_key.pem` — PKCS#8 格式私钥
- `rsa_public_key.pem` — X.509 SubjectPublicKeyInfo 格式公钥
- 通过 `app.rsa.key-path` 配置项可自定义路径
- 重启复用已有密钥，避免已分发公钥失效

### 加密数据格式

所有密码相关字段合并为 `encryptedData`，包含 nonce 绑定完整性：

| 接口 | encryptedData 解密内容 |
|------|----------------------|
| 登录 | `password \| nonce` |
| 注册 | `password \| confirmPassword \| nonce` |
| 修改密码 | `oldPassword \| newPassword \| confirmPassword \| nonce` |

分隔符使用竖线 `|`，密码本身不允许包含竖线（需在业务层校验确认）。

### 请求体结构

```json
{
  "username": "xxx",
  "encryptedData": "<base64 编码的 RSA 加密数据>",
  "nonce": "uuid"
}
```

### 完整交互流程

```
前端                                         后端
 │                                            │
 ├── GET /api/v1/auth/nonce ──────────────→   │
 │                                            ├── 生成 UUID nonce
 │                                            ├── Redis: SET nonce:{uuid} ttl=300s
 │                                            └── 返回 { nonce, publicKey }
 │←───────────────────────────────────────────┤
 │                                            │
 ├── Web Crypto API: RSA-OAEP-256 加密        │
 │   encrypt("password|nonce") → base64       │
 │                                            │
 ├── POST /api/v1/auth/login ─────────────→   │
 │   { username, encryptedData, nonce }       │
 │                                            ├── Redis: GET nonce:{nonce}
 │                                            │   └── 不存在/已消费 → 拒绝
 │                                            ├── Redis: DEL nonce:{nonce}
 │                                            ├── 私钥解密 encryptedData
 │                                            ├── 提取 nonce 比对请求 nonce
 │                                            ├── 提取 password
 │                                            └── BCrypt.matches(password, hash)
 │←───────────────────────────────────────────┤
 │         返回 Token / 错误信息                │
```

## 后端实现

### 新建文件

#### 1. RsaKeyService

**包路径**: `com.navatation.framework.security`

职责：
- 启动时加载或生成 RSA 密钥对
- 将公钥以 PEM 格式提供给调用方
- 使用私钥解密 Base64 编码的密文

核心方法：
```java
public String getPublicKeyPem()
public String decrypt(String base64EncryptedData)
```

#### 2. NonceService

**包路径**: `com.navatation.framework.security`

职责：
- 生成一次性 nonce（UUID），存入 Redis
- 校验并消费 nonce

核心方法：
```java
public String generateNonce()
public boolean consumeNonce(String nonce)  // 返回 true 表示有效且已消费
```

### 修改文件

#### 3. DTO 类

新建 `EncryptedLoginRequest`、`EncryptedRegisterRequest`、`EncryptedChangePasswordRequest`，字段统一为：
- `username` (登录/注册 需要)
- `encryptedData` — RSA 加密的 Base64 字符串
- `nonce` — 一次性挑战码

#### 4. AuthController

- 新增 `GET /api/v1/auth/nonce` → `{ nonce, publicKey }`
- `login`/`register`/`changePassword` 方法：注入 `RsaKeyService`，解密 `encryptedData` 后调用 service

#### 5. AuthService

- `login()` 接收解密后的明文密码（内部逻辑不变）
- `register()` 同上
- `changePassword()` 同上

#### 6. SecurityConfig

- 放行 `GET /api/v1/auth/nonce`（添加到 `permitAll()` 列表）

#### 7. application.yml

新增配置项：
```yaml
app:
  rsa:
    key-path: ./rsa  # 密钥文件存储路径，相对于工作目录
```

## 前端实现

### 新建文件

#### 1. crypto-service.ts

**路径**: `src/app/services/crypto-service.ts`

职责：
- 从后端获取 nonce 和 RSA 公钥
- 使用 Web Crypto API (crypto.subtle) 导入公钥
- 加密密码字段

核心流程：
```typescript
async function getNonceAndPublicKey(): Promise<{nonce, publicKey}>
async function encryptPassword(plaintext: string, publicKeyPem: string): Promise<string>
// 组合使用:
async function prepareSecureData(plaintext: string): Promise<{encryptedData, nonce}>
  // 1. 调用 getNonceAndPublicKey()
  // 2. 拼接 plaintext + "|" + nonce
  // 3. RSA-OAEP-256 加密
  // 4. Base64 编码
  // 5. 返回 { encryptedData, nonce }
```

### 修改文件

#### 2. auth-service.ts

- `login()` 调用 `prepareSecureData(password)` 获取加密数据
- `register()` 调用 `prepareSecureData(password + "|" + confirmPassword)`
- 请求体改为 `{ username, encryptedData, nonce }`

#### 3. LoginDialog.tsx

- 修改密码功能同样使用加密流程
- 调用 `prepareSecureData(oldPassword + "|" + newPassword + "|" + confirmPassword)`

## 安全性分析

| 威胁 | 缓解措施 |
|------|---------|
| 中间人窃听密码 | RSA 加密 + HTTPS 双层保护 |
| 重放攻击 | 一次性 nonce，使用即失效 |
| 重放加密密文 | nonce 绑定在加密数据内，密文不可迁移 |
| 私钥泄露 | 私钥存储在服务端文件系统，非网络可达 |
| 选择密文攻击 | 先消费 nonce 再解密，攻击者无法利用解密响应 |
| 时序攻击 | nonce 校验和密码校验返回统一错误信息 |

## 未纳入范围（YAGNI）

- 密钥定期轮换（后续可按需通过管理接口支持）
- 登录失败次数限制（独立功能，不在本设计范围内）
- 验证码机制（独立功能，不在本设计范围内）
