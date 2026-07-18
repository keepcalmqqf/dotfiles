# Starship prompt
Invoke-Expression (&starship init powershell)

# fnm: Node.js version manager (auto-switch version on cd)
fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression

# ni 是 PowerShell 内置 New-Item 别名，与 fnm 的 ni 命令冲突
Remove-Item Alias:ni -Force -ErrorAction Ignore

# PSReadLine: 历史前缀搜索 + 补全（仅控制台交互会话）
if ($Host.Name -eq 'ConsoleHost') {
  # 输入几个字符后按 ↑/↓，按前缀搜索历史；空行时等同普通上下翻历史
  Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
  Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
  Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
  Set-PSReadLineOption -HistorySearchCursorMovesToEnd
  # 历史预测建议需要 PSReadLine 2.1+（Update-Module PSReadLine 可升级）
  $psrlVersion = (Get-Module PSReadLine).Version
  if ($psrlVersion -ge [version]'2.1') { Set-PSReadLineOption -PredictionSource History }
  if ($psrlVersion -ge [version]'2.2') { Set-PSReadLineOption -PredictionViewStyle ListView }
}
