# 编码规范

## 通用规则

- 使用卫语句提前返回，减少嵌套层级
- 最大嵌套层级不超过 3 层（超出需拆分为子组件/子方法）
- 推荐使用可选链（`?.`）和空值合并运算符（`??`）

## Java 规范 (navatation-admin)

- JDK 17，UTF-8 编码
- 禁止通配符导入（如 `import java.util.*`）
- 最大嵌套层级 3 层
- MyBatis-Plus 逻辑删除（`deleted` 字段）

## 前端规范 (navatation-web)

- React 18 + TypeScript + Vite + Tailwind CSS 4 + shadcn/ui
- 组件最大嵌套层级 3 层，超出需拆分为子组件
- API 基础 URL 通过 `VITE_API_BASE` 环境变量配置
- 认证令牌存储在 localStorage 中（`access_token`, `refresh_token`）
- 401 响应自动刷新令牌并排队请求
- Lucide 图标通过名称引用
