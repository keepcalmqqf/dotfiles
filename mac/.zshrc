# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme disabled — starship renders the prompt instead.
ZSH_THEME=""

# Plugins (keep this list short; each one slows shell startup).
plugins=(git z macos colored-man-pages extract)

source $ZSH/oh-my-zsh.sh

# Starship prompt (replaces OMZ theme)
eval "$(starship init zsh)"

# Fish-like autosuggestions (accept with → or End)
source "${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Common aliases
alias ll='ls -lah'
alias la='ls -A'

# Extra PATH entries
export PATH="$HOME/.kimi-code/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/fvm/default/bin:$PATH"

# Dotfiles auto-sync: commit & push config changes at most once every 10 min.
# (launchd can't touch ~/Desktop due to macOS privacy, so sync on shell prompt instead)
# Stamp lives in $TMPDIR: files on ~/Desktop carry com.apple.provenance and can
# refuse writes (EPERM) from any app other than the one that last wrote them.
_dotfiles_repo="${${${(%):-%x}:A}:h:h}"
_dotfiles_auto_sync() {
  local stamp="${TMPDIR:-/tmp}/dotfiles_last_sync" now=$EPOCHSECONDS
  local last=$(cat "$stamp" 2>/dev/null) || last=0
  if (( now - ${last:-0} > 600 )); then
    echo $now >| "$stamp" 2>/dev/null || return
    ("$_dotfiles_repo/sync.sh" &>/dev/null &)
  fi
}
zmodload zsh/datetime
autoload -Uz add-zsh-hook
add-zsh-hook precmd _dotfiles_auto_sync

# SDKMAN (Java/Scala/Kotlin version manager) — keep near the end
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Syntax highlighting (must be sourced LAST in .zshrc)
source "${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"

# Android SDK
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"
# ===== Armino SMP SDK (TimeWeather / BK7258) =====
export ARMINO_HOME="$HOME/armino"
export SDK_DIR="$ARMINO_HOME/bk_avdk_smp"
export ARMINO_TOOLS_PATH="$SDK_DIR/tools"
export ARMINO_PATH="$SDK_DIR"
# 本地交叉工具链（Homebrew arm-none-eabi-gcc 16.2.0；官方为 gcc-arm-none-eabi-10.3-2021.10）
export COMPILER_TOOLCHAIN_PATH="/opt/homebrew/bin"
export TOOLCHAIN_DIR="$COMPILER_TOOLCHAIN_PATH"
export PATH="$ARMINO_HOME/bin:$PATH"
