#!/bin/bash

set -euo pipefail

LABEL="com.codeflash.server"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_banner() {
  local color_reset=""
  local color_a=""
  local color_b=""

  if [ -t 1 ] && [ "${TERM:-}" != "dumb" ] && [ -z "${NO_COLOR:-}" ]; then
    color_reset=$'\033[0m'
    color_a=$'\033[38;5;45m'
    color_b=$'\033[38;5;213m'
  fi

  printf '%s' "$color_a"
  cat <<'EOF'
   _____          _      ______ _           _     
  / ____|        | |    |  ____| |         | |    
 | |     ___   __| | ___| |__  | | __ _ ___| |__  
EOF
  printf '%s' "$color_b"
  cat <<'EOF'
 | |    / _ \ / _` |/ _ \  __| | |/ _` / __| '_ \ 
 | |___| (_) | (_| |  __/ |    | | (_| \__ \ | | |
  \_____\___/ \__,_|\___|_|    |_|\__,_|___/_| |_|
EOF
  printf '%s\n' "$color_reset"
}

if [ "${EUID:-$(id -u)}" -eq 0 ]; then
  print_banner
  echo "[CodeFlash] 错误：请不要使用 sudo 运行 install-mac.sh。" >&2
  echo "[CodeFlash] 原因：以 root 启动会导致 macOS 剪贴板/弹窗不可用，且会占用端口导致用户服务启动失败。" >&2
  echo "[CodeFlash] 正确方式：直接运行 ./install-mac.sh（普通用户、已登录桌面会话的终端）。" >&2
  exit 1
fi

ARCH="$(uname -m)"
if [ "$ARCH" = "x86_64" ] && command -v sysctl >/dev/null 2>&1; then
  if [ "$(sysctl -in sysctl.proc_translated 2>/dev/null || echo 0)" = "1" ]; then
    ARCH="arm64"
  fi
fi

pick_binary() {
  if [ -f "$SCRIPT_DIR/codeflash-server" ]; then
    echo "$SCRIPT_DIR/codeflash-server"
    return 0
  fi

  case "$ARCH" in
    arm64)
      if [ -f "$SCRIPT_DIR/codeflash-server-arm64" ]; then
        echo "$SCRIPT_DIR/codeflash-server-arm64"
        return 0
      fi
      ;;
    x86_64)
      if [ -f "$SCRIPT_DIR/codeflash-server-amd64" ]; then
        echo "$SCRIPT_DIR/codeflash-server-amd64"
        return 0
      fi
      ;;
  esac

  return 1
}

escape_sed_replacement() {
  printf '%s' "$1" | sed -e 's/[\\&|]/\\\\&/g'
}

launchctl_supports_bootstrap() {
  launchctl help 2>/dev/null | grep -q "\bbootstrap\b" || return 1
}

system_domain_has_job() {
  launchctl print system 2>/dev/null | grep -Fq "${LABEL}" || return 1
}

launchctl_domain_exists() {
  local domain="$1"
  launchctl print "$domain" >/dev/null 2>&1
}

print_banner
echo "[CodeFlash] 检测到 CPU 架构: $ARCH"

if system_domain_has_job; then
  echo "[CodeFlash] 检测到 system 域存在 ${LABEL}（通常是曾用 sudo load/bootstrap 导致以 root 运行）。" >&2
  echo "[CodeFlash] 这会导致剪贴板不可用，并占用端口让用户服务无法启动。请先执行：" >&2
  echo "  sudo launchctl bootout system \"$HOME/Library/LaunchAgents/${LABEL}.plist\"" >&2
  echo "  sudo pkill -f \"$HOME/Library/Application Support/CodeFlash/bin/codeflash-server\" || true" >&2
  echo "然后再重新运行：" >&2
  echo "  ./uninstall-mac.sh" >&2
  echo "  ./install-mac.sh" >&2
  exit 1
fi

BIN_SRC="$(pick_binary || true)"
if [ -z "${BIN_SRC:-}" ] || [ ! -f "$BIN_SRC" ]; then
  echo "[CodeFlash] 未找到适配当前 CPU 的二进制文件。" >&2
  echo "[CodeFlash] 期望存在以下之一：" >&2
  echo "  - $SCRIPT_DIR/codeflash-server (通用/单架构)" >&2
  echo "  - $SCRIPT_DIR/codeflash-server-arm64 (Apple Silicon)" >&2
  echo "  - $SCRIPT_DIR/codeflash-server-amd64 (Intel)" >&2
  exit 1
