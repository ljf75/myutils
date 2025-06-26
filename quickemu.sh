#!/bin/bash
# 🚀 安装 quickemu 和 quickget 到 ~/Downloads/local，并将所有依赖复制本地，确保永久可用

set -e

LOCAL_DIR="$HOME/Downloads/local"
BIN_DIR="$LOCAL_DIR/dependency/bin"
LIB_DIR="$LOCAL_DIR/dependency/lib"

echo "📁 创建目录：$BIN_DIR 和 $LIB_DIR"
mkdir -p "$BIN_DIR" "$LIB_DIR"

echo "🔍 安装必要软件包（需要 sudo 权限）..."
sudo apt update
sudo apt install -y qemu-system-x86 qemu-utils virt-viewer spice-client-gtk git zenity xdg-utils

echo "📥 克隆 quickemu 仓库..."
git clone https://github.com/quickemu-project/quickemu.git /tmp/quickemu

echo "📦 拷贝 quickemu 和 quickget 到 $LOCAL_DIR"
cp /tmp/quickemu/quickemu "$LOCAL_DIR/"
cp /tmp/quickemu/quickget "$LOCAL_DIR/"
rm -rf /tmp/quickemu

echo "📥 拷贝依赖的二进制到 $BIN_DIR，并复制相关库到 $LIB_DIR"
for bin in qemu-system-x86_64 qemu-img remote-viewer spicy; do
    BIN_PATH="$(command -v $bin)"
    if [ -x "$BIN_PATH" ]; then
        cp "$BIN_PATH" "$BIN_DIR/"
        echo "📦 已复制 $bin"

        echo "🔍 分析 $bin 的依赖库..."
        ldd "$BIN_PATH" | awk '/=>/ {print $3}' | while read lib; do
            [ -f "$lib" ] && cp -n "$lib" "$LIB_DIR/" 2>/dev/null || true
        done
    else
        echo "⚠️ 警告：未找到可执行文件 $bin，已跳过"
    fi
done

# ✅ 写入环境变量到 shell 启动文件
SHELL_RC="$HOME/.bashrc"
[[ "$SHELL" == *zsh ]] && SHELL_RC="$HOME/.zshrc"

if ! grep -qF "$LOCAL_DIR" "$SHELL_RC"; then
  echo "📌 添加 quickemu 本地路径到 $SHELL_RC（PATH 和 LD_LIBRARY_PATH）..."
  {
    echo ""
    echo "# Quickemu 本地运行环境"
    echo "export PATH=\"$LOCAL_DIR:$BIN_DIR:\$PATH\""
    echo "export LD_LIBRARY_PATH=\"$LIB_DIR:\$LD_LIBRARY_PATH\""
  } >> "$SHELL_RC"
fi

echo "✅ 所有组件已安装，环境变量已永久配置！"
echo "👉 请运行以下命令立即生效："
echo "   source $SHELL_RC"
echo "🎉 然后你可以直接运行 quickemu 和 quickget 了！"
