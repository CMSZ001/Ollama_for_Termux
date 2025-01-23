#!/data/data/com.termux/files/usr/bin/bash

# Initialization
initialize() {
    echo -e "Initializing... | 初始化中..."
    if [ -d "$HOME/.ollama" ]; then
        rm -rf "$HOME/.ollama"
    fi
    cd "$HOME"
}

# Function to check and install a package
check_and_install() {
    package=$1
    if ! dpkg -s $package > /dev/null 2>&1; then
        echo -e "Installing $package... | 安装 $package…"
        apt install -y $package
    else
        echo -e "$package is already installed. | 已安装 $package"
    fi
}

# Install necessary dependencies
install_dependencies() {
    echo -e "Updating package lists... | 正在更新软件包列表..."
    apt update
    echo -e "Checking and installing necessary dependencies... | 正在检查并安装必要的依赖项..."
    check_and_install git
    check_and_install cmake
    check_and_install golang
}

# Mirror selection
configure_mirrors() {
    echo -e "Do you want to use a mirror? | 你想使用镜像吗？ (Y/n):"
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
            echo -e "Invalid choice! | 无效的选择！"
            exit 1
            ;;
    esac
}

# Clone Ollama repository
clone_ollama() {
    echo -e "Cloning Ollama... | 正在克隆Ollama..."
    if [ "$mirrors" = 1 ]; then
        git clone --depth=1 https://gitee.com/mirrors/ollama.git "$HOME/.ollama"
        cd "$HOME/.ollama"
    else
        git clone --depth=1 https://github.com/ollama/ollama.git "$HOME/.ollama"
        cd "$HOME/.ollama"
    fi
    clear
}

# Build Ollama
build_ollama() {
    echo -e "Building Ollama... | 正在编译ollama..."
    if [ "$mirrors" = 1 ]; then
        go env -w GO111MODULE=on
        go env -w GOPROXY=https://goproxy.cn,direct
    fi
    go generate ./...
    go build .
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
    clear
    echo -e "Ollama has been installed successfully! | Ollama 安装成功！"
    echo -e "You can now run 'ollama' in Termux to start Ollama. | 你可以在 Termux 中运行 'ollama' 以开始使用 Ollama。"
    echo -e "Enjoy Ollama! | 享受 Ollama 吧！"
}

# Start installation
echo -e "Install Ollama? | 是否安装 Ollama？[Y/n]"
read -p "" -n 1 -r yn
echo "" # For newline
case ${yn} in
    [Yy]* | "")
        clear
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
        echo -e "Installation aborted! | 安装已被中止！"
        exit 1
        ;;
    *)
        echo -e "Invalid choice! | 无效的选择！"
        echo ""
        exit 1
        ;;
esac
}
