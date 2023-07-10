function RemoveBinObj() {
    Get-ChildItem .\ -include bin,obj -Recurse | ForEach-Object ($_) { remove-item $_.fullname -Force -Recurse }
}

function ElevatePwsh() {
    Start-Process powershell -verb runas -args "/NoExit /c cd $($pwd)"
}

Set-Alias -Name nv -Value nvim -Option AllScope -Force
Set-Alias -Name unzip -Value Expand-Archive
Set-Alias -Name zip -Value Compress-Archive
Set-Alias -Name clean -Value RemoveBinObj
Set-Alias -Name sudo -Value ElevatePwsh
Set-Alias -Name cd -Value pushd -Option AllScope -Force
Set-Alias -Name bd -Value popd -Option AllScope

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
