#!/usr/bin/env bash
# Dotfiles bootstrap: install dependencies and symlink configs.
# Usage: ./install.sh
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Checking dependencies..."

# Homebrew (macOS)
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Install it first: https://brew.sh"
  exit 1
fi

# CLI tools
PKGS=(starship tmux zsh-autosuggestions zsh-syntax-highlighting)
for pkg in "${PKGS[@]}"; do
  if brew list --formula "$pkg" >/dev/null 2>&1; then
    echo "  [ok] $pkg"
  else
    echo "  [install] $pkg"
    brew install "$pkg"
  fi
done

# Oh My Zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "  [ok] oh-my-zsh"
else
  echo "  [install] oh-my-zsh"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Symlink a config file, backing up any existing one
link_file() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ]; then
    rm "$dst"  # replace old symlink
  elif [ -e "$dst" ]; then
    local backup="${dst}.bak.$(date +%Y%m%d%H%M%S)"
    echo "  [backup] $dst -> $backup"
    mv "$dst" "$backup"
  fi
  ln -s "$src" "$dst"
  echo "  [link] $dst -> $src"
}

echo "==> Linking configs..."
link_file "$DOTFILES_DIR/.zshrc"               "$HOME/.zshrc"
link_file "$DOTFILES_DIR/.zprofile"            "$HOME/.zprofile"
link_file "$DOTFILES_DIR/.bashrc"              "$HOME/.bashrc"
link_file "$DOTFILES_DIR/.bash_profile"        "$HOME/.bash_profile"
link_file "$DOTFILES_DIR/.tmux.conf"           "$HOME/.tmux.conf"
link_file "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml"

cat <<'EOF'

Done! 收尾两件事（无法脚本化）:
  1. 终端字体: 终端 App -> 设置 -> 描述文件 -> 文本 -> 字体, 选 "FiraCode Nerd Font"
     (新电脑需先安装: brew install --cask font-fira-code-nerd-font)
  2. 默认 shell 切到 zsh: chsh -s /bin/zsh
然后新开一个终端标签页即可。
EOF
