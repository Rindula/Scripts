if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
function Show-Menu
{
     param (
           [string]$Title = 'Reverse Powershell'
     )
     cls
     Write-Host "================ $Title ================"
     
     Write-Host "1: Setup on Remote."
     Write-Host "2: Prepare on Client."
     Write-Host "3: Connect."
     Write-Host "4: Shutdown Remote."
     Write-Host "Q: Quit."
}
Start-Service WinRM
do
{
     Show-Menu
     $input = Read-Host "Please make a selection"
     switch ($input)
     {
           '1' {
                cls
                
            #    $down = New-Object System.Net.WebClient;
            #    $file = 'initReverse.ps1';
            #    $url  = 'https://scripts.rindula.de/powershell/' + $file;
            #    $down.DownloadFile($url,$file);
            #    $exec = New-Object -com shell.application
            #    $exec.shellexecute($file);
                
                Enable-PSRemoting -SkipNetworkProfileCheck
                Set-Item wsman:localhost\client\trustedhosts -Value *
                #Set-NetFirewallRule –Name "WINRM-HTTP-In-TCP-PUBLIC" –RemoteAddress Any

                New-PSSession
                
           } '2' {
                cls
                Set-Item wsman:localhost\client\trustedhosts -Value * -Force
           } '3' {
                cls
                $pname = Read-Host "Please enter the PC-Name"
                $uname = Read-Host "Please enter the User-Name"
                Enter-PSSession -ComputerName $pname -Credential $pname\$uname
           } '4' {
                cls
                $pname = Read-Host "Please enter the PC-Name"
                $uname = Read-Host "Please enter the User-Name"
                Stop-Computer -ComputerName $pname -Credential $pname\$uname -Impersonation anonymous -Authentication PacketIntegrity
           } 'q' {
               cls
               'Exiting...'
                return
           }
     }
     'Erfolg!'
     Start-Sleep -s 5
}
until ($input -eq 'q')