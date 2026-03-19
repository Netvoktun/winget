

### Set Culture(Region stillingar):
```bash
Set-Culture is-IS

```

### Sync Time(Date stillingar):
```bash
Invoke-Command -ScriptBlock { Start-Service w32time; w32tm /resync }
Invoke-Command -ScriptBlock { Start-Service w32time; w32tm /resync }

```
### Set the DNS servers for the Ethernet interface:  
```bash
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("8.8.8.8", "8.8.4.4")

```
### Set the DNS servers for the WiFi interface:  
```bash
Set-DnsClientServerAddress -InterfaceAlias "Wi-Fi" -ServerAddresses ("8.8.8.8", "8.8.4.4")
Set-DnsClientServerAddress -InterfaceAlias "WiFi" -ServerAddresses ("8.8.8.8", "8.8.4.4")

```

### Set the DNS servers for the WiFi interface:  
```bash
New-LocalUser -Name "Nemandi" -NoPassword -FullName "Nemandi" -Description "Standard notandi"
Add-LocalGroupMember -Group "Users" -Member "Nemandi"

#Lenovo bloatware:
winget uninstall "McAfee" --id McAfee.wps
winget uninstall "Lenovo Vantage Service"
winget uninstall "Lenovo Now"

Get-AppxPackage *LenovoCompanion* | Remove-AppxPackage
Get-AppxPackage *McAfee* | Remove-AppxPackage

```


### Remove bloatware packages:
```bash
winget uninstall "Dell SupportAssist Remediation"
winget uninstall "Dell SupportAssist"
winget uninstall "ARP\Machine\X64\{19A9EDD8-0C4D-4CF4-B0EA-D110407DF54B}"
winget uninstall "MSIX\Dell.SupportAssistforPCs_5.0.1.0_x64__18ctm2993j0dg"
winget uninstall "Dell SupportAssist OS Recovery Plugin for Dell Update"
winget uninstall "Dell Pair"

winget uninstall "Xbox"
winget uninstall "Game Bar"
winget uninstall "Xbox TCUI"
winget uninstall "Xbox Identity Provider"
winget uninstall "Game Speech Window"
winget uninstall "Solitaire & Casual Games"

winget uninstall "News"
winget uninstall "Microsoft Bing"
winget uninstall "MSN-veður"
winget uninstall "Microsoft Clipchamp"
winget uninstall "Microsoft Family"
winget uninstall "Dev Home (Preview)"
winget uninstall "Símatengill"

Get-AppxPackage Microsoft.GamingApp | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxGamingOverlay | Remove-AppxPackage
Get-AppxPackage Microsoft.Xbox.TCUI | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxIdentityProvider | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxSpeechToTextOverlay | Remove-AppxPackage
Get-AppxPackage Microsoft.MicrosoftSolitaireCollection | Remove-AppxPackage

Get-AppxPackage Microsoft.BingNews | Remove-AppxPackage
Get-AppxPackage Microsoft.BingSearch | Remove-AppxPackage
Get-AppxPackage Microsoft.BingWeather | Remove-AppxPackage
Get-AppxPackage Microsoft.ZuneMusic | Remove-AppxPackage
Get-AppxPackage Microsoft.WindowsFeedbackHub | Remove-AppxPackage
Get-AppxPackage Microsoft.GetHelp | Remove-AppxPackage
Get-AppxPackage MicrosoftCorporationII.MicrosoftFamily | Remove-AppxPackage
Get-AppxPackage Microsoft.YourPhone | Remove-AppxPackage
Get-AppxPackage Microsoft.Windows.DevHome | Remove-AppxPackage
Get-AppxPackage Microsoft.Clipchamp | Remove-AppxPackage

```


