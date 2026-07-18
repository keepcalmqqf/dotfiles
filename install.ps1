# Dotfiles bootstrap for Windows: install dependencies and symlink configs.
# Usage: powershell -ExecutionPolicy Bypass -File .\install.ps1
$ErrorActionPreference = 'Stop'

$DotfilesDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SymlinkFailed = $false

Write-Host '==> Checking dependencies...'

# Scoop
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
  Write-Host 'Scoop not found. Install it first: https://scoop.sh'
  exit 1
}

# CLI tools (git 放最前，scoop 添加 bucket 等操作依赖它)
$Packages = @('git', 'starship', 'fnm', 'bun', 'uv')
foreach ($pkg in $Packages) {
  if (Get-Command $pkg -ErrorAction SilentlyContinue) {
    Write-Host "  [ok] $pkg"
  } else {
    Write-Host "  [install] $pkg"
    scoop install $pkg
  }
}

# FiraCode Nerd Font Mono (mintty and starship icons depend on it)
$fontInstalled = (Get-ChildItem "$env:WINDIR\Fonts" -Filter 'FiraCodeNerdFontMono*' -ErrorAction SilentlyContinue) -or
                 (Get-ChildItem "$env:LOCALAPPDATA\Microsoft\Windows\Fonts" -Filter 'FiraCodeNerdFontMono*' -ErrorAction SilentlyContinue)
if ($fontInstalled) {
  Write-Host '  [ok] FiraCode Nerd Font Mono'
} else {
  Write-Host '  [install] FiraCode Nerd Font Mono'
  if (-not ((scoop bucket list 6>$null) -match 'nerd-fonts')) { scoop bucket add nerd-fonts }
  scoop install FiraCode-NF-Mono
}

# Symlink a config file, backing up any existing one.
# Fallback order when symlinks are unavailable (needs admin rights or
# Developer Mode): loader stub for shell configs (so repo edits take effect
# immediately), plain copy for files without an include mechanism.
function Link-File {
  param([string]$Source, [string]$Target, [string]$StubKind = '')

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
    return
  } catch {
    $script:SymlinkFailed = $true
  }

  if ($StubKind -eq 'bash') {
    $posix = $Source -replace '\\', '/'
    if ($posix -match '^([A-Za-z]):(.*)$') { $posix = '/' + $Matches[1].ToLower() + $Matches[2] }
    Set-Content -Path $Target -Value "source `"$posix`"" -Encoding ascii
    Write-Host "  [stub] $Target -> source $posix"
  } elseif ($StubKind -eq 'ps1') {
    Set-Content -Path $Target -Value ". `"$Source`"" -Encoding ascii
    Write-Host "  [stub] $Target -> . $Source"
  } else {
    Copy-Item $Source $Target
    Write-Host "  [copy] $Target <- $Source (symlink 不可用，已改为复制)"
  }
}

Write-Host '==> Linking configs...'

# Shared with macOS (Git Bash on Windows reads these too)
Link-File "$DotfilesDir\.bashrc"                "$HOME\.bashrc"                -StubKind bash
Link-File "$DotfilesDir\.bash_profile"          "$HOME\.bash_profile"          -StubKind bash
Link-File "$DotfilesDir\.config\starship.toml"  "$HOME\.config\starship.toml"

# Windows-specific
Link-File "$DotfilesDir\windows\.minttyrc"                        "$HOME\.minttyrc"
Link-File "$DotfilesDir\windows\Microsoft.PowerShell_profile.ps1" "$PROFILE"     -StubKind ps1

if ($SymlinkFailed) {
  Write-Host ''
  Write-Host '提示: 符号链接不可用（需要管理员权限或开启「开发者模式」）。'
  Write-Host '  - shell 配置（.bashrc / .bash_profile / PowerShell profile）已写入 stub 引导文件，'
  Write-Host '    直接 source 仓库里的文件，改仓库立即生效；'
  Write-Host '  - starship.toml / .minttyrc 没有 include 机制，只能复制，改动后需重跑 install.ps1；'
  Write-Host '  - 开启开发者模式（设置里搜索「开发者选项」）后重跑本脚本可换成符号链接。'
}

Write-Host @'

Done! 依赖、字体、配置均已就绪，新开一个终端窗口即可。
'@
