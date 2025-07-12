#!/bin/bash

set -e

# 设置变量
VSCODE_URL="https://update.code.visualstudio.com/latest/linux-x64/stable"
INSTALL_DIR="$HOME/Downloads/vscode"
TARBALL="$HOME/Downloads/vscode.tar.gz"
DESKTOP_FILE="$HOME/.local/share/applications/vscode.desktop"

# 清理旧文件（可选）
echo "🧹 清理旧版本..."
rm -rf "$INSTALL_DIR"
rm -f "$TARBALL"

# 下载 VSCode
echo "⬇️ 正在下载 VSCode..."
wget -O "$TARBALL" "$VSCODE_URL"

# 解压并重命名
echo "📦 解压中..."
tar -xzf "$TARBALL" -C "$HOME/Downloads"
mv "$HOME/Downloads/VSCode-linux-x64" "$INSTALL_DIR"

# 检查图标是否存在
ICON_PATH="$INSTALL_DIR/resources/app/resources/linux/code.png"
if [[ ! -f "$ICON_PATH" ]]; then
  echo "❌ 图标文件找不到：$ICON_PATH"
  exit 1
fi

# 写入 .desktop 文件
echo "🛠️ 正在创建快捷方式..."
mkdir -p "$(dirname "$DESKTOP_FILE")"
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Visual Studio Code
Comment=Code Editor
Exec=$INSTALL_DIR/code --disable-gpu --no-sandbox --disable-software-rasterizer %F
Icon=$ICON_PATH
Type=Application
Categories=Development;IDE;
Terminal=false
StartupNotify=true
StartupWMClass=Code
EOF

# 设置权限 & 更新数据库
chmod +x "$DESKTOP_FILE"
update-desktop-database ~/.local/share/applications/

rm $TARBALL

# 完成
echo "✅ VSCode 安装完成！你可以在应用菜单中搜索“Visual Studio Code”运行。"
