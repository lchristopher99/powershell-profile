Set-Alias -Name nv -Value nvim -Option AllScope -Force

Set-Alias -Name unzip -Value Expand-Archive
Set-Alias -Name zip -Value Compress-Archive

# delete bin and obj 
function RemoveBinObj() { Get-ChildItem .\ -include bin,obj -Recurse | ForEach-Object ($_) { remove-item $_.fullname -Force -Recurse } }
Set-Alias -Name cln -Value RemoveBinObj -Option AllScope -Force

# switch to admin shell at location
function ElevatePwsh() { Start-Process pwsh -verb runas -args "/NoExit /c cd $($pwd)" }
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

function run { dotnet run $args }
Set-Alias -Name dr -Value run
function build { dotnet build $args }
Set-Alias -Name db -Value build 

function procloc { 
    if ((Test-Path -Path $args) -eq $false) {
        Write-Warning "File or directory does not exist."
    } else {
        $LockingProcess = CMD /C "openfiles /query /fo table | find /I ""$FileOrFolderPath"""
            Write-Host $LockingProcess
    } 
}
Set-Alias -Name pl -Value procloc
