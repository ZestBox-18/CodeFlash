CodeFlash (macOS) 离线安装包

包含内容
1) codeflash-server / codeflash-server-arm64 / codeflash-server-amd64
2) install-mac.sh
3) uninstall-mac.sh
4) com.codeflash.server.plist.template

安装（推荐）
1) 解压后进入目录：
   cd CodeFlash-mac

2) 执行安装脚本：
   chmod +x install-mac.sh uninstall-mac.sh
   ./install-mac.sh

   如仅想安装文件、跳过 launchd 加载（用于自测/排错），可执行：
   CODEFLASH_SKIP_LAUNCHD=1 ./install-mac.sh

脚本会：
- 自动识别 CPU（arm64 / x86_64）并选择对应二进制
- 将二进制安装到：~/Library/Application Support/CodeFlash/bin/codeflash-server
- 写入 LaunchAgent：~/Library/LaunchAgents/com.codeflash.server.plist
- 启用开机自启并立即启动
- 日志输出到：~/Library/Logs/CodeFlash/server.log

验证
1) 查看 LaunchAgent 是否存在：
   launchctl list | grep codeflash

2) 查看端口：
   lsof -nP -iTCP:56669 -sTCP:LISTEN

3) 查看日志：
   tail -n 200 ~/Library/Logs/CodeFlash/server.log

卸载
在同目录执行：
  ./uninstall-mac.sh

常见问题
0) 不要用 sudo 运行脚本
   如果你曾经用 sudo 执行过安装/加载，服务会以 root 运行，导致剪贴板不可用，并占用端口让用户服务启动失败。
   先清理 system 域后再重装：
   sudo launchctl bootout system "$HOME/Library/LaunchAgents/com.codeflash.server.plist"
   sudo pkill -f "$HOME/Library/Application Support/CodeFlash/bin/codeflash-server" || true
   ./uninstall-mac.sh
   ./install-mac.sh

1) 安全提示/无法打开（Gatekeeper）
   脚本会尽量移除隔离标记；如仍失败，可手动执行：
   xattr -dr com.apple.quarantine ~/Library/Application\ Support/CodeFlash

2) 需要弹窗/剪贴板能力
   本服务在 macOS 需要运行在用户会话中，因此使用 LaunchAgent（不是 LaunchDaemon）。
