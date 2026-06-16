# Backup DML Utility Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 编写一个通用的 Python 数据库备份和美化脚本 `backup_dml.py`，连接本地 MySQL 数据，经过清洗过滤和格式化排版，输出并替换现有的初始化脚本 `navatation-admin/dml.sql`。

**Architecture:** 脚本调用 Windows 系统内置的 `mysqldump` 导出包含列名信息的原始数据 INSERT 语句。通过一个基于状态机的 Python 解析器拆分并美化 `VALUES` 数据，支持表名去反引号、字段缩进换行排版、以及特定表数据清洗（过滤非 admin 的测试用户记录、清空普通用户的个人表）。

**Tech Stack:** Python 3 (内置库 `subprocess`, `re`, `sys`, `unittest`), MySQL client (mysqldump)

---

## File Structure Map
- [backup_dml.py](file:///E:/workspace/navatation/scripts/tools/backup_dml.py): 数据导出、数据过滤清洗、SQL 格式化美化的主脚本。
- [test_backup_dml.py](file:///E:/workspace/navatation/scripts/tools/test_backup_dml.py): 针对状态机解析器和数据过滤规则的单元测试脚本。
- [dml.sql](file:///E:/workspace/navatation/navatation-admin/dml.sql): 被更新的初始化数据库 DML 文件。

---

### Task 1: 编写单元测试验证 SQL 解析和过滤逻辑

**Files:**
- Create: `E:\workspace\navatation\scripts\tools\test_backup_dml.py`

- [ ] **Step 1: 编写单元测试类**
  
  编写 `test_backup_dml.py`，测试核心逻辑：`parse_values` 用于切分 SQL 括号元组，`format_insert` 用于去掉反引号和多行排版，`clean_data` 用于清洗用户数据。
  
  ```python
  import unittest
  import sys
  import os

  # 允许引入同级目录下的 backup_dml
  sys.path.append(os.path.dirname(os.path.abspath(__file__)))
  from backup_dml import parse_values, format_insert, clean_data

  class TestBackupDML(unittest.TestCase):
      def test_parse_values_simple(self):
          values_str = " (1, 'a', 'b'), (2, 'c', 'd');"
          result = parse_values(values_str)
          self.assertEqual(result, ["(1, 'a', 'b')", "(2, 'c', 'd')"])

      def test_parse_values_with_quotes_and_commas(self):
          values_str = " (1, 'a, b', 'c) d'), (2, '\\'e', 'f');"
          result = parse_values(values_str)
          self.assertEqual(result, ["(1, 'a, b', 'c) d')", "(2, '\\'e', 'f')"])

      def test_format_insert(self):
          sql_line = "INSERT INTO `navatation_user` (`user_id`, `username`) VALUES (1, 'admin'), (2, 'user');"
          formatted = format_insert(sql_line, ["(1, 'admin')"])
          expected = (
              "INSERT INTO navatation_user (user_id, username) VALUES\n"
              "  (1, 'admin');"
          )
          self.assertEqual(formatted, expected)

      def test_clean_data_user_table(self):
          table_name = "navatation_user"
          tuples = ["(1, 'u_admin', 'admin', 'hash')", "(2, 'u_user', 'user1', 'hash')"]
          cleaned = clean_data(table_name, tuples)
          self.assertEqual(cleaned, ["(1, 'u_admin', 'admin', 'hash')"])

      def test_clean_data_empty_table(self):
          table_name = "navatation_user_widget"
          tuples = ["(1, 'wg1', 'type')"]
          cleaned = clean_data(table_name, tuples)
          self.assertEqual(cleaned, [])

  if __name__ == '__main__':
      unittest.main()
  ```

- [ ] **Step 2: 运行测试并确保其失败（TDD 失败验证）**
  
  由于此时尚未创建 `backup_dml.py`，测试应该因为无法导入模块而报错失败。
  
  Run: `python E:\workspace\navatation\scripts\tools\test_backup_dml.py`
  Expected: ModuleNotFoundError: No module named 'backup_dml'

- [ ] **Step 3: 提交空测试代码**
  
  ```bash
  git add E:\workspace\navatation\scripts\tools\test_backup_dml.py
  git commit -m "test: add unit tests for backup dml parser"
  ```

---

### Task 2: 编写 backup_dml.py 实现解析和清洗核心功能

**Files:**
- Create: `E:\workspace\navatation\scripts\tools\backup_dml.py`

- [ ] **Step 1: 编写基础函数实现**
  
  实现 `parse_values`, `format_insert`, 和 `clean_data` 逻辑。
  
  ```python
  import re
  import subprocess
  import sys

  def parse_values(values_str):
      tuples = []
      in_quote = False
      quote_char = None
      escape = False
      depth = 0
      start = -1
      for i, char in enumerate(values_str):
          if escape:
              escape = False
              continue
          if char == '\\':
              escape = True
              continue
          if char in ("'", '"'):
              if not in_quote:
                  in_quote = True
                  quote_char = char
              elif char == quote_char:
                  in_quote = False
                  quote_char = None
          if not in_quote:
              if char == '(':
                  if depth == 0:
                      start = i
                  depth += 1
              elif char == ')':
                  depth -= 1
                  if depth == 0 and start != -1:
                      tuples.append(values_str[start:i+1].strip())
                      start = -1
      return tuples

  def clean_data(table_name, tuples):
      # 普通用户关联数据直接清空
      empty_tables = {
          "navatation_user_widget",
          "navatation_todo_item",
          "navatation_nav_home_shortcut",
          "navatation_nav_category",
          "navatation_user_config"
      }
      if table_name in empty_tables:
          return []
      
      # 用户表只保留 admin 用户
      if table_name == "navatation_user":
          cleaned = []
          for tup in tuples:
              # 如果包含了管理员账号的核心属性，比如 'admin'，则保留。
              # 匹配是否含有 'admin'
              if "'admin'" in tup or '"admin"' in tup:
                  cleaned.append(tup)
          return cleaned
      
      # 其他推荐配置等表保留原有记录
      return tuples

  def format_insert(sql_line, cleaned_tuples):
      if not cleaned_tuples:
          return ""
      
      # 匹配 INSERT INTO `table` (`col1`, `col2`) VALUES ...
      match = re.match(r"INSERT INTO\s+`([^`]+)`\s+\(([^)]+)\)\s+VALUES", sql_line, re.IGNORECASE)
      if not match:
          # 没有列名的情况 (回退逻辑)
          match_no_col = re.match(r"INSERT INTO\s+`([^`]+)`\s+VALUES", sql_line, re.IGNORECASE)
          if not match_no_col:
              return ""
          table_name = match_no_col.group(1)
          cols_part = ""
      else:
          table_name = match.group(1)
          cols_part = match.group(2)
      
      # 清理反引号
      table_name_clean = table_name.replace("`", "")
      cols_part_clean = cols_part.replace("`", "")
      
      # 拼装
      cols_suffix = f" ({cols_part_clean})" if cols_part_clean else ""
      header = f"INSERT INTO {table_name_clean}{cols_suffix} VALUES"
      
      values_body = ",\n  ".join(cleaned_tuples)
      return f"{header}\n  {values_body};"
  ```

- [ ] **Step 2: 运行单元测试验证函数正确性**
  
  运行第一步编写的单元测试，确保解析、清洗和美化成功。
  
  Run: `python E:\workspace\navatation\scripts\tools\test_backup_dml.py`
  Expected: PASS

- [ ] **Step 3: 完善备份运行入口逻辑**
  
  在 `backup_dml.py` 底部加上调用 `mysqldump` 并写入 `dml.sql` 的完整入口逻辑。
  
  ```python
  def dump_and_backup():
      db_user = "root"
      db_pass = "root"
      db_name = "navatation"
      
      # 12个表的顺序列表，方便输出可读的 sql 结构
      tables_order = [
          # 1. 用户和个人数据表（只用 TRUNCATE 清空）
          "navatation_user_widget",
          "navatation_todo_item",
          "navatation_nav_home_shortcut",
          "navatation_nav_category",
          "navatation_user_config",
          
          # 2. 推荐配置与模板数据表
          "navatation_recommend_config",
          "navatation_recommend_category",
          "navatation_recommend_shortcut",
          "navatation_recommend_todo_item",
          "navatation_recommend_widget",
          "navatation_recommend_home_shortcut",
          
          # 3. 用户主表（保留 admin）
          "navatation_user"
      ]

      # 调用 mysqldump
      cmd = [
          "mysqldump",
          f"-u{db_user}",
          f"-p{db_pass}",
          "--no-create-info",
          "--complete-insert",
          "--skip-comments",
          "--skip-triggers",
          db_name
      ] + tables_order
      
      try:
          result = subprocess.run(cmd, capture_output=True, text=True, encoding="utf8", check=True)
          dump_output = result.stdout
      except Exception as e:
          print(f"Error executing mysqldump: {e}", file=sys.stderr)
          sys.exit(1)

      # 存储每张表提取到的原始 SQL 插入行
      inserts_by_table = {}
      for line in dump_output.splitlines():
          line = line.strip()
          if not line.startswith("INSERT INTO"):
              continue
          
          # 提取表名
          match = re.match(r"INSERT INTO\s+`([^`]+)`", line, re.IGNORECASE)
          if match:
              table_name = match.group(1)
              inserts_by_table[table_name] = line

      # 构建目标 dml.sql
      sql_blocks = []
      sql_blocks.append("-- DML: Navatation 数据初始化脚本")
      sql_blocks.append("-- 适用于 MySQL 5.7+")
      sql_blocks.append("")
      sql_blocks.append("SET NAMES utf8mb4;")
      sql_blocks.append("SET FOREIGN_KEY_CHECKS=0;")
      sql_blocks.append("")
      
      sql_blocks.append("-- ============================================")
      sql_blocks.append("-- 1. 清空所有表")
      sql_blocks.append("-- ============================================")
      for t in tables_order:
          sql_blocks.append(f"TRUNCATE TABLE {t};")
      sql_blocks.append("")

      sql_blocks.append("-- ============================================")
      sql_blocks.append("-- 2. 数据初始化")
      sql_blocks.append("-- ============================================")
      sql_blocks.append("")
      
      # 分块写入数据
      for t in tables_order:
          raw_sql = inserts_by_table.get(t)
          if not raw_sql:
              continue
          
          # 匹配 VALUES 后的子串
          val_match = re.search(r"VALUES\s+(.*);$", raw_sql, re.IGNORECASE)
          if not val_match:
              continue
          
          tuples = parse_values(val_match.group(1))
          cleaned = clean_data(t, tuples)
          formatted = format_insert(raw_sql, cleaned)
          if formatted:
              sql_blocks.append(formatted)
              sql_blocks.append("")

      sql_blocks.append("SET FOREIGN_KEY_CHECKS=1;")
      
      # 写入 E:\workspace\navatation\navatation-admin\dml.sql
      target_path = os.path.join(
          os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))),
          "navatation-admin",
          "dml.sql"
      )
      
      with open(target_path, "w", encoding="utf8") as f:
          f.write("\n".join(sql_blocks) + "\n")
      
      print(f"Successfully updated DML file: {target_path}")

  if __name__ == '__main__':
      # 若直接执行则运行备份逻辑
      import os
      dump_and_backup()
  ```

- [ ] **Step 4: 本地运行脚本生成 dml.sql**
  
  运行 `backup_dml.py`，更新 `navatation-admin/dml.sql`。
  
  Run: `python E:\workspace\navatation\scripts\tools\backup_dml.py`
  Expected: 输出 "Successfully updated DML file: ..." 并且 dml.sql 格式清晰。

- [ ] **Step 5: 提交脚本与修改后的 dml.sql**
  
  ```bash
  git add E:\workspace\navatation\scripts\tools\backup_dml.py E:\workspace\navatation\navatation-admin\dml.sql
  git commit -m "feat: add dml backup script and update dml.sql with backup data"
  ```

---

### Task 3: 验证生成的 dml.sql 执行正确性

**Files:**
- Modify: `E:\workspace\navatation\navatation-admin\dml.sql`

- [ ] **Step 1: 检查生成的 dml.sql 内容是否完整**
  
  使用 git diff 或者是直接查看该文件内容，确认 `navatation_user` 只含有 `admin` 且密码哈希是原有的默认哈希。所有 recommend 推荐表内容保留并格式化美观。普通个人配置表只在开头执行 TRUNCATE 但没有 INSERT 语句。

- [ ] **Step 2: 在本地数据库运行生成的 SQL 进行最终验证**
  
  使用 `mysql` 命令在本地 `navatation` 库里重新运行 `dml.sql` 脚本，确认没有任何语法或约束冲突报错。
  
  Run: `mysql -u root -proot navatation < E:\workspace\navatation\navatation-admin\dml.sql`
  Expected: 成功执行，无错误。

- [ ] **Step 3: 运行后端服务器或单元测试验证系统工作正常**
  
  (如果后端项目里有启动校验，或者我们检查数据插入后的条数是否与原先一致)
  检查 `navatation_user` 仍然有 admin：
  Run: `mysql -u root -proot navatation -e "SELECT COUNT(*) FROM navatation_user;"`
  Expected: 1
