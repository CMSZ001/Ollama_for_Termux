#!/bin/bash

# Mirrior selection
echo "Do you want to use a mirror? | 你想使用镜像吗？"
read -p "Please enter your choice | 请输入你的选择 (Y/n): " mirror_choice
mirror_choice=$(echo "$mirror_choice" | tr '[:upper:]' '[:lower:]')

case $mirror_choice in
    y|'')
        mirrors=1
        ;;
    n)
        mirrors=0
        ;;
    *)
        echo "Invalid choice! | 无效的选择！"
        exit 1
        ;;
esac

#Installing Necessary Dependencies
apt update
apt install -y git cmake golang

#Installing Ollama
echo "Installing Ollama... | 正在安装Ollama..."
if [ "$mirrors" = 1 ]; then
    git clone --depth=1 https://ghproxy.cn/https://github.com/ollama/ollama.git
    git remote set-url origin https://github.com/ollama/ollama.git
else
    git clone --depth=1 https://github.com/ollama/ollama.git
fi

cd ollama

# Building Ollama
echo "Building Ollama... | 正在编译ollama..."
if [ "$mirrors" = 1 ]; then
    export GO111MODULE=on
    export GOPROXY=https://mirrors.aliyun.com/goproxy/,direct
fi

go generate ./...
go build .

# Moving Ollama to Termux's bin directory
ln -s /data/data/com.termux/files/home/ollama/ollama /data/data/com.termux/files/usr/bin/ollama

echo "Ollama has been installed successfully! | Ollama 安装成功！"
echo "You can now run 'ollama' in Termux to start Ollama. | 你可以在 Termux 中运行 'ollama' 开始使用 Ollama。"
echo "Enjoy Ollama! | 享受 Ollama 吧！"
