#!/bin/bash

# 设置 Flutter SDK 下载链接
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.1-stable.tar.xz"

# 设置解压路径为 Downloads（最终路径将是 ~/Downloads/flutter）
TARGET_DIR="$HOME/Downloads"

# 下载 Flutter SDK 压缩包
echo "📦 正在下载 Flutter SDK..."
curl -L -o /tmp/flutter.tar.xz "$FLUTTER_URL"

# 解压到 ~/Downloads
echo "📂 正在解压 Flutter SDK 到 $TARGET_DIR"
tar -xf /tmp/flutter.tar.xz -C "$TARGET_DIR"

# 设置 PATH（临时）
export PATH="$TARGET_DIR/flutter/bin:$PATH"

# 写入环境变量（永久）
SHELL_RC=""
if [ -n "$ZSH_VERSION" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    SHELL_RC="$HOME/.bashrc"
else
    SHELL_RC="$HOME/.profile"
fi

if ! grep -q 'flutter/bin' "$SHELL_RC"; then
    echo "✅ 写入 PATH 到 $SHELL_RC"
    echo 'export PATH="$HOME/Downloads/flutter/bin:$PATH"' >> "$SHELL_RC"
else
    echo "⚠️ 已经存在 PATH 设置，无需重复写入"
fi

echo "✅ 安装完成！你可以运行 flutter doctor"
echo "👉 请运行：source $SHELL_RC 或重启终端以生效"
