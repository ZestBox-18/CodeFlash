# 贡献指南

感谢你考虑为 CodeFlash 做出贡献！

---

## 📋 目录

- [行为准则](#行为准则)
- [如何贡献](#如何贡献)
- [开发流程](#开发流程)
- [提交规范](#提交规范)
- [代码规范](#代码规范)
- [问题报告](#问题报告)
- [功能建议](#功能建议)

---

## 行为准则

本项目采用 [贡献者公约行为准则](CODE_OF_CONDUCT.md)。参与本项目即表示你同意遵守其条款。

---

## 如何贡献

### 报告 Bug

如果你发现了 bug，请 [创建 Issue](https://github.com/ZestBox-18/CodeFlash/issues/new)，并提供：

- 清晰的标题和描述
- 复现步骤
- 预期行为和实际行为
- 截图（如果适用）
- 环境信息（操作系统、版本等）

### 建议新功能

欢迎提出新功能建议！请 [创建 Issue](https://github.com/ZestBox-18/CodeFlash/issues/new)，说明：

- 功能描述
- 使用场景
- 预期效果

### 提交代码

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'feat: add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 提交 Pull Request

---

## 开发流程

### 环境设置

```bash
# 克隆仓库（包含子模块）
git clone --recursive https://github.com/ZestBox-18/CodeFlash.git
cd CodeFlash

# 初始化子模块（如果已克隆但没有子模块）
git submodule update --init --recursive
```

### 项目结构

```
CodeFlash/
├── codeflash-harmony/     # HarmonyOS 应用（子模块）
├── server/                # 服务端（Go）
│   └── homebrew-codeflash/ # Homebrew Tap（子模块）
├── website/               # 官网（React + Vite）
└── README.md
```

### 开发 HarmonyOS 应用

```bash
cd codeflash-harmony
# 使用 DevEco Studio 打开此目录
```

**要求：**
- DevEco Studio 5.0+
- HarmonyOS SDK API 12+

### 开发服务端

```bash
cd server

# 运行
go run main.go

# 编译
go build -o codeflash-server .
```

**要求：**
- Go 1.24+

### 开发官网

```bash
cd website

# 安装依赖
pnpm install

# 本地开发
pnpm dev

# 构建
pnpm build
```

**要求：**
- Node.js 18+
- pnpm 8+

---

## 提交规范

本项目采用 [约定式提交](https://www.conventionalcommits.org/zh-hans/) 规范。

### 提交格式

```
<type>(<scope>): <subject>

<body>

<footer>
```

### 类型（type）

| 类型 | 说明 |
|------|------|
| `feat` | 新功能 |
| `fix` | Bug 修复 |
| `docs` | 文档更新 |
| `style` | 代码格式（不影响代码运行） |
| `refactor` | 重构 |
| `perf` | 性能优化 |
| `test` | 测试相关 |
| `chore` | 构建过程或辅助工具的变动 |
| `ci` | CI 配置文件和脚本的变动 |
| `revert` | 回退之前的 commit |

### 示例

```bash
# 新功能
git commit -m "feat: add auto-discovery for iOS"

# Bug 修复
git commit -m "fix: resolve clipboard permission issue on macOS"

# 文档更新
git commit -m "docs: update installation guide"

# 多行提交
git commit -m "feat: add new feature" -m "Detailed description of the feature" -m "Closes #123"
```

---

## 代码规范

### Go（服务端）

- 遵循 [Effective Go](https://golang.org/doc/effective_go)
- 使用 `gofmt` 格式化代码
- 添加必要的注释

### ArkTS（HarmonyOS）

- 遵循 ArkTS 编码规范
- 使用 DevEco Studio 的代码格式化
- 组件命名使用 PascalCase
- 函数命名使用 camelCase

### TypeScript/React（官网）

- 使用 ESLint 和 Prettier
- 组件命名使用 PascalCase
- 函数命名使用 camelCase
- 使用 TypeScript 类型注解

---

## 问题报告

### Bug 报告模板

```markdown
## Bug 描述

[清晰简洁地描述 bug]

## 复现步骤

1. 执行 '...'
2. 点击 '....'
3. 滚动到 '....'
4. 看到错误

## 预期行为

[描述你期望发生什么]

## 实际行为

[描述实际发生了什么]

## 截图

[如果适用，添加截图]

## 环境信息

- 操作系统: [e.g. macOS 14.0]
- CodeFlash 版本: [e.g. v1.0.0]
- 设备: [e.g. iPhone 15 Pro, Mate 60 Pro]

## 其他信息

[添加任何其他相关信息]
```

---

## 功能建议

### 功能建议模板

```markdown
## 功能描述

[清晰简洁地描述你想要的功能]

## 使用场景

[描述这个功能的使用场景]

## 预期效果

[描述这个功能的预期效果]

## 示例

[如果适用，提供示例]

## 其他信息

[添加任何其他相关信息]
```

---

## Pull Request 流程

1. **确保通过所有检查**
   - 代码格式检查
   - 测试通过
   - 构建成功

2. **更新文档**
   - 如果有新功能，更新 README.md
   - 如果有 API 变更，更新相关文档

3. **添加测试**
   - 为新功能添加测试
   - 确保 bug 修复有对应的测试

4. **PR 描述**
   - 清晰描述改动内容
   - 关联相关 Issue
   - 说明测试方法

---

## 获取帮助

如果你有任何问题，可以：

- 查阅 [文档](https://codeflash.zestbox.cn/)
- 提交 [Issue](https://github.com/ZestBox-18/CodeFlash/issues)
- 发送邮件至项目维护者

---

感谢你的贡献！ ❤️
