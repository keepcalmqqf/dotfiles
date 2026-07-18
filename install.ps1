# Dotfiles bootstrap for Windows: install dependencies and symlink configs.
# Usage: powershell -ExecutionPolicy Bypass -File .\install.ps1
$ErrorActionPreference = 'Stop'

$DotfilesDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host '==> Checking dependencies...'

# Scoop
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
  Write-Host 'Scoop not found. Install it first: https://scoop.sh'
  exit 1
}

# CLI tools
$Packages = @('starship', 'fnm', 'bun', 'uv')
foreach ($pkg in $Packages) {
  if (Get-Command $pkg -ErrorAction SilentlyContinue) {
    Write-Host "  [ok] $pkg"
  } else {
    Write-Host "  [install] $pkg"
    scoop install $pkg
  }
}

# Symlink a config file, backing up any existing one.
# Falls back to copying when symlinks are unavailable
# (creating symlinks on Windows needs admin rights or Developer Mode).
function Link-File {
  param([string]$Source, [string]$Target)

  $parent = Split-Path -Parent $Target
  if (-not (Test-Path $parent)) {
    New-Item -ItemType Directory -Path $parent -Force | Out-Null
  }

  if (Test-Path $Target) {
    $item = Get-Item $Target -Force
    if ($item.LinkType) {
      Remove-Item $Target -Force  # replace old symlink
    } else {
      $backup = "$Target.bak.$(Get-Date -Format yyyyMMddHHmmss)"
      Write-Host "  [backup] $Target -> $backup"
      Move-Item $Target $backup
    }
  }

  try {
    New-Item -ItemType SymbolicLink -Path $Target -Value $Source -ErrorAction Stop | Out-Null
    Write-Host "  [link] $Target -> $Source"
  } catch {
    Copy-Item $Source $Target
    Write-Host "  [copy] $Target <- $Source (symlink 不可用，已改为复制)"
  }
}

Write-Host '==> Linking configs...'

# Shared with macOS (Git Bash on Windows reads these too)
Link-File "$DotfilesDir\.bashrc"                "$HOME\.bashrc"
Link-File "$DotfilesDir\.bash_profile"          "$HOME\.bash_profile"
Link-File "$DotfilesDir\.config\starship.toml"  "$HOME\.config\starship.toml"

# Windows-specific
Link-File "$DotfilesDir\windows\.minttyrc"                        "$HOME\.minttyrc"
Link-File "$DotfilesDir\windows\Microsoft.PowerShell_profile.ps1" "$PROFILE"

Write-Host @'

Done! 收尾一件事（无法脚本化）:
  1. 安装字体 "FiraCode Nerd Font"（mintty 和 starship 图标都依赖它）:
       scoop bucket add nerd-fonts
       scoop install FiraCode-NF-Mono
然后新开一个终端窗口即可。
'@
