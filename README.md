# dotfiles

我的终端配置：zsh + Oh My Zsh + starship 提示符 + tmux，外加 bash 兜底配置。

## 包含内容

| 文件 | 作用 |
| --- | --- |
| `.zshrc` | zsh 主配置：OMZ 插件（git/z/macos/colored-man-pages/extract）、starship、fnm、自动补全建议、语法高亮、别名 |
| `.zprofile` | Homebrew 环境、JetBrains Toolbox、OrbStack 集成 |
| `.bashrc` / `.bash_profile` | bash 配置，同样接入 starship、fnm |
| `.tmux.conf` | tmux：真彩色、鼠标、Catppuccin Mocha 状态栏、`\|`/`-` 分屏 |
| `.config/starship.toml` | starship 提示符：双行布局、Nerd Font 图标、git 状态配色 |
| `install.sh` | 新电脑一键恢复脚本 |

## 新电脑恢复

```bash
git clone <你的仓库地址> ~/dotfiles
cd ~/dotfiles
./install.sh
```

脚本会自动：安装 starship / tmux / fnm / bun / uv / zsh-autosuggestions / zsh-syntax-highlighting（经 Homebrew）、安装 Oh My Zsh（如缺失）、把上述配置软链接到 `$HOME`（已有文件自动备份为 `*.bak.<时间戳>`）。

手动收尾（脚本里有提示）：

1. 终端字体设为 **FiraCode Nerd Font**（`brew install --cask font-fira-code-nerd-font`）
2. `chsh -s /bin/zsh` 把默认 shell 切到 zsh

## 日常使用

配置文件通过软链接指向本仓库，直接编辑 `~/.zshrc` 等文件即修改仓库内容，改完提交即可：

```bash
cd ~/dotfiles
git add -A
git commit -m "update configs"
git push
```
