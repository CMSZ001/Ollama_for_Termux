<div align="center">
  <img alt="ollama" height="200px" src="./_images/ollama.png">
</div>

<a href="./README.md">English</a>
&nbsp;&nbsp;| &nbsp;&nbsp;
简体中文

# Ollama for Termux

## 介绍
这是一个用于在 Termux 环境下安装 Ollama 的 Bash 脚本。Ollama 是一款命令行工具，可以在本地运行 Llama 2、Code Llama 等大型语言模型。此脚本通过自动化安装过程，帮助用户轻松地在 Termux 中设置并运行 Ollama。

## 功能
1. 检查并安装必要的依赖项（如`git`、`cmake`  和`golang`）。
2. 提供镜像选择功能，可选择从 Gitee 或 GitHub 克隆 Ollama 代码。
3. 支持使用 Goproxy.cn 加速 Go 模块下载。
3. 自动编译并安装 Ollama 到 Termux 的可执行文件目录。
4. 配置环境变量并更新当前 Shell 配置。
5. 清理临时文件以节省空间。

## 前提条件
- 安装Termux  
[Github Releases](https://github.com/termux/termux-app/releases/latest)&nbsp;&nbsp;[F-Droid](https://f-droid.org/en/packages/com.termux)
- 安装Ollama App（按需安装）  
[Github Releases](https://github.com/JHubi1/ollama-app/releases/latest)
- 良好的网络

## 使用方法
1. 打开Termux
2. 运行以下命令以运行安装脚本  
Github：
```bash
curl -s -o ~/i https://raw.githubusercontent.com/CMSZ001/Ollama_for_Termux/refs/heads/main/install.sh && bash ~/i
```
Gitee：
```bash
curl -s -o ~/i https://gitee.com/CMSZ001/Ollama_for_Termux/raw/main/install.sh && bash ~/i
```
3. 按照脚本提示进行操作，选择是否使用镜像以及是否继续安装。
4. 安装完成后，可以通过运行`ollama`命令来启动 Ollama。

## 版权信息
此脚本由`CMSZ001`编写，基于[MIT License](./LICENSE) 开源。Ollama 的版权信息请参考[Ollama 官方仓库](https://github.com/ollama/ollama)。
