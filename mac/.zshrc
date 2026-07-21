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

# Syntax highlighting (must be sourced LAST in .zshrc)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# >>> Hermes Studio CLI shim >>>
case ":$PATH:" in
  *":$HOME/bin:"*) ;;
  *) export PATH="$HOME/bin:$PATH" ;;
esac
# <<< Hermes Studio CLI shim <<<
