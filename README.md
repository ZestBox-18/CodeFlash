# CodeFlash - 极速局域网剪贴板同步工具

<div align="center">

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![GitHub release](https://img.shields.io/github/release/ZestBox-18/CodeFlash.svg)](https://github.com/ZestBox-18/CodeFlash/releases)
[![GitHub stars](https://img.shields.io/github/stars/ZestBox-18/CodeFlash.svg)](https://github.com/ZestBox-18/CodeFlash/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/ZestBox-18/CodeFlash.svg)](https://github.com/ZestBox-18/CodeFlash/issues)

**解决不同生态系统设备间无法顺滑复制粘贴的痛点**

无需登录 · 无需公网 · 局域网秒级同步

[官网](https://codeflash.zestbox.cn/) · [快速开始](#快速开始) · [功能特性](#功能特性) · [常见问题](#常见问题) · [贡献指南](CONTRIBUTING.md)

</div>

---

## 📖 简介

CodeFlash 是一个轻量级的局域网剪贴板同步工具，支持 **HarmonyOS (鸿蒙)**、**iOS (快捷指令)** 和 **macOS/Windows**。

---

## ✨ 功能特性

| 特性 | 说明 |
|------|------|
| 🚀 **极速同步** | 局域网直连，毫秒级延迟 |
| 🔍 **自动发现** | 手机端一键自动扫描电脑，无需手动输入 IP |
| 🌍 **跨平台** | 电脑端支持 macOS 和 Windows，手机端支持 HarmonyOS 和 iOS |
| 💬 **原生体验** | 电脑端弹窗通知（支持自定义图标），点击即复制 |
| ⚙️ **后台服务** | 支持注册为系统服务，开机自启，静默运行 |

---

## 🚀 快速开始

### macOS 用户（推荐）

使用 Homebrew 一键安装：

```bash
# 添加 Tap
brew tap ZestBox-18/codeflash

# 安装并启动服务
brew install codeflash
brew services start codeflash
```

### 其他平台

<details>
<summary><b>💻 手动编译安装（macOS/Windows）</b></summary>

#### 编译服务端

```bash
# 克隆仓库
git clone --recursive https://github.com/ZestBox-18/CodeFlash.git
cd CodeFlash/server

# macOS 编译
go build -o codeflash-server .

# Windows 交叉编译（在 macOS 上）
GOOS=windows GOARCH=amd64 go build -o codeflash-server.exe .
```

#### 运行

```bash
./codeflash-server
```

默认端口：
- HTTP: `56669`
- UDP 发现: `56670`

</details>

<details>
<summary><b>📱 HarmonyOS 端安装</b></summary>

1. 使用 **DevEco Studio** 打开 `codeflash-harmony` 目录
2. 连接鸿蒙手机或启动模拟器
3. 点击 **运行 (Run)** 按钮安装 App
4. 打开 App，点击 **「自动扫描」** 发现电脑

</details>

<details>
<summary><b>🍎 iOS 端配置（快捷指令）</b></summary>

iOS 端无需安装 App，使用快捷指令即可：

**发送到电脑：**
- URL: `http://<电脑IP>:56669/send-to-computer`
- 方法: `POST`
- 请求体: 剪贴板内容

**从电脑获取：**
- URL: `http://<电脑IP>:56669/get-from-computer`
- 方法: `GET`

> 注：iOS 端暂不支持 UDP 自动发现，需手动填写 IP

</details>

---

## 📚 详细文档

### 💻 电脑端 (Server)

<details>
<summary><b>编译与运行</b></summary>

确保你已安装 [Go 环境](https://go.dev/dl/)。

```bash
# 进入电脑端目录 (Go module)
cd CodeFlash/server

# 编译 (macOS)
go build -o codeflash-server .

# 交叉编译为 Windows .exe (在 macOS 上)
GOOS=windows GOARCH=amd64 go build -o codeflash-server.exe .

# 运行
./codeflash-server
```

默认端口：

- HTTP: `56669`
- UDP 发现: `56670`

说明：macOS 上弹窗使用 `osascript`，建议在有 GUI 的用户会话里运行（例如直接双击/终端运行，或作为 LaunchAgent）。

</details>

<details>
<summary><b>设置开机自启 (macOS)</b></summary>

为了让服务在后台静默运行且开机自启，请执行以下步骤：

1. **修改配置文件路径**:
   打开 `com.codeflash.server.plist` 文件，将其中的可执行文件路径修改为你实际的 `codeflash-server` 绝对路径。
2. **注册服务**:
   在终端执行以下命令：
   ```bash
   # 复制配置文件到 LaunchAgents
   cp com.codeflash.server.plist ~/Library/LaunchAgents/

   # 加载服务
   launchctl load ~/Library/LaunchAgents/com.codeflash.server.plist
   ```
3. **验证**:
   服务启动后，你可以通过 `launchctl list | grep codeflash` 查看状态。

</details>

<details>
<summary><b>Windows 用户</b></summary>

#### 编译为后台无窗口应用

默认编译的 `.exe` 运行时会有一个黑色控制台窗口。如果你想让它在后台静默运行（无窗口），请使用以下命令编译：

```bash
# Windows (PowerShell)
go build -ldflags -H=windowsgui -o codeflash-server.exe .

# macOS/Linux 交叉编译
GOOS=windows GOARCH=amd64 go build -ldflags -H=windowsgui -o codeflash-server.exe .
```

#### 设置开机自启

1. 按 `Win + R` 键，输入 `shell:startup` 并回车，打开"启动"文件夹。
2. 将编译好的 `codeflash-server.exe` (或其快捷方式) 放入该文件夹。
3. 下次开机时，服务将自动在后台启动。

</details>

---

### 📱 HarmonyOS 端 (App)

鸿蒙端是一个原生 ArkTS 应用，支持自动扫描和双向同步。

#### 安装与使用

1. 使用 **DevEco Studio** 打开 `codeflash-harmony` 目录。
2. 连接鸿蒙手机或启动模拟器。
3. 点击 **运行 (Run)** 按钮安装 App。
4. **自动扫描**: 点击 App 界面右上角的 **"自动扫描"**，即可自动发现并连接电脑。
5. **发送/接收**:
   - **推送到电脑**: 复制手机内容 -> 点击大大的蓝色按钮。
   - **从电脑获取**: 点击"从电脑获取"按钮，电脑剪贴板内容会自动写入手机剪贴板。

---

### 🍎 iOS 端 (快捷指令)

iOS 端无需安装 App，直接使用"快捷指令"即可实现同步。

#### 配置步骤

1. 创建一个新的快捷指令。
2. **发送到电脑**:
   - 获取剪贴板内容。
   - 使用"获取 URL 内容"动作：
     - URL: `http://<你的电脑IP>:56669/send-to-computer` (建议配合路由器的静态 IP 使用)
     - 方法: `POST`
     - 请求体: `File/文本` -> 选择"剪贴板"
3. **从电脑获取**:
   - 使用"获取 URL 内容"动作：
     - URL: `http://<你的电脑IP>:56669/get-from-computer`
     - 方法: `GET`
   - 将结果"复制到剪贴板"。

*(注：iOS 端暂不支持 UDP 自动发现，需手动填写 IP)*

---

### 🤖 Android 端

作者自用微信输入法已完美解决 Mac 与 Android 的同步问题，因此本项目暂不提供 Android 客户端。如有需要，欢迎提交 PR！

---

## 电脑端 (Server)

电脑端是一个轻量级的 Go 服务，负责接收手机发送的剪贴板内容，并将其写入电脑剪贴板。

### 1. 编译与运行

确保你已安装 [Go 环境](https://go.dev/dl/)。

```bash
# 进入电脑端目录 (Go module)
cd CodeFlash/server

# 编译 (macOS)
go build -o codeflash-server .

# 交叉编译为 Windows .exe (在 macOS 上)
GOOS=windows GOARCH=amd64 go build -o codeflash-server.exe .

# 运行
./codeflash-server
```

默认端口：

- HTTP: `56669`
- UDP 发现: `56670`

说明：macOS 上弹窗使用 `osascript`，建议在有 GUI 的用户会话里运行（例如直接双击/终端运行，或作为 LaunchAgent）。

### 2. 设置开机自启 (macOS)

为了让服务在后台静默运行且开机自启，请执行以下步骤：

1. **修改配置文件路径**:
   打开 `com.codeflash.server.plist` 文件，将其中的可执行文件路径修改为你实际的 `codeflash-server` 绝对路径。
2. **注册服务**:
   在终端执行以下命令：
   ```bash
   # 复制配置文件到 LaunchAgents
   cp com.codeflash.server.plist ~/Library/LaunchAgents/

   # 加载服务
   launchctl load ~/Library/LaunchAgents/com.codeflash.server.plist
   ```
3. **验证**:
   服务启动后，你可以通过 `launchctl list | grep codeflash` 查看状态。

### 3. Windows 用户

#### 编译为后台无窗口应用

默认编译的 `.exe` 运行时会有一个黑色控制台窗口。如果你想让它在后台静默运行（无窗口），请使用以下命令编译：

```bash
# Windows (PowerShell)
go build -ldflags -H=windowsgui -o codeflash-server.exe .

# macOS/Linux 交叉编译
GOOS=windows GOARCH=amd64 go build -ldflags -H=windowsgui -o codeflash-server.exe .
```

#### 设置开机自启

1. 按 `Win + R` 键，输入 `shell:startup` 并回车，打开“启动”文件夹。
2. 将编译好的 `codeflash-server.exe` (或其快捷方式) 放入该文件夹。
3. 下次开机时，服务将自动在后台启动。

***

## HarmonyOS 端 (App)

鸿蒙端是一个原生 ArkTS 应用，支持自动扫描和双向同步。

### 安装与使用

1. 使用 **DevEco Studio** 打开 `harmony` 目录。
2. 连接鸿蒙手机或启动模拟器。
3. 点击 **运行 (Run)** 按钮安装 App。
4. **自动扫描**: 点击 App 界面右上角的 **“自动扫描”**，即可自动发现并连接电脑。
5. **发送/接收**:
   - **推送到电脑**: 复制手机内容 -> 点击大大的蓝色按钮。
   - **从电脑获取**: 点击“从电脑获取”按钮，电脑剪贴板内容会自动写入手机剪贴板。

***

## iOS 端 (快捷指令)

iOS 端无需安装 App，直接使用“快捷指令”即可实现同步。

### 配置步骤

1. 创建一个新的快捷指令。
2. **发送到电脑**:
   - 获取剪贴板内容。
   - 使用“获取 URL 内容”动作：
     - URL: `http://<你的电脑IP>:56669/send-to-computer` (建议配合路由器的静态 IP 使用)
     - 方法: `POST`
     - 请求体: `File/文本` -> 选择“剪贴板”
3. **从电脑获取**:
   - 使用“获取 URL 内容”动作：
     - URL: `http://<你的电脑IP>:56669/get-from-computer`
     - 方法: `GET`
   - 将结果“复制到剪贴板”。

*(注：iOS 端暂不支持 UDP 自动发现，需手动填写 IP)*

提示：iOS 端暂不支持 UDP 自动发现，需要手动填写电脑 IP。

***

## Android 端

作者自用微信输入法已完美解决 Mac 与 Android 的同步问题，因此本项目暂不提供 Android 客户端。如有需要，欢迎提交 PR！

---

## ❓ 常见问题

<details>
<summary><b>扫描不到电脑？</b></summary>

- 请确保手机和电脑在**同一 WiFi** 下。
- 检查电脑防火墙是否拦截了 `56670` (UDP) 或 `56669` (HTTP) 端口。

</details>

<details>
<summary><b>Mac 弹窗图标从哪里来？会不会依赖项目目录文件？</b></summary>

- 电脑端默认将图标内嵌在可执行文件中；首次需要显示弹窗图标时，会写出到缓存目录并复用。
- macOS 通常路径为：`~/Library/Caches/codeflash/icon.png`。
- 程序不会主动删除该缓存文件；macOS 可能在磁盘空间紧张时自动清理缓存（时间不保证）。

</details>

<details>
<summary><b>如何指定自定义图标？</b></summary>

启动前设置环境变量：`CODEFLASH_ICON_PATH=/绝对路径/icon.png`

</details>

<details>
<summary><b>复制到别处运行时报 <code>permission denied: ./codeflash-server</code></b></summary>

- 确保可执行权限：`chmod +x ./codeflash-server`
- 如仍失败，检查并移除隔离标记：`xattr -d com.apple.quarantine ./codeflash-server`

</details>

---

## 🤝 贡献

欢迎贡献代码、报告问题或提出建议！

- [贡献指南](CONTRIBUTING.md)
- [行为准则](CODE_OF_CONDUCT.md)
- [安全问题](SECURITY.md)

### 开发

```bash
# 克隆仓库（包含子模块）
git clone --recursive https://github.com/ZestBox-18/CodeFlash.git

# 开发 HarmonyOS 应用
cd codeflash-harmony
# 使用 DevEco Studio 打开

# 开发服务端
cd server
go run main.go

# 开发官网
cd website
pnpm install
pnpm dev
```

---

## 📄 许可证

本项目基于 [MIT License](LICENSE) 开源。

---

## 🙏 致谢

感谢所有贡献者的支持！

如果这个项目对你有帮助，请给一个 ⭐ Star 支持一下！

---

<div align="center">

**[官网](https://codeflash.zestbox.cn/)** · **[GitHub](https://github.com/ZestBox-18/CodeFlash)** · **[Issues](https://github.com/ZestBox-18/CodeFlash/issues)**

</div>
