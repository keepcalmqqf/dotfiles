# Starship prompt
Invoke-Expression (&starship init powershell)

# fnm: Node.js version manager (auto-switch version on cd)
fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression

# ni 是 PowerShell 内置 New-Item 别名，与 fnm 的 ni 命令冲突
Remove-Item Alias:ni -Force -ErrorAction Ignore
