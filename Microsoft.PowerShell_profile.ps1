# check if tools are available, prompt to install
function fetch_tools {
    $scoop_apps      = @("btop", "gcc", "grep", "neofetch", "ripgrep", "processhacker")
    $winget_packages = @("Microsoft.PowerToys", "WiresharkFoundation.Wireshark", "Neovim.Neovim", "Git.Git")
    $pwsh_modules    = @("PSReadLine", "Terminal-Icons")

    # check for scoop install 
    Write-Host "[*] Checking scoop apps ..."
    try { scoop *>$null }
    catch { 
        Write-Host "[!] 'scoop' unavailable, install now? (y/n) " -NoNewLine
        if ([Console]::ReadKey() -eq 'y') {
            Write-Host "[*] Installing 'scoop' ..."
            Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
            irm get.scoop.sh | iex
            scoop bucket add main
            scoop bucket add extras
        } else { Write-Host }
    }

    # check for scoop apps
    foreach ($a in $scoop_apps) {
        if (!(scoop info $a | Where-object {$_.Name -like $a})) {
            Write-Host "[!] '$a' unavailable, install now? (y/n) " -NoNewLine
            if ([Console]::ReadKey() -eq 'y') {
                Write-Host "[*] Installing '$a' ..."
                scoop install $a
            } else { Write-Host }
        } else { Write-Host "[+] '$a' installed!" }
    }

    # check for winget packages
    Write-Host "`n[*] Checking winget packages ..."
    foreach ($p in $winget_packages) {
        if ([String]::IsNullOrEmpty((winget show $p | grep $p))) {
            Write-Host "[!] '$p' unavailable, install now? (y/n) " -NoNewLine
            if ([Console]::ReadKey() -eq 'y') {
                Write-Host "[*] Installing '$p' ..."
                winget install $p
            } else { Write-Host }
        } else { Write-Host "[+] '$p' installed!" }
    }
 
    # check for powershell modules
    Write-Host "`n[*] Checking powershell modules ..."
    foreach ($m in $pwsh_modules) {
        if (!(get-module -ListAvailable | Where-object {$_.Name -like $m})) {
            Write-Host "[!] '$m' unavailable, install now? (y/n) " -NoNewLine
            if ([Console]::ReadKey() -eq 'y') {
                Write-Host "[*] Installing '$m' ..."
                Install-Module $m
                Import-Module $m
            } else { Write-Host }
        } else { Write-Host "[+] '$m' installed!" }
    }
}

Import-Module Terminal-Icons

Set-Alias -Name fetch -Value fetch_tools

Set-Alias -Name nv -Value nvim -Option AllScope -Force

Set-Alias -Name unzip -Value Expand-Archive
Set-Alias -Name zip -Value Compress-Archive

# delete bin, obj, .vs, .vscode, Properties, and deploy directories
function RemoveBinObj() { Get-ChildItem .\ -include bin,obj,.vs,.vscode,Properties,deploy -Recurse | ForEach-Object ($_) { remove-item $_.fullname -Force -Recurse } }
Set-Alias -Name cln -Value RemoveBinObj -Option AllScope -Force

# switch to admin shell at location, pass args
function ElevatePwsh() { Start-Process pwsh -verb runas -args "/NoExit /c cd $($pwd);$args" }
Set-Alias -Name sudo -Value ElevatePwsh

# change dir/back dir
Set-Alias -Name cd -Value pushd -Option AllScope -Force
Set-Alias -Name bd -Value popd -Option AllScope

# git
function status { git status $args }
Set-Alias -Name gs -Value status
function gdiff { git diff $args }
Set-Alias -Name gd -Value gdiff
function add { git add $args }
Set-Alias -Name ga -Value add
function addall { git add . }
Set-Alias -Name gaa -Value addall
function commit { git commit -m $args }
Set-Alias -Name gc -Value commit -Option AllScope -Force 
function push { git push $args }
Set-Alias -Name gp -Value push -Option AllScope -Force

# dotnet
function run { dotnet run $args }
Set-Alias -Name dr -Value run
function build { dotnet build $args }
Set-Alias -Name db -Value build 
