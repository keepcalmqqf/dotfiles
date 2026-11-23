# Load .bashrc for interactive shells
[[ -f ~/.bashrc ]] && source ~/.bashrc

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export PATH=$PATH:$HOME/.maestro/bin

# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"

# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"
. "$HOME/.cargo/env"
alias lceda-pro="/Applications/嘉立创EDA\(专业版\).app/Contents/MacOS/LCEDA-Pro"
alias lceda-pro="/Applications/嘉立创EDA\(专业版\).app/Contents/MacOS/LCEDA-Pro"
