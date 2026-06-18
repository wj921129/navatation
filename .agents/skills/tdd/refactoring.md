# Refactor Candidates

After TDD cycle, look for:

- **Duplication** 鈫?Extract function/class
- **Long methods** 鈫?Break into private helpers (keep tests on public interface)
- **Shallow modules** 鈫?Combine or deepen
- **Feature envy** 鈫?Move logic to where data lives
- **Primitive obsession** 鈫?Introduce value objects
- **Existing code** the new code reveals as problematic

