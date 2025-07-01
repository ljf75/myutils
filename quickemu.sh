#!/bin/bash
# 🚀 完整安装 quickemu 到 ~/Downloads/local，脱离系统运行环境

set -euo pipefail

LOCAL_DIR="$HOME/Downloads/local"
BIN_DIR="$LOCAL_DIR/deps/bin"
LIB_DIR="$LOCAL_DIR/deps/lib"
OVMF_DIR="$LOCAL_DIR/deps/OVMF"
QUICKEMU_REPO="https://github.com/quickemu-project/quickemu.git"
QUICKEMU_LOCAL="$LOCAL_DIR/quickemu"
SHARE_REPLACE_DIR="$LOCAL_DIR/deps"

echo "📁 创建本地目录..."
mkdir -p "$BIN_DIR" "$LIB_DIR" "$OVMF_DIR"

echo "🔍 安装必要软件包（需要 sudo 权限）..."
sudo apt update
sudo apt install -y qemu-system-x86 qemu-utils virt-viewer spice-client-gtk zenity xdg-utils ovmf

echo "📥 克隆 quickemu 仓库..."
rm -rf /tmp/quickemu
git clone --depth=1 "$QUICKEMU_REPO" /tmp/quickemu

echo "📦 拷贝 quickemu 和 quickget 到 $LOCAL_DIR"
cp /tmp/quickemu/bin/quickemu "$QUICKEMU_LOCAL"
cp /tmp/quickemu/bin/quickget "$LOCAL_DIR/quickget"

echo "🛠 修改 quickemu 脚本中默认 /usr/share 路径为 $SHARE_REPLACE_DIR"
sed -i "s|/usr/share|$SHARE_REPLACE_DIR|g" "$QUICKEMU_LOCAL"

echo "📥 拷贝依赖的 QEMU 可执行文件到 $BIN_DIR，并复制其动态链接库到 $LIB_DIR"
for bin in qemu-system-x86_64 qemu-img remote-viewer spicy; do
    BIN_PATH="$(command -v $bin || true)"
    if [ -x "$BIN_PATH" ]; then
        cp "$BIN_PATH" "$BIN_DIR/"
        echo "✅ 已复制 $bin"

        echo "🔍 复制 $bin 的依赖库..."
        ldd "$BIN_PATH" | awk '/=>/ {print $3}' | while read -r lib; do
            [ -f "$lib" ] && cp -n "$lib" "$LIB_DIR/" 2>/dev/null || true
        done
    else
        echo "⚠️ 未找到可执行文件 $bin，跳过"
    fi
done

echo "📦 复制整个 /usr/share/OVMF 到 $OVMF_DIR（如果不存在）"
if [ ! -d "$OVMF_DIR" ]; then
    cp -r /usr/share/OVMF "$LOCAL_DIR/deps/"
    echo "✅ OVMF 固件已复制"
else
    echo "✅ OVMF 目录已存在，跳过复制"
fi

# ✅ 设置环境变量写入 shell 启动脚本
SHELL_RC="$HOME/.bashrc"
[[ "$SHELL" == *zsh ]] && SHELL_RC="$HOME/.zshrc"

if ! grep -qF "$LOCAL_DIR" "$SHELL_RC"; then
    echo "📌 写入环境变量到 $SHELL_RC"
    {
        echo ""
        echo "# Quickemu 本地运行环境"
        echo "export PATH=\"$LOCAL_DIR:$BIN_DIR:\$PATH\""
        echo "export LD_LIBRARY_PATH=\"$LIB_DIR:\$LD_LIBRARY_PATH\""
        echo "export OVMF_DIR=\"$OVMF_DIR\""
        echo "export QUICKEMU_DIR=\"$SHARE_REPLACE_DIR\""
    } >> "$SHELL_RC"
else
    echo "✅ 环境变量已存在于 $SHELL_RC，跳过写入"
fi

echo ""
echo "✅ 安装完成！你可以运行以下命令立即生效环境变量："
echo "   source \"$SHELL_RC\""
echo ""
echo "🎉 现在你可以运行 quickemu:"
echo "   $QUICKEMU_LOCAL --vm your-vm.conf"
