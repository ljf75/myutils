#!/bin/bash

# 安装 yt-dlp 的函数
install_yt_dlp() {
  echo "检查 yt-dlp 是否已安装..."
  if ! command -v yt-dlp &> /dev/null; then
    echo "yt-dlp 未找到，正在安装..."
    sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
    sudo chmod +x /usr/local/bin/yt-dlp
    echo "yt-dlp 安装完成。"
  else
    echo "yt-dlp 已安装。"
  fi
}

# 获取 Bilibili 用户 ID
read -p "请输入 Bilibili 用户 ID (UID): " user_id

# 创建输出文件夹
output_dir="Video/up_${user_id}"
mkdir -p "$output_dir"

# 设置视频下载格式
format="-f bestvideo+bestaudio --merge-output-format mp4"

# 定义下载记录文件
archive_file="downloaded.txt"

# 安装 yt-dlp
install_yt_dlp

# 下载用户的系列视频
echo "开始下载用户 ID 为 $user_id 的系列视频..."

yt-dlp $format --download-archive "$archive_file" -o "$output_dir/%(title)s.%(ext)s" "https://space.bilibili.com/$user_id"

# 完成提示
echo "下载完成，文件保存到 $output_dir 目录。"
