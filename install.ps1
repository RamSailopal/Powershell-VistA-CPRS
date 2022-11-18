#
#   Powershell script to install VistA CPRS client on Windows Machine
#
#   Run with .\install.ps1 - This sets up a connection with default IP address 127.0.0.1 and default port 9001
#
#   To specify a port, run e.g. .\install.ps1 -ip 192.168.240.21 -p 5001
#
#
param ([String] $ip="127.0.0.1", [String] $port="9001")
Set-Location '~\My Documents'
if (Get-ChildItem "C:\Program Files (x86)" | Where-Object { $_.Name -like "VistA" }) { 
    Write-Host -ForegroundColor Red "VistA installation directory already exists at C:\Program Files (x86)\VistA. Please remove manually before continuing"
    exit 
}
if (Get-ChildItem "~/Desktop" | Where-Object { $_.Name -like "CPRS.lnk" }) { 
    Write-Host -ForegroundColor Red "CPRS shortcut is already created on your desktop. Please remove manually before continuing"
    exit 
}
if ($ip -notmatch "^([0-9]{1,3}\.){3}([0-9]{1,3})$") {
    Write-Host -ForegroundColor Red "IP address is in the wrong format"
    exit 
}
if ([int]$port -le 1024) {
    Write-Host -ForegroundColor Red "Port entered is in a reserved range"
    exit 
}
Write-Host "Downloading and Extracting CPRS installation file"
Set-Location '~\My Documents'
Invoke-WebRequest -URI https://altushost-swe.dl.sourceforge.net/project/worldvista-ehr/WorldVistA_EHR_3.0/CPRS-Files-WVEHR3.0Ver2-16_BasedOn1.0.30.16.zip -OutFile CPRS.zip
Expand-Archive '~\My Documents\CPRS.zip' -DestinationPath 'C:\Program Files (x86)' -Force
$SourceFilePath = "C:\Program Files (x86)\VistA\CPRS\CPRS-WVEHR3.0Ver2-16_BasedOn1.0.30.16 S=$ip P=$port CCOW=disable showrpcs"
Get-Item '~/Desktop' | ForEach-Object { $ShortcutPath = $_.FullName }
$ShortcutPath = "$ShortcutPath\CPRS.lnk"
Write-Host "$ShortcutPath"
$WScriptObj = New-Object -ComObject ("WScript.Shell")
$shortcut = $WscriptObj.CreateShortcut($ShortcutPath)
$shortcut.TargetPath = $SourceFilePath
$shortcut.Save()
