# 定义安装 Quickemu 的函数（使用函数而非别名）
qemu_install() {
    sudo add-apt-repository ppa:flexiondotorg/quickemu -y
    sudo apt update
    sudo apt install quickemu -y
}

# 检查是否安装了 ffmpeg，如果没有安装则安装它
command -v ffmpeg >/dev/null 2>&1 || sudo apt update && sudo apt install -y ffmpeg

# 检查是否安装了 quickemu，如果没有安装则执行 qemu_install 函数
command -v quickemu >/dev/null 2>&1 || qemu_install

# 定义安装 yt-dlp 的函数
install_ytdlp() {
    # 设置下载目录
    DOWNLOAD_DIR="$HOME/Downloads"

    # 创建下载目录（如果不存在）
    mkdir -p "$DOWNLOAD_DIR"

    # 下载 yt-dlp 二进制文件并设置可执行权限，重定向所有输出到 /dev/null
    curl -L "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp" -o "$DOWNLOAD_DIR/yt-dlp" >/dev/null 2>&1
    chmod +x "$DOWNLOAD_DIR/yt-dlp" >/dev/null 2>&1

    # 如果 PATH 中没有 ~/Downloads 目录，则将其添加到 ~/.bashrc 中
    grep -q "$DOWNLOAD_DIR" "$HOME/.bashrc" || echo "export PATH=\"$DOWNLOAD_DIR:\$PATH\"" >> "$HOME/.bashrc"
}

# 检查是否安装了 yt-dlp，如果没有则安装
command -v yt-dlp >/dev/null 2>&1 || install_ytdlp
grep -q 'alias yt=' ~/.bashrc || echo 'alias yt="yt-dlp -f \"bv*+ba/best\" --merge-output-format mp4"' >> ~/.bashrc
