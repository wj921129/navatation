# 备份现有数据并替换初始化 DML 设计方案

本项目包含 12 张核心表，用于极简网页浏览器新标签页的初始化以及系统推荐模板的配置。为方便后续在开发环境下调整推荐数据后一键备份为最新的初始化 SQL，本设计方案提出编写一个自动化的 Python 脚本来完成数据库导出、清洗、格式化美化，并用其替换 `dml.sql`。

## 1. 目标与范围
- **目标**：实现一键备份当前开发环境的 MySQL 数据库表数据，将其转化为排版规范、可读性高的 `dml.sql`，替换原有的 `navatation-admin/dml.sql`。
- **范围**：备份以下 12 张表的数据：
  - `navatation_user`（仅保留管理员账户 `admin`，其余用户和相关个人数据过滤/清除）
  - `navatation_user_config`
  - `navatation_user_widget`
  - `navatation_todo_item`
  - `navatation_nav_category`
  - `navatation_nav_home_shortcut`
  - `navatation_recommend_config`
  - `navatation_recommend_category`
  - `navatation_recommend_shortcut`
  - `navatation_recommend_todo_item`
  - `navatation_recommend_widget`
  - `navatation_recommend_home_shortcut`

## 2. 详细设计

### 2.1 脚本设计
- **文件路径**：[backup_dml.py](file:///E:/workspace/navatation/scripts/tools/backup_dml.py)
- **运行环境**：Python 3 (不依赖第三方模块，通过调用本地系统自带的 `mysqldump` 保证最大兼容度)。
- **核心流程**：
  ```mermaid
  graph TD
      A[启动脚本] --> B[调用 mysqldump 导出原始 SQL]
      B --> C[提取每张表的 INSERT 语句]
      C --> D[过滤非 admin 的用户数据与测试用户关联数据]
      D --> E[去除表名和列名的反引号]
      E --> F[格式化 INSERT 语句为多行缩进]
      F --> G[生成 TRUNCATE TABLE 与外键检查控制语句]
      G --> H[输出保存至 navatation-admin/dml.sql]
  ```

### 2.2 格式化规范
导出的 SQL 结构应包含以下内容：
1. **头部指令**：
   ```sql
   -- DML: Navatation 数据初始化脚本
   -- 适用于 MySQL 5.7+

   SET NAMES utf8mb4;
   SET FOREIGN_KEY_CHECKS=0;
   ```
2. **清空表操作（TRUNCATE）**：
   按顺序清空 12 张表。
3. **初始化插入操作**：
   - 使用包含列名的 `INSERT INTO` 语句。
   - 对字段和值进行换行排版，每条记录一行：
     ```sql
     INSERT INTO navatation_recommend_category (category_id, name, sort_order, deleted) VALUES
       ('RC1', '看视频', 0, 0),
       ('RC2', 'AI工具', 1, 0);
     ```
4. **尾部指令**：
   ```sql
   SET FOREIGN_KEY_CHECKS=1;
   ```

### 2.3 数据清洗与过滤规则
- **`navatation_user` 表**：只保留 `username = 'admin'` 的那行数据。若系统中有其他用户，备份时直接过滤排除。
- **个人配置与业务数据表**（如 `navatation_todo_item`、`navatation_nav_category` 等）：若库中有非 admin 的测试数据，直接排除（即不写入其 `INSERT` 语句，只保留 `TRUNCATE` 清空逻辑）。若仅有 `admin` 的关联测试数据，同样进行清理，以保证初始化数据仅包含模板和基础系统配置。

## 3. 测试与验证
1. 运行备份脚本，生成新的 `dml.sql`。
2. 检查生成的 `dml.sql` 的格式、内容，确认敏感数据已被清洗，且格式缩进美观。
3. 在本地测试数据库上执行新的 `dml.sql` 脚本，验证是否可无错运行且数据初始化正确。
