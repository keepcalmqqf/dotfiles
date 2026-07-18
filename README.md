# dotfiles

我的终端配置：macOS 上是 zsh + Oh My Zsh + starship 提示符 + tmux，Windows 上是 Git Bash + PowerShell + starship，外加 bash 兜底配置。

## 包含内容

| 文件 | 平台 | 作用 |
| --- | --- | --- |
| `mac/.zshrc` | macOS | zsh 主配置：OMZ 插件（git/z/macos/colored-man-pages/extract）、starship、fnm、自动补全建议、语法高亮、别名 |
| `mac/.zprofile` | macOS | Homebrew 环境、JetBrains Toolbox、OrbStack 集成 |
| `.bashrc` / `.bash_profile` | 通用 | bash 配置，同样接入 starship、fnm（Windows 下给 Git Bash 用），含历史前缀搜索（↑/↓）与历史去重 |
| `mac/.tmux.conf` | macOS | tmux：真彩色、鼠标、Catppuccin Mocha 状态栏、`\|`/`-` 分屏 |
| `.config/starship.toml` | 通用 | starship 提示符：双行布局、Nerd Font 图标、git 状态配色 |
| `windows/Microsoft.PowerShell_profile.ps1` | Windows | PowerShell 5.1 配置：starship、fnm、PSReadLine 历史前缀搜索/补全、移除与 fnm 冲突的 `ni` 别名 |
| `windows/.minttyrc` | Windows | Git Bash 终端（mintty）：FiraCode Nerd Font、134x42 窗口 |
| `install.sh` | macOS | 新电脑一键恢复脚本 |
| `install.ps1` | Windows | 新电脑一键恢复脚本 |

## 新电脑恢复（macOS）

```bash
git clone <你的仓库地址> ~/dotfiles
cd ~/dotfiles
./install.sh
```

脚本会自动：安装 starship / tmux / fnm / bun / uv / zsh-autosuggestions / zsh-syntax-highlighting（经 Homebrew）、安装 Oh My Zsh（如缺失）、把上述配置软链接到 `$HOME`（已有文件自动备份为 `*.bak.<时间戳>`）。

手动收尾（脚本里有提示）：

1. 终端字体设为 **FiraCode Nerd Font**（`brew install --cask font-fira-code-nerd-font`）
2. `chsh -s /bin/zsh` 把默认 shell 切到 zsh

## 新电脑恢复（Windows）

```powershell
git clone <你的仓库地址> D:\coding\dotfiles
cd D:\coding\dotfiles
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

脚本会自动：安装 git / starship / fnm / bun / uv 与 FiraCode Nerd Font Mono（经 Scoop）、把共享配置（`.bashrc` / `.bash_profile` / `starship.toml`）和 `windows/` 下的配置链接到 `$HOME` 与 PowerShell `$PROFILE`（已有文件自动备份为 `*.bak.<时间戳>`）。

注意：

1. Windows 上创建符号链接需要管理员权限或开启「开发者模式」。不满足时脚本自动降级：shell 配置（`.bashrc` / `.bash_profile` / PowerShell profile）写成 stub 引导文件，直接 source 仓库里的文件——改仓库配置立即生效；`starship.toml` / `.minttyrc` 没有 include 机制只能复制，改动后需重跑一次 `install.ps1` 才会同步
2. 未纳入版本管理的机器配置：`~/.gitconfig`（含公司内网 git 地址，按需手动维护）

## 日常使用

配置文件通过软链接指向本仓库，直接编辑 `~/.zshrc` 等文件即修改仓库内容，改完提交即可：

```bash
cd ~/dotfiles
git add -A
git commit -m "update configs"
git push
```
