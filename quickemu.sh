#!/bin/bash
# 🚀 一键安装 quickemu 和 quickget 到 /usr/local/bin，并确保 spice viewer 正常工作

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

# 建立 spicy 软链接
if [ ! -f /usr/local/bin/spicy ]; then
  echo "🔗 创建 spicy 到 remote-viewer 的软链接"
  sudo ln -s "$(command -v remote-viewer)" /usr/local/bin/spicy
fi

echo "📥 克隆 quickemu 仓库..."
git clone https://github.com/quickemu-project/quickemu.git /tmp/quickemu

echo "📦 安装 quickemu 和 quickget 到 /usr/local/bin"
sudo install /tmp/quickemu/quickemu /usr/local/bin/
sudo install /tmp/quickemu/quickget /usr/local/bin/

echo "🧹 清理临时文件"
rm -rf /tmp/quickemu

echo "✅ 安装完成！🎉"
echo "👉 你现在可以运行：quickget ubuntu-mate-24.04 && quickemu --vm ubuntu-mate-24.04.conf"
