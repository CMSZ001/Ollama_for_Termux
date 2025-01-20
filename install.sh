#!/bin/sh

# Initialization
rm -rf i
cd /data/data/com.termux/files/home

# Mirror selection

read -p "Do you want to use a mirror? | 你想使用镜像吗？ (Y/n): " mirror_choice
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

clear

# Function to check and install a package
check_and_install() {
    package=$1
    if ! dpkg -s $package > /dev/null 2>&1; then
        echo "Installing $package... | 安装 $package…"
        apt install -y $package
    else
        echo "$package is already installed. | 已安装 $package"
    fi
}

# Installing Necessary Dependencies
echo "Updating package lists... | 正在更新软件包列表..."
apt update

echo "Checking and installing necessary dependencies..."
check_and_install git
check_and_install cmake
check_and_install golang

clear

# Installing Ollama
echo "Installing Ollama... | 正在安装Ollama..."
if [ "$mirrors" = 1 ]; then
    git clone --depth=1 https://ghproxy.cn/https://github.com/ollama/ollama.git
    cd ollama
    git remote set-url origin https://github.com/ollama/ollama.git
else
    git clone --depth=1 https://github.com/ollama/ollama.git
    cd ollama
fi

clear

# Building Ollama
echo "Building Ollama... | 正在编译ollama..."
if [ "$mirrors" = 1 ]; then
    export GO111MODULE=on
    export GOPROXY=https://goproxy.cn
fi

go generate ./...
go build .

clear

# Moving Ollama to Termux's bin directory
ln -sf /data/data/com.termux/files/home/ollama/ollama /data/data/com.termux/files/usr/bin/ollama

# Configuration
default_shell=$(echo $SHELL | awk -F'/' '{print $NF}')
profile_file=""

if [ "$default_shell" = "bash" ]; then
    profile_file="/data/data/com.termux/files/home/.bashrc"
elif [ "$default_shell" = "zsh" ]; then
    profile_file="/data/data/com.termux/files/home/.zshrc"
else
    echo "Unsupported shell: $default_shell | 不支持的 shell：$default_shell
"
    exit 1
fi

# Ensure the profile file exists
if [ ! -f "$profile_file" ]; then
    touch "$profile_file"
fi

# Add OLLAMA_HOST to the profile file if not already present
if ! grep -q "^export OLLAMA_HOST=" "$profile_file"; then
    echo 'export OLLAMA_HOST=0.0.0.0' >> "$profile_file"
fi

# Reload configuration in the current shell
if [ "$default_shell" = "bash" ]; then
    . "$profile_file"
elif [ "$default_shell" = "zsh" ]; then
    zsh -c "source $profile_file"
fi

# Cleanup
chmod -R 700 /data/data/com.termux/files/home/go
rm -rf /data/data/com.termux/files/home/go

clear

# Tips
echo "Ollama has been installed successfully! | Ollama 安装成功！"
echo "You can now run 'ollama' in Termux to start Ollama. | 你可以在 Termux 中运行 'ollama' 开始使用 Ollama。"
echo "Enjoy Ollama! | 享受 Ollama 吧！"
