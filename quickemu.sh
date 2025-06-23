#!/bin/bash
# 一键安装 quickemu 和 quickget 到 /usr/local/bin

echo "🔍 正在检测依赖：qemu, zenity, xdg-utils..."
sudo apt update
sudo apt install -y qemu-system-x86 qemu-utils zenity xdg-utils

echo "📥 克隆 quickemu 仓库..."
git clone https://github.com/quickemu-project/quickemu.git /tmp/quickemu

echo "📦 安装 quickemu 和 quickget 到 /usr/local/bin"
sudo install /tmp/quickemu/quickemu /usr/local/bin/
sudo install /tmp/quickemu/quickget /usr/local/bin/

echo "🧹 清理临时文件"
rm -rf /tmp/quickemu

echo "✅ 安装完成，试试 quickget ubuntu 或 quickemu --vm xxx.conf"
