#!/bin/bash

# 设置路径变量
DOWNLOAD_DIR="$HOME/Downloads"
TG_ARCHIVE="$DOWNLOAD_DIR/tg.txz"
TG_DIR="$DOWNLOAD_DIR/Telegram"
TG_BIN="$DOWNLOAD_DIR/tg"

# 创建下载目录（如果不存在）
mkdir -p "$DOWNLOAD_DIR"

# 下载 Telegram
echo "📥 正在下载 Telegram..."
wget -O "$TG_ARCHIVE" https://telegram.org/dl/desktop/linux

# 检查下载是否成功
if [[ ! -f "$TG_ARCHIVE" ]]; then
  echo "❌ 下载失败，请检查网络或网址。"
  exit 1
fi

# 解压归档文件
echo "📦 解压中..."
tar -xf "$TG_ARCHIVE" -C "$DOWNLOAD_DIR"

# 移动主程序并清理多余文件
if [[ -f "$TG_DIR/Telegram" ]]; then
  mv "$TG_DIR/Telegram" "$TG_BIN"
  chmod +x "$TG_BIN"
  rm -rf "$TG_DIR" "$TG_ARCHIVE"
else
  echo "❌ 没有找到 Telegram 可执行文件，可能下载格式改变。"
  exit 2
fi

# 添加别名到 ~/.bashrc（防止重复添加）
if ! grep -q 'alias tg=' ~/.bashrc; then
  echo 'alias tg="$HOME/Downloads/tg"' >> ~/.bashrc
  echo "✅ 已添加命令别名：tg"
else
  echo "ℹ️ 命令别名 tg 已存在，跳过添加。"
fi

# 结束提示
echo "🚀 现在你可以用 'tg' 启动 Telegram。"
