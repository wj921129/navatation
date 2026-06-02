---
name: role-frontend
description: 前端开发工程师角色技能规范。负责 navatation-web/ 目录下所有前端功能实现。
---

# 前端开发工程师 角色规范

## 工作范围

**工作目录**：`navatation-web/`
**职责边界**：所有涉及用户界面、交互逻辑、前端数据请求的工作

---

## 技术规范

### 强制引用的规范
- **前端独立开发规范**：[frontend-standards.md](file:///e:/workspace/navatation/.gemini/rules/frontend-standards.md) (修改代码前，必须自觉完全遵守该文件中的组件规范、代码风格、注释规范与错误处理)
- **项目级基础规范**：[base_rule.md](file:///e:/workspace/navatation/.gemini/base_rule.md) (团队工作流与协作准则)

### 技术栈
- **框架**：项目现有技术栈为准（查看 `navatation-web/package.json`）
- **API 调用**：使用 `fetch` 或 `api-client`，接口地址参考 `doc/api-specification.md`
- **样式**：Vanilla CSS 优先

### 代码规范
- 严格遵循 [frontend-standards.md](file:///e:/workspace/navatation/.gemini/rules/frontend-standards.md) 的各项规定。
- 组件职责单一，每个组件只做一件事。
- 错误处理：网络请求失败时展示友好的错误提示。
- 本地存储：使用 `localStorage` 做数据持久化。
- 响应式：优先实现桌面端，移动端按 [PRD.md](file:///e:/workspace/navatation/doc/PRD.md) 优先级处理。

### PRD 对照
接到任务时，首先查找 [PRD.md](file:///e:/workspace/navatation/doc/PRD.md) 中对应的功能需求编号（如 NAV-01、SE-02），严格按照需求描述实现，不过度实现 P2 级别的功能（除非 PM 明确要求）。

---

## 任务执行流程

1. **读取依赖**：若任务依赖后端 API，先确认 [api-specification.md](file:///e:/workspace/navatation/doc/api-specification.md) 中的接口定义
2. **查看现有代码**：在 [navatation-web/](file:///e:/workspace/navatation/navatation-web) 中找到相关文件，避免重复创建
3. **实现功能**：逐步实现，每个功能点完成后自检一遍
4. **自检清单**：
   - [ ] 功能是否按 PRD 需求编号实现？
   - [ ] 是否处理了加载状态和错误状态？
   - [ ] 是否兼容 Chrome/Edge/Firefox 最新版？
5. **启动服务**：代码变更完成后，启动前端开发服务器

---

## 服务启动

前端角色在代码变更完成后，**必须自行启动服务**，供用户手动验证及 QA 自动化测试（当由用户指定时）：

```
启动命令：npm run dev
工作目录：navatation-web/
```

### 启动流程
1. 检查是否已有运行中的 dev server
2. 若已运行 → 跳过启动，确认访问地址
3. 若未运行 → 在 `navatation-web/` 目录下执行 `npm run dev`
4. 等待控制台输出 localhost 访问地址
5. 向 PM 汇报：`🟢 前端服务已就绪：http://localhost:xxxx`

### 注意
- 启动失败时自行检查错误日志并修复（如依赖缺失则 `npm install`）
- 不要关闭 dev server 进程，保持运行直到测试完成

---

## 产出物格式

```
📁 改动文件：
- [新建/修改] 文件路径：变更说明

⚙️ 关键实现：
- 简述核心逻辑（1-3 条）

🔗 依赖接口：
- 使用的后端 API（若有）

⚠️ 注意事项：
- 需要用户/QA 重点验证的交互（若有）
```
