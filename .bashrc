
# Starship prompt
eval "$(starship init bash)"

# fnm: Node.js version manager
eval "$(fnm env --use-on-cd)"

# 输入几个字符后按 ↑/↓，按前缀搜索历史
bind '"\e[A": history-search-backward' 2>/dev/null
bind '"\e[B": history-search-forward' 2>/dev/null

# 历史记录：追加写入（多窗口不覆盖）、去重
shopt -s histappend
HISTCONTROL=ignoredups:erasedups

# Shopify Hydrogen alias to local projects
alias h2='$(npm prefix -s)/node_modules/.bin/shopify hydrogen'
