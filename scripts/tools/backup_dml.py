import re
import subprocess
import sys
import os

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
    
    cols_suffix = f" ({cols_part_clean})" if cols_part_clean else ""
    header = f"INSERT INTO {table_name_clean}{cols_suffix} VALUES"
    
    values_body = ",\n  ".join(cleaned_tuples)
    return f"{header}\n  {values_body};"

def dump_and_backup():
    db_user = "root"
    db_pass = "root"
    db_name = "navatation"
    
    tables_order = [
        "navatation_user_widget",
        "navatation_todo_item",
        "navatation_nav_home_shortcut",
        "navatation_nav_category",
        "navatation_user_config",
        "navatation_recommend_config",
        "navatation_recommend_category",
        "navatation_recommend_shortcut",
        "navatation_recommend_todo_item",
        "navatation_recommend_widget",
        "navatation_recommend_home_shortcut",
        "navatation_user"
    ]

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
        # 在 Windows 环境下，mysqldump 的输出可能有默认编码，但我们使用 utf8
        result = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8", check=True)
        dump_output = result.stdout
    except Exception as e:
        print(f"Error executing mysqldump: {e}", file=sys.stderr)
        sys.exit(1)

    inserts_by_table = {}
    for line in dump_output.splitlines():
        line = line.strip()
        if not line.startswith("INSERT INTO"):
            continue
        
        match = re.match(r"INSERT INTO\s+`([^`]+)`", line, re.IGNORECASE)
        if match:
            table_name = match.group(1)
            inserts_by_table[table_name] = line

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
    
    for t in tables_order:
        raw_sql = inserts_by_table.get(t)
        if not raw_sql:
            continue
        
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
    
    target_path = os.path.join(
        os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))),
        "navatation-admin",
        "dml.sql"
    )
    
    with open(target_path, "w", encoding="utf-8") as f:
        f.write("\n".join(sql_blocks) + "\n")
    
    print(f"Successfully updated DML file: {target_path}")

if __name__ == '__main__':
    dump_and_backup()
