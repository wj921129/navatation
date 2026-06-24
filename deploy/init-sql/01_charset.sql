-- 初始化脚本入口：按顺序执行 DDL 和 DML
-- 系统会按文件名字母顺序依次执行对应的 SQL 初始化脚本
-- 此文件命名为 01_init.sql，确保优先执行字符集设置

SET NAMES utf8mb4;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET character_set_connection = utf8mb4;
