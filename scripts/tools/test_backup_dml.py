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
