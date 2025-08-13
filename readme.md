### Essentials:  
```bash
winget install Microsoft.Office

```
```bash
winget install 7zip.7zip --accept-package-agreements --accept-source-agreements  
winget install Microsoft.Teams  
winget install VideoLAN.VLC  
winget install Google.Chrome  
winget install Adobe.Acrobat.Reader.64-bit

```

### Optionals:  
```bash
winget install BraveSoftware.BraveBrowser
winget install Famatech.AdvancedIPScanner
winget install Jabra.Direct
winget install Spotify.Spotify
winget install Audacity.Audacity

```

### Dell Tölvur:
winget install Dell.CommandUpdate.Universal
#### Dell PowerManager
winget install 9PD11RQ8QC9K

### Custom:  
#### Need to download the manifest because it only works locally...
https://raw.githubusercontent.com/Netvoktun/winget/main/manifests/d/dkVistunehf/dkVistunSetup/
  
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
