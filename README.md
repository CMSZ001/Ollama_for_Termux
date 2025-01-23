<div align="center">
  <img alt="ollama" height="200px" src="./_images/ollama.png">
</div>

English
&nbsp;&nbsp;| &nbsp;&nbsp;
<a href="./README_zh-cn.md">简体中文</a>

# Ollama for Termux

## Introduction
This is a Bash script for installing Ollama in the Termux environment.Ollama is a command-line tool that allows you to run large language models such as Llama 2 and Code Llama locally.This script helps users easily set up and run Ollama in Termux by automating the installation process.

## Prerequisites

- Install Termux
[Github Releases](https://github.com/termux/termux-app/releases/latest)&nbsp;&nbsp;
[F-Droid](https://f-droid.org/en/packages/com.termux)
- Install Ollama App (install as needed)
[Github Releases](https://github.com/JHubi1/ollama-app/releases/latest)
- Good network

## Usage

1. Open Termux
2. Run the following command to execute the installation script.  
Github:
```bash
curl -s -o ~/i https://raw.githubusercontent.com/CMSZ001/Ollama_for_Termux/refs/heads/main/install.sh && bash ~/i
```
Gitee:
```bash
curl -s -o ~/i https://gitee.com/CMSZ001/Ollama_for_Termux/raw/main/install.sh && bash ~/i
```
3. Follow the prompts in the script to decide whether to use a mirror and whether to proceed with the installation.
4. After the installation is complete,you can start Ollama by running the`ollama`command.

## Copyright Information
This script is written by`CMSZ001`and is open-sourced under the[MIT License](./LICENSE).For copyright information regarding Ollama,please refer to the[official Ollama repository](https://github.com/ollama/ollama).
