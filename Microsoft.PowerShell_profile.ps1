function prompt() {
  # see https://qiita.com/skkzsh/items/5e03bb7792629927acfa
  if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
	Write-Host -backgroundcolor Red -nonewline "ADMIN"
	Write-Host -nonewline " "
  }
  Write-Host "[" -nonewline
  Write-Host "$(Get-Location)" -foregroundcolor Cyan -nonewline
  Write-Host "]" -nonewline
  Write-Host " ${env:USERNAME}@${env:COMPUTERNAME}" -foregroundcolor Magenta
  "> "
}

function Add-Path($path) {
  if("" -eq $path) {
    return
  }
  if($env:Path.Contains($path + ";")) {
    return
  }
  Set-Item env:Path "${path};${env:Path}"
}

# utility
Add-Path $home\tools
Add-Path "C:\Program Files\MIFES11"
# Remove-Item Alias:curl  # cURL is installed via chocolatey
Add-Path "C:\Program Files\Docker\Docker\resources\bin"

# Claude (relies on Git-bash)
Add-Path "$HOME\.local\bin"
Set-Item env:CLAUDE_CODE_GIT_BASH_PATH "C:\Users\yattom\scoop\shims\git-bash.exe"

# to use diff.ext from diffutils
Remove-Item -Force Alias:\diff

# Git for Windows
# Windows標準のOpenSSHを使って、ssh-agentもサービスとして実行するのに統一
# Set-Item env:GIT_SSH C:\ProgramData\chocolatey\bin\PLINK.EXE
Set-Item env:GIT_SSH C:\WINDOWS\System32\OpenSSH\ssh.exe

# Android SDK
Add-Path "$HOME\AppData\Local\Android\Sdk\platform-tools"

# Flutter
Set-Item env:FLUTTER_PATH "${env:HOMEDRIVE}${env:HOMEPATH}\tools\flutter"
Add-Path $env:FLUTTER_PATH\bin

# Local Claude on GONDOLIN (Desktop Win11)
function lclaude() {
  Write-Host "Connecting to Remote KoboldCpp (gondolin)..." -ForegroundColor Green
  Set-Item env:ANTHROPIC_AUTH_TOKEN "ollama"
  Set-Item env:ANTHROPIC_API_KEY ""
  Set-Item env:ANTHROPIC_BASE_URL "http://gondolin:5001/v1"
  claude --model qwen3.6
}

# Antigravity CLI
Add-Path "$HOME\C:\Users\tsuto\AppData\Local\agy\bin\"

Set-Alias which Which-Command
function Which-Command($cmd) {
  $obj = Get-Command $cmd
  switch($obj.CommandType) {
    "Alias" { "Alias -> " + $obj.ResolvedCommand.Name}
    "Cmdlet" { "Cmdlet (" + $obj.Source + ")" }
    "Function" { $obj.Definition }
    default { $obj.Source }
  }
}

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# GitHub CLI Aliases
Set-Alias ghce GitHubCLI-Copilot-Explain
function GitHubCLI-Copilot-Explain {
  param(
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$args
  )
  $queryString = $args -join " "
  gh copilot explain "$queryString"
}

Set-Alias ghcs GitHubCLI-Copilot-Suggest
function GitHubCLI-Copilot-Suggest {
  param(
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$args
  )
  $queryString = $args -join " "
  gh copilot suggest "$queryString"
}


# disable bells with backspace
Set-PSReadlineOption -BellStyle None

# short cut aliases
function river {
  # $HOME/etc/ にキーがある環境が残っているかも
  C:\WINDOWS\System32\OpenSSH\ssh.exe -i $HOME\.ssh\id_ed25519.yattom river
}
