alias qemu="sudo add-apt-repository ppa:flexiondotorg/quickemu -y && sudo apt update && sudo apt install quickemu -y"
alias yt="yt-dlp -f 'bv*+ba/best' --merge-output-format mp4"
command -v ffmpeg >/dev/null 2>&1 || sudo apt update && sudo apt install -y ffmpeg
command -v quickemu >/dev/null 2>&1 || qemu
