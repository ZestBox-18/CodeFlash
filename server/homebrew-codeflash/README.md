# CodeFlash Homebrew Tap

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

CodeFlash 的 Homebrew Tap 仓库，支持通过 `brew install` 快速安装电脑端服务。

## CodeFlash 是什么？

CodeFlash 是一个轻量级的局域网剪贴板同步工具，支持 **HarmonyOS (鸿蒙)**、**iOS (快捷指令)** 和 **macOS/Windows**。

无需登录，无需公网，在同一 WiFi 下即可完成复制粘贴的跨设备传递。

**支持平台：**
- macOS（Apple Silicon & Intel 双架构）
- HarmonyOS
- iOS（快捷指令）
- Windows

## 安装

```bash
# 添加 Tap
brew tap ZestBox-18/codeflash

# 安装 CodeFlash
brew install codeflash

# 启动后台服务（支持开机自启）
brew services start codeflash
```

## 使用方法

服务启动后：

1. **HarmonyOS 端**：打开 CodeFlash App，点击「自动扫描」发现电脑
2. **iOS 端**：使用快捷指令，URL 填写 `http://<电脑IP>:56669/send-to-computer`

### 服务管理

```bash
# 查看服务状态
brew services list

# 查看日志
tail -f $(brew --prefix)/var/log/codeflash.log

# 停止服务
brew services stop codeflash

# 重启服务
brew services restart codeflash
```

## 端口说明

| 端口 | 用途 |
|------|------|
| 56669 | HTTP 剪贴板收发 |
| 56670 | UDP 设备发现（广播） |

## 系统要求

- macOS 10.15 (Catalina) 或更高版本
- Homebrew

## 相关链接

- **官网**：[http://codeflash.zestbox.cn/](http://codeflash.zestbox.cn/)
- **主仓库**：[CodeFlash](https://github.com/ZestBox-18/CodeFlash)
- **发布版本**：[GitHub Releases](https://github.com/ZestBox-18/homebrew-codeflash/releases)

## 许可证

MIT License
