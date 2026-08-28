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
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# fnm: Node.js version manager (auto-switch version on cd)
eval "$(fnm env --use-on-cd)"

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
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# >>> Hermes Studio CLI shim >>>
case ":$PATH:" in
  *":$HOME/bin:"*) ;;
  *) export PATH="$HOME/bin:$PATH" ;;
esac
# <<< Hermes Studio CLI shim <<<


# >>> grok installer >>>
export PATH="$HOME/.grok/bin:$PATH"
fpath=(~/.grok/completions/zsh $fpath)
autoload -Uz compinit && compinit -C
# <<< grok installer <<<
