#!/bin/bash

# ==============================================================================
# CodeFlash 发布脚本
# ==============================================================================
# 功能：
# 1. 编译 macOS 双架构 (amd64 & arm64) 二进制文件
# 2. 更新离线安装目录 CodeFlash-mac
# 3. 生成 GitHub Release 所需的压缩包和校验文件
# 4. 更新本地 Homebrew Formula 配置
# ==============================================================================

set -euo pipefail

# 参数校验
TAG="${1:-}"
if [ -z "$TAG" ]; then
    echo "❌ 错误: 未提供版本号 (Tag)" >&2
    echo "用法: ./release.sh <tag>" >&2
    echo "示例: ./release.sh v1.0.1" >&2
    exit 1
fi

# 目录定义
SERVER_DIR="$(cd "$(dirname "$0")" && pwd)"
OFFLINE_DIR="$SERVER_DIR/CodeFlash-mac"
RELEASES_DIR="$SERVER_DIR/releases/$TAG"
HOMEBREW_DIR="$SERVER_DIR/homebrew-codeflash"

# 版本号处理 (移除前面的 'v')
VERSION="${TAG#v}"

echo "🚀 开始发布流程: $TAG"
echo "------------------------------------------------"

# 1. 创建发布目录
mkdir -p "$RELEASES_DIR"

# 2. 编译二进制文件
echo "📦 正在编译二进制文件..."
GOOS=darwin GOARCH=amd64 go build -ldflags="-s -w" -o "$OFFLINE_DIR/codeflash-server-amd64" .
echo "   ✅ 已生成: codeflash-server-amd64 (Intel)"

GOOS=darwin GOARCH=arm64 go build -ldflags="-s -w" -o "$OFFLINE_DIR/codeflash-server-arm64" .
echo "   ✅ 已生成: codeflash-server-arm64 (Apple Silicon)"

chmod +x "$OFFLINE_DIR/codeflash-server-amd64" "$OFFLINE_DIR/codeflash-server-arm64"

# 移除旧的单架构文件（如果存在）
rm -f "$OFFLINE_DIR/codeflash-server"

# 3. 生成 Homebrew 用的 tar.gz 包
echo "📦 正在打包 Homebrew 资源..."
tmp_dir="$(mktemp -d)"
cp "$OFFLINE_DIR/codeflash-server-amd64" "$tmp_dir/codeflash-server-amd64"
cp "$OFFLINE_DIR/codeflash-server-arm64" "$tmp_dir/codeflash-server-arm64"

(cd "$tmp_dir" && tar -czf "$RELEASES_DIR/codeflash-server-macos-amd64.tar.gz" codeflash-server-amd64)
(cd "$tmp_dir" && tar -czf "$RELEASES_DIR/codeflash-server-macos-arm64.tar.gz" codeflash-server-arm64)
rm -rf "$tmp_dir"
echo "   ✅ 已生成 tar.gz 资源"

# 4. 生成离线安装包 (ZIP)
echo "📦 正在生成离线安装包..."
chmod +x "$OFFLINE_DIR/install-mac.sh" "$OFFLINE_DIR/uninstall-mac.sh"
zip_path="$RELEASES_DIR/CodeFlash-mac.zip"
rm -f "$zip_path"

if [[ "$OSTYPE" == "darwin"* ]]; then
    # 使用 ditto 保留权限和结构，且不包含 macOS 资源分叉 (._ 文件)
    ditto -c -k --keepParent --norsrc --noextattr "$OFFLINE_DIR" "$zip_path"
else
    (cd "$SERVER_DIR" && zip -rq "$zip_path" "$(basename "$OFFLINE_DIR")")
fi
echo "   ✅ 已生成: CodeFlash-mac.zip"

# 5. 生成校验和
echo "📝 正在生成校验和..."
(cd "$RELEASES_DIR" && shasum -a 256 *.tar.gz *.zip > SHA256SUMS.txt)
echo "   ✅ 已生成: SHA256SUMS.txt"

# 6. 更新 Homebrew Formula
echo "🔧 正在更新 Homebrew Formula..."

SHA_AMD=$(awk '/codeflash-server-macos-amd64.tar.gz/{print $1}' "$RELEASES_DIR/SHA256SUMS.txt")
SHA_ARM=$(awk '/codeflash-server-macos-arm64.tar.gz/{print $1}' "$RELEASES_DIR/SHA256SUMS.txt")

URL_BASE="https://github.com/ZestBox-18/homebrew-codeflash/releases/download/$TAG"
URL_AMD="$URL_BASE/codeflash-server-macos-amd64.tar.gz"
URL_ARM="$URL_BASE/codeflash-server-macos-arm64.tar.gz"

# 更新 Formula 文件的函数
update_formula() {
    local file="$1"
    [ -f "$file" ] || return 0
    
    # 更新版本号
    sed -i '' "s/version \".*\"/version \"$VERSION\"/" "$file"
    
    # 使用 perl 进行多行匹配替换 URL 和 SHA256
    # 替换 ARM 部分
    perl -i -0777 -pe "s|(if Hardware::CPU\.arm\?\s+url\s+\").*?(\"\s+sha256\s+\").*?(\")|\${1}$URL_ARM\${2}$SHA_ARM\${3}|g" "$file"
    # 替换 AMD 部分
    perl -i -0777 -pe "s|(else\s+url\s+\").*?(\"\s+sha256\s+\").*?(\")|\${1}$URL_AMD\${2}$SHA_AMD\${3}|g" "$file"
}

update_formula "$HOMEBREW_DIR/Formula/codeflash.rb"
update_formula "$HOMEBREW_DIR/codeflash.rb"
echo "   ✅ 已更新本地 Formula 配置"

echo "------------------------------------------------"
echo "✨ 发布准备完成！"
echo "📍 发布文件目录: $RELEASES_DIR"
echo ""
echo "👉 请执行以下操作完成发布:"
echo "1. 手动上传 $RELEASES_DIR 内的所有文件到 GitHub Release (Tag: $TAG)"
echo "2. 提交并推送 Homebrew Formula 的更改:"
echo "   cd $HOMEBREW_DIR"
echo "   git add ."
echo "   git commit -m \"Update to $TAG\""
echo "   git push"
echo "------------------------------------------------"
