#!/bin/bash

# Color Codes
readonly red="\e[91m"   # Red  | 红色
readonly bw="\e[1m"     # Bold white | 亮白色
readonly grey="\e[90m"  #Grey | 灰色
readonly nocol="\e[0m"  # Default | 默认

# Initialization
initialize() {
    if [ -d "$HOME/.ollama" ]; then
        rm -rf "$HOME/.ollama"
    fi
    cd "$HOME"
}

# Function to check and install a package
check_and_install() {
    package=$1
    if ! dpkg -s $package > /dev/null 2>&1; then
        echo -e "${bw}Installing $package... | 安装 $package…${nocol}"
        echo -e "${grey}\c"
        apt install -y $package -qq
        echo -e "${nocol}\c"
    else
        echo -e "${grey}$package is already installed. | 已安装 $package。${nocol}"
    fi
}

# Install necessary dependencies
install_dependencies() {
    echo -e "${bw}Updating package lists... | 正在更新软件包列表...${nocol}"
    echo -e "${grey}\c"
    apt update -qq
    echo -e "${nocol}\c"
    echo -e "C${bw}hecking and installing necessary dependencies... | 正在检查并安装必要的依赖项...${nocol}"
    check_and_install git
    check_and_install cmake
    check_and_install golang
}

# Mirror selection
configure_mirrors() {
    echo -e "${bw}Do you want to use a mirror? | 你想使用镜像吗？ (Y/n):${nocol}"
    read -p "" mirror_choice
    mirror_choice=$(echo "$mirror_choice" | tr '[:upper:]' '[:lower:]')
    case $mirror_choice in
        y|'')
            mirrors=1
            ;;
        n)
            mirrors=0
            ;;
        *)
            echo -e "${red}Invalid choice! | 无效的选择！${nocol}"
            exit 1
            ;;
    esac
}

# Clone Ollama repository
clone_ollama() {
    echo -e "${bw}Installing Ollama... | 正在安装Ollama...${nocol}"
    if [ "$mirrors" = 1 ]; then
        echo -e "${grey}\c"
        git clone --depth=1 https://gitee.com/mirrors/ollama.git "$HOME/.ollama"
        cd "$HOME/.ollama"
        echo -e "${nocol}\c"
    else
        echo -e "${grey}\c"
        git clone --depth=1 https://github.com/ollama/ollama.git "$HOME/.ollama"
        cd "$HOME/.ollama"
        echo -e "${nocol}\c"
    fi
}

# Build Ollama
build_ollama() {
    echo -e "${bw}Building Ollama... | 正在编译ollama...${nocol}"
    if [ "$mirrors" = 1 ]; then
        echo -e "${grey}\c"
        go env -w GO111MODULE=on
        go env -w GOPROXY=https://goproxy.cn,direct
        echo -e "${nocol}\c"
    fi
    GreyStecho -e "${grey}\c"art
    go generate ./...
    go build .
    echo -e "${nocol}\c"
}

# Move Ollama to Termux's bin directory
move_to_bin() {
    ln -sf "$HOME/.ollama/ollama" "$PREFIX/bin/ollama"
}

# Configure shell profile
configure_profile() {
    default_shell=$(echo $SHELL | awk -F'/' '{print $NF}')
    if [ "$default_shell" = "bash" ]; then
        profile_file="$HOME/.bashrc"
    elif [ "$default_shell" = "zsh" ]; then
        profile_file="$HOME/.zshrc"
    else
        profile_file="$HOME/profile"
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
        source "$HOME/.profile"
    elif [ "$default_shell" = "zsh" ]; then
        zsh -c "source $profile_file"
    fi
}

# Cleanup
cleanup() {
    chmod -R 700 "$HOME/go"
    rm -rf "$HOME/go"
}

# Show tips
finish_install() {
    echo -e "${bw}Ollama has been installed successfully! | Ollama 安装成功！${nocol}"
    echo -e "${bw}You can now run \"ollama\" in Termux to start Ollama. | 你可以在 Termux 中运行 \"ollama\" 以开始使用 Ollama。${nocol}"
    echo -e "${bw}Enjoy Ollama! | 享受 Ollama 吧！${nocol}"
}

# Start installation
rm -rf i
clear
echo -e "${bw}Install Ollama? | 是否安装 Ollama？[Y/n]${nocol}"
read -p "" -n 1 -r yn
case ${yn} in
    [Yy]* | "")
        initialize
        install_dependencies
        configure_mirrors
        clone_ollama
        build_ollama
        move_to_bin
        configure_profile
        cleanup
        finish_install
        exit 0
        ;;
    [Nn]*)
        echo -e "${red}Installation aborted! | 安装已被中止！${nocol}"
        exit 1
        ;;
    *)
        echo -e "${red}Invalid choice! | 无效的选择！${nocol}"
        echo ""
        exit 1
        ;;
esac