### Trigger Windows Update:
```bash
### Enable advanced Windows Update options:
$WUPath = "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings"
Set-ItemProperty -Path $WUPath -Name "AllowMUUpdateService" -Value 1 -Type DWord
Set-ItemProperty -Path $WUPath -Name "IsExpedited" -Value 1 -Type DWord
Set-ItemProperty -Path $WUPath -Name "AllowAutoWindowsUpdateDownloadOverMeteredNetwork" -Value 1 -Type DWord
Set-ItemProperty -Path $WUPath -Name "RestartNotificationsAllowed2" -Value 1 -Type DWord

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
Import-Module PSWindowsUpdate -Force -Verbose
Install-Module PSWindowsUpdate -Force -SkipPublisherCheck
Get-WindowsUpdate -MicrosoftUpdate -AcceptAll -Install -IgnoreReboot -RecurseCycle 3 -Verbose
### Set Balanced power plan (avoids fan noise from High Performance):
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e

### Install Icelandic language pack:
Install-Language is-IS
Set-WinUserLanguageList -LanguageList is-IS, en-US -Force
### Keep Windows display language as English:
Set-WinUILanguageOverride -Language en-US
Set-WinSystemLocale -SystemLocale is-IS
Set-Culture is-IS

### Update all MS Store apps:
Get-CimInstance -Namespace root\cimv2\mdm\dmmap -ClassName MDM_EnterpriseModernAppManagement_AppManagement01 | Invoke-CimMethod -MethodName UpdateScanMethod

```

### Run Dell Command Update
```bash
& "C:\Program Files\Dell\CommandUpdate\dcu-cli.exe" /scan
& "C:\Program Files\Dell\CommandUpdate\dcu-cli.exe" /applyUpdates -reboot=disable

```

### Essentials:  
```bash
winget install Microsoft.Office

```
eða

```bash
winget install Microsoft.OfficeDeploymentTool
Invoke-WebRequest "https://raw.githubusercontent.com/Netvoktun/winget/refs/heads/main/configuration-Office365-uninstall.xml" -OutFile (Join-Path $env:USERPROFILE "Downloads\configuration-Office365-uninstall.xml")
Invoke-WebRequest "https://raw.githubusercontent.com/Netvoktun/winget/refs/heads/main/configuration-Office365-x64.xml" -OutFile (Join-Path $env:USERPROFILE "Downloads\configuration-Office365-x64.xml")
& "C:\Program Files (x86)\OfficeDeploymentTool\setup.exe" /configure "$env:USERPROFILE\Downloads\configuration-Office365-uninstall.xml"
& "C:\Program Files (x86)\OfficeDeploymentTool\setup.exe" /configure "$env:USERPROFILE\Downloads\configuration-Office365-x64.xml"

```

```bash
winget install 7zip.7zip --accept-package-agreements --accept-source-agreements  
winget install Microsoft.Teams  
winget install VideoLAN.VLC  
winget install Google.Chrome  
winget install Adobe.Acrobat.Reader.64-bit

```
### set password
```bash
$password = ConvertTo-SecureString "Suri.0einn" -AsPlainText -Force
Set-LocalUser -Name $env:USERNAME -Password $password
```

### Optionals:  
```bash
winget install BraveSoftware.BraveBrowser
winget install Famatech.AdvancedIPScanner
winget install Jabra.Direct
winget install 3CX.SoftPhone
winget install Spotify.Spotify
winget install Audacity.Audacity

```

### Dell Computers:
```bash
winget install Dell.CommandUpdate.Universal

```


### Custom:  
#### Need to download the manifest because it only works locally...
https://raw.githubusercontent.com/Netvoktun/winget/main/manifests/d/dkVistunehf/dkVistunSetup/
  

### Backup/restore WiFi profiles from one computer to another:  
#### Export:  
cd c:\  
mkdir wifi-profiles
cd wifi-profiles
netsh wlan export profile key=clear folder="C:\wifi-profiles"

#### Import:  
Get-ChildItem -Path .\*.xml | ForEach-Object { netsh wlan add profile filename=$_ user=current }
  
  
# Disable "Learn about this picture" desktop icon but keep Spotlight
```bash
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{2cc5ca98-6485-489a-920e-b3e88a6ccce3}" /t REG_DWORD /d 1 /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters

```

```bash
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{2cc5ca98-6485-489a-920e-b3e88a6ccce3}" /t REG_DWORD /d 0 /f
```
