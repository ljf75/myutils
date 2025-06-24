#!/bin/bash
# 🚀 下载 quickemu 和 quickget 到 ~/Downloads/local，并确保 spice viewer 正常工作

echo "🔍 正在检测并安装依赖：qemu, zenity, xdg-utils..."
sudo apt update
sudo apt install -y qemu-system-x86 qemu-utils zenity xdg-utils git

echo "🔍 正在检测并安装 SPICE viewer (virt-viewer)..."
sudo apt install -y virt-viewer

# 检查 remote-viewer 是否存在
if ! command -v remote-viewer &>/dev/null; then
  echo "❌ remote-viewer 没有找到，请检查 virt-viewer 包是否正确安装"
  exit 1
fi

# 建立下载目录
mkdir -p ~/Downloads/local

# 建立 spicy 软链接
if [ ! -f ~/Downloads/local/spicy ]; then
  echo "🔗 创建 spicy 到 remote-viewer 的软链接 (~/Downloads/local/spicy)"
  ln -s "$(command -v remote-viewer)" ~/Downloads/local/spicy
fi

echo "📥 克隆 quickemu 仓库到 /tmp/quickemu..."
git clone https://github.com/quickemu-project/quickemu.git /tmp/quickemu

echo "📦 拷贝 quickemu 和 quickget 到 ~/Downloads/local"
cp /tmp/quickemu/quickemu ~/Downloads/local/
cp /tmp/quickemu/quickget ~/Downloads/local/

echo "🧹 清理临时文件"
rm -rf /tmp/quickemu

# 设置环境变量（仅当前会话）
export PATH="$HOME/Downloads/local:$PATH"

# 永久添加到 .bashrc 或 .zshrc
if [[ "$SHELL" == *zsh ]]; then
  SHELL_RC="$HOME/.zshrc"
else
  SHELL_RC="$HOME/.bashrc"
fi

if ! grep -q 'Downloads/local' "$SHELL_RC"; then
  echo "📌 将 ~/Downloads/local 添加到 PATH 中（写入 $SHELL_RC）"
  echo 'export PATH="$HOME/Downloads/local:$PATH"' >> "$SHELL_RC"
fi

echo "✅ 安装完成！🎉"
echo "👉 你现在可以直接运行：quickget ubuntu-mate-24.04 && quickemu --vm ubuntu-mate-24.04.conf"
