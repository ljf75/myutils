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
