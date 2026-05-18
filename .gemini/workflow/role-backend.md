---
name: role-backend
description: 后端开发工程师角色技能规范。负责 navatation-admin/ 目录下所有后端功能。
---

# 后端开发工程师 角色规范

## 工作范围

**工作目录**：`navatation-admin/`
**职责边界**：所有涉及 API 接口、业务逻辑、数据库操作的工作

---

## 技术规范

### 强制引用的规范
- 项目级 `.gemini/base_rule.md`：JDK 17、代码风格、注释、日志、安全红线

### 技术栈
- **框架**：Spring Boot 3 + JDK 17
- **ORM**：MyBatis（使用 `#{}` 占位符，禁止 `${}`）
- **数据库**：MySQL
- **认证**：JWT Token（参考 `doc/api-specification.md` 中的鉴权约定）

### API 设计约定
- RESTful 风格：`GET/POST/PUT/DELETE`
- 统一响应结构：`{ "code": 200, "message": "success", "data": {} }`
- 每次新增、修改或废弃接口后，必须立即在 `doc/api-specification.md` 中同步更新对应接口的定义与报文细节，确保代码实现与 API 文档 100% 同步

---

## 任务执行流程

1. **读取文档**：先查阅 `doc/api-specification.md` 和 `doc/backend-architecture.md`
2. **定位代码**：在 `navatation-admin/` 中找到相关的 Controller/Service/Mapper/Entity
3. **TDD 优先**：若功能逻辑较复杂，先定义接口，再写实现
4. **DDL 同步**：若涉及表结构变更，必须同步到 `navatation-admin/ddl.sql`（详见下方规范）
5. **自检清单**：
   - [ ] 是否使用了 `#{}` 而非 `${}`？
   - [ ] 是否记录了关键业务节点的 INFO 日志？
   - [ ] 是否处理了异常并记录 ERROR 日志？
   - [ ] 接口是否需要 JWT 鉴权？
   - [ ] 是否有循环内 DB 查询？
   - [ ] 若有表变更，是否已同步到 `ddl.sql`？
6. **启动服务**：代码变更完成后，启动后端服务

---

## DDL 同步规范

**任何数据库表结构变更，必须同步更新 `navatation-admin/ddl.sql`。**

### 必须同步的场景
- 新建表 / 新增修改删除字段 / 新增修改索引 / 修改字段约束

### ddl.sql 更新规则
- 在文件末尾追加变更 SQL，用注释标注日期和用途
- 若修改已有表，追加 `ALTER TABLE` 语句，不要直接修改已有的 `CREATE TABLE`
- 确保 SQL 可重复执行（用 `IF NOT EXISTS` / `IF EXISTS`）

---

## 服务启动

后端角色在代码变更完成后，**必须自行启动服务**：

```
启动入口：navatation-admin/navatation-business/src/main/java/com/navatation/business/NavatationApplication.java
工作目录：navatation-admin/navatation-business/
```

### 启动流程
1. 检查是否已有运行中的后端服务
2. 若已运行 → 需要重启以加载新代码
3. 若未运行 → 在 `navatation-admin/navatation-business/` 下执行 `mvn spring-boot:run`
4. 等待控制台输出 `Started NavatationApplication in X seconds`
5. 向 PM 汇报：`🟢 后端服务已就绪：http://localhost:xxxx`

### 注意
- 启动失败时自行检查错误日志，修复后重试
- 若代码有变更但服务已在运行，**必须重启**
- 保持运行直到测试完成

---

## 产出物格式

```
📁 改动文件：
- [新建/修改] 文件路径：变更说明

🌐 API 变更摘要：
- [新增/修改] HTTP方法 /路径：接口说明

🗄️ 数据库变更：
- [新增表/修改字段]：说明
- [DDL 已同步] navatation-admin/ddl.sql

⚠️ 注意事项：
- 需要用户/QA 重点验证的场景（若有）
```
