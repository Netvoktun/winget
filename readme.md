### Essentials:  
winget install 7zip.7zip --accept-package-agreements --accept-source-agreements  
winget install Microsoft.Office  
winget install Microsoft.Teams  
winget install VideoLAN.VLC  
winget install Google.Chrome  
winget install Adobe.Acrobat.Reader.64-bit  

### Optionals:  
winget install BraveSoftware.BraveBrowser  
winget install Famatech.AdvancedIPScanner  
winget install Jabra.Direct  
winget install Spotify.Spotify  
winget install Audacity.Audacity  

### Dell Tölvur:
winget install Dell.CommandUpdate.Universal
#### Dell PowerManager
winget install 9PD11RQ8QC9K

### Custom:  
#### Need to download the manifest because it only works locally...
https://raw.githubusercontent.com/Netvoktun/winget/main/manifests/d/dkVistunehf/dkVistunSetup/

### Set Culture(Region stillingar):
Set-Culture is-IS
  
### Set the DNS servers for the Ethernet interface:  
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("8.8.8.8", "8.8.4.4")
  
### Set the DNS servers for the WiFi interface:  
Set-DnsClientServerAddress -InterfaceAlias "Wi-Fi" -ServerAddresses ("8.8.8.8", "8.8.4.4")
  
### Set the default mail app to Outlook, overwriting any existing value:  
New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\mailto\UserChoice" -Name "Progid" -Value "Outlook.Application" -Force

