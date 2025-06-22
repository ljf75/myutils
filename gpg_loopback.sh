#!/bin/bash

# 创建配置目录（如果不存在）
mkdir -p ~/.gnupg
chmod 700 ~/.gnupg

# 设置 gpg.conf（启用 loopback 模式）
echo "pinentry-mode loopback" >> ~/.gnupg/gpg.conf

# 设置 gpg-agent.conf（允许 loopback pinentry）
echo "allow-loopback-pinentry" >> ~/.gnupg/gpg-agent.conf

# 杀掉正在运行的 gpg-agent（强制刷新配置）
gpgconf --kill gpg-agent

# 输出提示
echo "✅ GPG 已配置为使用 loopback 模式（终端输入密码）"
