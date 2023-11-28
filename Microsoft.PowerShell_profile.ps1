oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/zash.omp.json" | Invoke-Expression

Import-Module Terminal-Icons

# check if tools are available, prompt to install
function fetch {
    $scoop_apps      = @("btop", "gcc", "grep", "neofetch", "ripgrep", "processhacker", "lsd")
    $pwsh_modules    = @("PSReadLine", "Terminal-Icons")
    $winget_packages = @("Neovim.Neovim", "Git.Git", "Microsoft.DotNet.SDK.7", "Microsoft.PowerShell", 
                         "Microsoft.WindowsTerminal", "JanDeDobbeleer.OhMyPosh", "Brave.Brave", "Insecure.Nmap", 
                         "rcmaehl.MSEdgeRedirect", "Microsoft.PowerToys", "WiresharkFoundation.Wireshark")

    # check for scoop install 
    Write-Host "[*] Checking scoop apps ..."
    $avail=$true
    try { scoop *>$null }
    catch { 
        Write-Host "[!] 'scoop' unavailable, install now? (y/n) " -NoNewLine
        if ([Console]::ReadKey() -eq 'y') {
            Write-Host "[*] Installing 'scoop' ..."
            Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
            Invoke-RestMethod get.scoop.sh | Invoke-Expression 
            scoop bucket add main
            scoop bucket add extras
            # reload path
            $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        } else { Write-Host; $avail=$false }
    }

    # check for scoop apps
    if ($avail) {
        foreach ($a in $scoop_apps) {
            if (!(scoop list | Where-object {$_.Name -like $a})) {
                Write-Host "[!] '$a' unavailable, install now? (y/n) " -NoNewLine
                if ([Console]::ReadKey() -eq 'y') {
                    Write-Host "[*] Installing '$a' ..."
                    scoop install $a
                } else { Write-Host }
            } else { Write-Host "[+] '$a' installed!" }
        }
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

    # check for winget packages
    Write-Host "`n[*] Checking winget packages ..."
    $reload=$false
    foreach ($p in $winget_packages) {
        if ([String]::IsNullOrEmpty((winget show $p | grep $p))) {
            Write-Host "[!] '$p' unavailable, install now? (y/n) " -NoNewLine
            if ([Console]::ReadKey() -eq 'y') {
                Write-Host "[*] Installing '$p' ..."
                winget install $p
                $reload=$true
            } else { Write-Host }
        } else { Write-Host "[+] '$p' installed!" }
    }
 
    if ($reload) { 
        Write-Host "`n[*] Reloading path ... "
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
    }
 
    Write-Host "[+] Done"
}

function trl { 
    $path=$args
    if ([String]::IsNullOrEmpty(($path))) { $path = "." }
    Write-Host "`nDirectory: $(Resolve-Path $path)`n"
    lsd -X --tree --blocks permission,date,size,git,name $args
    Write-Host
}

function tr { 
    $path=$args
    if ([String]::IsNullOrEmpty(($path))) { $path = "." }
    Write-Host "`nDirectory: $(Resolve-Path $path)`n"
    lsd -X --tree $args 
    Write-Host
}

# delete bin, obj, .vs, .vscode, Properties, and deploy directories
function cln { Get-ChildItem .\ -include bin,obj,.vs,.vscode,Properties,deploy -Recurse | ForEach-Object ($_) { remove-item $_.fullname -Force -Recurse } }

# switch to admin shell at location, pass args
function sudo { Start-Process pwsh -verb runas -args "/NoExit /c cd '$($pwd)';$args" }

# git
function gsm    { git submodule $args }
function gs     { git status $args }
function gd     { git diff $args }
function ga     { git add $args }
function gaa    { git add . }
function commit { git commit -m $args } 
function push   { git push $args } 
Set-Alias -Name gc -Value commit -Option AllScope -Force
Set-Alias -Name gp -Value push -Option AllScope -Force

# dotnet
function dr { dotnet run $args }
function db { dotnet build $args }
function dp { dotnet pack $args }
function dnp { dotnet nuget push $args }

Set-Alias -Name nv -Value nvim -Option AllScope -Force

Set-Alias -Name unzip -Value Expand-Archive
Set-Alias -Name zip -Value Compress-Archive

# change dir/back dir
Set-Alias -Name cd -Value pushd -Option AllScope -Force
Set-Alias -Name bd -Value popd -Option AllScope
