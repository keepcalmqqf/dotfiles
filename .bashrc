
# Starship prompt
eval "$(starship init bash)"

# fnm: Node.js version manager
eval "$(fnm env --use-on-cd)"

# Shopify Hydrogen alias to local projects
alias h2='$(npm prefix -s)/node_modules/.bin/shopify hydrogen'
