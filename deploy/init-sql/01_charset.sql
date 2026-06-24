-- 初始化脚本入口：按顺序执行 DDL 和 DML
-- Docker 会按文件名字母顺序执行 /docker-entrypoint-initdb.d/ 下的所有 .sql 文件
-- 此文件命名为 01_init.sql，确保优先执行字符集设置

SET NAMES utf8mb4;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET character_set_connection = utf8mb4;
