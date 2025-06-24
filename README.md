# 📦 我的工具包（实用 Bash 工具）

## ⬇️ 安装 Telegram 桌面版

在终端中运行以下命令即可一键安装 Telegram（自动下载并设置 tg 命令别名）：

```bash
curl -s https://raw.githubusercontent.com/ljf75/myutils/main/install_tg.sh | bash && source ~/.bashrc
```

## 📺 使用 B站视频下载脚本

添加别名后可直接使用 `bili` 命令下载视频：

```bash
echo "alias bili='curl -s https://raw.githubusercontent.com/ljf75/myutils/main/bili.sh | bash -s'" >> ~/.bashrc && source ~/.bashrc
```

使用方法（示例）：

```bash
bili [视频UID]
```
