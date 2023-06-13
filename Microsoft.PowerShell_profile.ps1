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
