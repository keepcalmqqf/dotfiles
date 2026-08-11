# dotfiles

我的终端配置：macOS 上是 zsh + Oh My Zsh + starship 提示符 + tmux，Windows 上是 Git Bash + PowerShell + starship，外加 bash 兜底配置。

## 包含内容

| 文件 | 平台 | 作用 |
| --- | --- | --- |
| `mac/.zshrc` | macOS | zsh 主配置：OMZ 插件（git/z/macos/colored-man-pages/extract）、starship、fnm、自动补全建议、语法高亮、别名 |
| `mac/.zprofile` | macOS | Homebrew 环境、JetBrains Toolbox 集成 |
| `.bashrc` / `.bash_profile` | 通用 | bash 配置，同样接入 starship、fnm（Windows 下给 Git Bash 用），含历史前缀搜索（↑/↓）与历史去重 |
| `mac/.tmux.conf` | macOS | tmux：真彩色、鼠标、Catppuccin Mocha 状态栏（按下前缀键时高亮）、`\|`/`-` 分屏、hjkl 切换/调整窗格、vi 复制模式直出 pbcopy、Shift+←/→ 切窗口 |
| `.config/starship.toml` | 通用 | starship 提示符：双行布局、Nerd Font 图标、git 状态配色 |
| `windows/Microsoft.PowerShell_profile.ps1` | Windows | PowerShell 5.1 配置：starship、fnm、PSReadLine 历史前缀搜索/补全、移除与 fnm 冲突的 `ni` 别名 |
| `windows/.minttyrc` | Windows | Git Bash 终端（mintty）：FiraCode Nerd Font、134x42 窗口 |
| `install.sh` | macOS | 新电脑一键恢复脚本 |
| `install.ps1` | Windows | 新电脑一键恢复脚本 |
| `mac/Brewfile` | macOS | Homebrew 软件清单（formula / cask / npm / uv），`sync.sh` 每次运行时用 `brew bundle dump` 自动刷新 |

## 新电脑恢复（macOS）

```bash
git clone <你的仓库地址> ~/dotfiles
cd ~/dotfiles
./install.sh
```

脚本会自动：按 `mac/Brewfile` 经 `brew bundle` 安装全部 Homebrew 软件（formula / cask / npm / uv 全局包）、单独安装 FiraCode Nerd Font 字体、安装 Oh My Zsh（如缺失）、把上述配置软链接到 `$HOME`（已有文件自动备份为 `*.bak.<时间戳>`）。

手动收尾（脚本里有提示）：

1. 终端字体设为 **FiraCode Nerd Font**（字体已由脚本安装，只需在终端设置里选中）
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

配置文件通过软链接指向本仓库，直接编辑 `~/.zshrc` 等文件即修改仓库内容。本机已开启**自动同步**：`.zshrc` 里的 `precmd` 钩子每 10 分钟检查一次，发现改动就自动 `git commit` + `push`（由 `sync.sh` 执行，新 shell 会话生效），无需手动提交。Homebrew 软件也一并覆盖：`sync.sh` 每次运行会先执行 `brew bundle dump` 刷新 `mac/Brewfile`，本机新装/卸载的软件会被自动记录并提交。

也可以随时手动运行 `./sync.sh` 或走传统流程：

```bash
cd ~/dotfiles
git add -A
git commit -m "update configs"
git push
```

> 说明：不用 launchd/cron 定时器是因为 macOS 隐私保护会阻止后台进程读写 `~/Desktop`；shell 钩子跑在终端里，天然有权限。若仓库移出 Desktop，也可改用 `sync.sh` + launchd。
