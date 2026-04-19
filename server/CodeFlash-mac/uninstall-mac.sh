#!/bin/bash

set -euo pipefail

LABEL="com.codeflash.server"

if [ "${EUID:-$(id -u)}" -eq 0 ]; then
  echo "[CodeFlash] 错误：请不要使用 sudo 运行 uninstall-mac.sh。" >&2
  echo "[CodeFlash] 正确方式：直接运行 ./uninstall-mac.sh（普通用户）。" >&2
  echo "[CodeFlash] 如果你之前误用 sudo 启动过服务，请按下面提示清理 system 域。" >&2
fi

INSTALL_ROOT="$HOME/Library/Application Support/CodeFlash"
PLIST_PATH="$HOME/Library/LaunchAgents/$LABEL.plist"
LOG_DIR="$HOME/Library/Logs/CodeFlash"

launchctl_supports_bootstrap() {
  launchctl help 2>/dev/null | grep -q "\bbootstrap\b" || return 1
}

launchctl_domain_exists() {
  local domain="$1"
  launchctl print "$domain" >/dev/null 2>&1
}

system_domain_has_job() {
  launchctl print system 2>/dev/null | grep -Fq "${LABEL}" || return 1
}

if [ -f "$PLIST_PATH" ]; then
  if launchctl_supports_bootstrap; then
    if launchctl_domain_exists "gui/$UID"; then
      launchctl bootout "gui/$UID" "$PLIST_PATH" >/dev/null 2>&1 || true
    fi
    if launchctl_domain_exists "user/$UID"; then
      launchctl bootout "user/$UID" "$PLIST_PATH" >/dev/null 2>&1 || true
    fi
  else
    launchctl unload "$PLIST_PATH" >/dev/null 2>&1 || true
  fi

  launchctl unload "$PLIST_PATH" >/dev/null 2>&1 || true
fi

rm -f "$PLIST_PATH"
rm -rf "$INSTALL_ROOT"

if system_domain_has_job; then
  echo "[CodeFlash] 检测到 system 域仍存在 ${LABEL}（通常因为曾用 sudo load/bootstrap）。" >&2
  echo "[CodeFlash] 需要执行以下命令清理（会要求输入管理员密码）：" >&2
  echo "  sudo launchctl bootout system \"$HOME/Library/LaunchAgents/${LABEL}.plist\"" >&2
  echo "  sudo pkill -f \"$HOME/Library/Application Support/CodeFlash/bin/codeflash-server\" || true" >&2
fi

echo "[CodeFlash] 已卸载。"
echo "[CodeFlash] 如需同时删除日志，可手动移除: $LOG_DIR"
