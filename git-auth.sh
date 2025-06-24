#!/bin/bash
# 🚀 一键配置 Git 自动认证（用户名 + token），以后 push 不用再输入

# === 获取用户输入 ===
read -p "请输入你的 Git 用户名（例如：andy）: " GIT_USER
read -p "请输入你的 Git 远程仓库地址（例如：https://github.com/andy/myrepo.git）: " GIT_URL
read -s -p "请输入你的 Git Token（不会显示）: " GIT_TOKEN
echo ""

# === 设置 Git 凭据保存机制 ===
echo "🔐 配置 Git 记住你的认证信息..."
git config --global credential.helper store

# === 拼接含认证信息的 URL ===
AUTH_URL=$(echo "$GIT_URL" | sed "s#https://#https://$GIT_USER:$GIT_TOKEN@#")

# === 试探性 push 来触发认证缓存（不会新建 commit）===
echo "🚀 执行 git push 来缓存凭据（不会产生新 commit）..."
git push "$AUTH_URL"

# === 检查是否成功缓存 ===
if grep -q "$GIT_USER:$GIT_TOKEN" ~/.git-credentials 2>/dev/null; then
    echo "✅ 凭据已保存，下次 push 将自动使用"
else
    echo "❌ 未能保存凭据，请检查 token 是否正确"
fi
