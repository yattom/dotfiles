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

# python
Add-Path $home\tools\Python3.9.2
Add-Path $home\tools\python3.9.2\Scripts
Set-Item env:PYTHONPATH "${env:HOMEDRIVE}${env:HOMEPATH}\work"

# Git for Windows
Set-Item env:GIT_SSH C:\ProgramData\chocolatey\bin\PLINK.EXE

# Android SDK
Add-Path "C:\Users\tsuto\AppData\Local\Android\Sdk\platform-tools"

# Flutter
Set-Item env:FLUTTER_PATH "${env:HOMEDRIVE}${env:HOMEPATH}\tools\flutter"
Add-Path $env:FLUTTER_PATH\bin

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
	C:\ProgramData\chocolatey\bin\PUTTY.EXE -load River
}