fi

INSTALL_ROOT="$HOME/Library/Application Support/CodeFlash"
BIN_DST_DIR="$INSTALL_ROOT/bin"
BIN_DST="$BIN_DST_DIR/codeflash-server"

LOG_DIR="$HOME/Library/Logs/CodeFlash"
LOG_OUT="$LOG_DIR/server.log"
LOG_ERR="$LOG_DIR/server.err.log"

PLIST_TEMPLATE="$SCRIPT_DIR/com.codeflash.server.plist.template"
PLIST_DIR="$HOME/Library/LaunchAgents"
PLIST_PATH="$PLIST_DIR/${LABEL}.plist"

mkdir -p "$BIN_DST_DIR" "$LOG_DIR" "$PLIST_DIR"

cp -f "$BIN_SRC" "$BIN_DST"
chmod +x "$BIN_DST"

if command -v xattr >/dev/null 2>&1; then
  xattr -dr com.apple.quarantine "$INSTALL_ROOT" >/dev/null 2>&1 || true
fi

if [ ! -f "$PLIST_TEMPLATE" ]; then
  echo "[CodeFlash] 缺少 plist 模板: $PLIST_TEMPLATE" >&2
  exit 1
fi

tmp_plist="$(mktemp)"
bin_esc="$(escape_sed_replacement "$BIN_DST")"
workdir_esc="$(escape_sed_replacement "$INSTALL_ROOT")"
log_out_esc="$(escape_sed_replacement "$LOG_OUT")"
log_err_esc="$(escape_sed_replacement "$LOG_ERR")"

sed \
  -e "s|__BINARY_PATH__|$bin_esc|g" \
  -e "s|__WORKING_DIR__|$workdir_esc|g" \
  -e "s|__LOG_OUT__|$log_out_esc|g" \
  -e "s|__LOG_ERR__|$log_err_esc|g" \
  "$PLIST_TEMPLATE" > "$tmp_plist"

chmod 0644 "$tmp_plist"
mv -f "$tmp_plist" "$PLIST_PATH"

if command -v plutil >/dev/null 2>&1; then
  if ! plutil -lint "$PLIST_PATH" >/dev/null 2>&1; then
    echo "[CodeFlash] plist 校验失败: $PLIST_PATH" >&2
    echo "[CodeFlash] 请检查路径替换是否正确（不应包含 \\/Users 这类反斜杠）。" >&2
    exit 1
  fi
fi

if [ "${CODEFLASH_SKIP_LAUNCHD:-0}" = "1" ]; then
  echo "[CodeFlash] 已写入 LaunchAgent，但按 CODEFLASH_SKIP_LAUNCHD=1 跳过加载与启动。"
  echo "[CodeFlash] 如需前台运行验证，可直接执行: $BIN_DST"
  exit 0
fi

if launchctl_supports_bootstrap; then
  domain="gui/$UID"
  if ! launchctl_domain_exists "$domain"; then
    domain="user/$UID"
    echo "[CodeFlash] 未检测到 GUI 会话域，改用 $domain 安装并启动。" >&2
    echo "[CodeFlash] 注意：若你需要剪贴板/弹窗能力，请在已登录桌面会话的终端里重新执行安装。" >&2
  fi

  launchctl bootout "$domain" "$PLIST_PATH" >/dev/null 2>&1 || true
  if ! out="$(launchctl bootstrap "$domain" "$PLIST_PATH" 2>&1)"; then
    echo "$out" >&2

    echo "[CodeFlash] 启动失败：launchctl bootstrap 无法加载 LaunchAgent。" >&2
    echo "[CodeFlash] 请确保在已登录桌面会话（Aqua）的终端运行，并且不要使用 sudo。" >&2
    echo "[CodeFlash] 快速排查：" >&2
    echo "  plutil -lint \"$PLIST_PATH\"" >&2
    echo "  launchctl print \"$domain\" | head" >&2
    exit 1
  fi

  launchctl enable "$domain/${LABEL}" >/dev/null 2>&1 || true
  launchctl kickstart -k "$domain/${LABEL}" >/dev/null 2>&1 || true
else
  echo "[CodeFlash] 启动失败：无法加载 LaunchAgent。" >&2
  echo "[CodeFlash] 已完成文件安装，你可以稍后重试，或手动运行二进制：" >&2
  echo "  $BIN_DST" >&2
  exit 1
fi
