param (
    [Parameter(Mandatory = $true)]
    [string] $ConfigUrl
)

# --- 1. Download config from GitHub ---

Write-Host "Downloading config from GitHub..." -ForegroundColor Cyan

try {
    $configXml = [xml](Invoke-WebRequest -Uri $ConfigUrl -UseBasicParsing).Content
} catch {
    Write-Error "Failed to download config: $_"
    exit 1
}

# --- 2. Unpin apps ---

$unpinApps = $configXml.TaskbarConfig.Unpin.App
if ($unpinApps) {
    Write-Host "Unpinning apps..." -ForegroundColor Cyan
    $shellNs = (New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}')
    foreach ($app in $unpinApps) {
        $appName = $app.name
        $item = $shellNs.Items() | Where-Object { $_.Name -eq $appName }
        if ($item) {
            $verb = $item.Verbs() | Where-Object { $_.Name -replace '&','' -match 'Unpin from taskbar' }
            if ($verb) {
                $verb.DoIt()
                Write-Host "  Unpinned: $appName" -ForegroundColor Gray
            } else {
                Write-Warning "  '$appName' found but no unpin verb available"
            }
        } else {
            Write-Warning "  '$appName' not found on taskbar - skipping"
        }
    }
}

# --- 3. Build .lnk shortcuts for Win32 apps ---

$pinApps = $configXml.TaskbarConfig.Pin.App
if (-not $pinApps) {
    Write-Error "No App entries found in Pin section."
    exit 1
}

$startMenuPrograms = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs"
$wsh = New-Object -ComObject WScript.Shell

$win32Lnks = @()
$uwpAumids  = @()

foreach ($app in $pinApps) {
    $type = $app.type
    $name = $app.name

    if ($type -eq "win32") {
        $exePath = $app.exe
        if (-not (Test-Path -LiteralPath $exePath)) {
            Write-Warning "Skipping Win32 '$name' - exe not found: $exePath"
            continue
        }
        $lnkPath = "$startMenuPrograms\$name.lnk"
        if (-not (Test-Path $lnkPath)) {
            $shortcut                  = $wsh.CreateShortcut($lnkPath)
            $shortcut.TargetPath       = $exePath
            $shortcut.WorkingDirectory = Split-Path $exePath -Parent
            $shortcut.IconLocation     = $exePath
            $shortcut.Save()
            Write-Host "  Created shortcut: $lnkPath" -ForegroundColor Gray
        } else {
            Write-Host "  Shortcut exists: $lnkPath" -ForegroundColor Gray
        }
        $win32Lnks += $lnkPath

    } elseif ($type -eq "uwp") {
        $aumid = $app.aumid
        Write-Host "  UWP queued: $name ($aumid)" -ForegroundColor Gray
        $uwpAumids += $aumid

    } else {
        Write-Warning "Unknown type '$type' for '$name' - skipping"
    }
}

if ($win32Lnks.Count -eq 0 -and $uwpAumids.Count -eq 0) {
    Write-Error "No valid apps to pin."
    exit 1
}

# --- 4. Build LayoutModification.xml using XmlWriter ---

$layoutPath = "$env:LOCALAPPDATA\Microsoft\Windows\Shell\LayoutModification.xml"

$xmlSettings          = New-Object System.Xml.XmlWriterSettings
$xmlSettings.Indent   = $true
$xmlSettings.Encoding = [System.Text.Encoding]::UTF8

$writer = [System.Xml.XmlWriter]::Create($layoutPath, $xmlSettings)

$nsMod         = "http://schemas.microsoft.com/Start/2014/LayoutModification"
$nsFullDefault = "http://schemas.microsoft.com/Start/2014/FullDefaultLayout"
$nsStart       = "http://schemas.microsoft.com/Start/2014/StartLayout"
$nsTaskbar     = "http://schemas.microsoft.com/Start/2014/TaskbarLayout"

$writer.WriteStartDocument()
$writer.WriteStartElement("LayoutModificationTemplate", $nsMod)
$writer.WriteAttributeString("xmlns", "defaultlayout", $null, $nsFullDefault)
$writer.WriteAttributeString("xmlns", "start",         $null, $nsStart)
$writer.WriteAttributeString("xmlns", "taskbar",       $null, $nsTaskbar)
$writer.WriteAttributeString("Version", "1")

$writer.WriteStartElement("CustomTaskbarLayoutCollection", $nsMod)
$writer.WriteAttributeString("PinListPlacement", "Append")

$writer.WriteStartElement("TaskbarLayout", $nsFullDefault)
$writer.WriteStartElement("TaskbarPinList", $nsTaskbar)

foreach ($lnk in $win32Lnks) {
    $writer.WriteStartElement("DesktopApp", $nsTaskbar)
    $writer.WriteAttributeString("DesktopApplicationLinkPath", $lnk)
    $writer.WriteEndElement()
}

foreach ($aumid in $uwpAumids) {
    $writer.WriteStartElement("UWA", $nsTaskbar)
    $writer.WriteAttributeString("AppUserModelID", $aumid)
    $writer.WriteEndElement()
}

$writer.WriteEndElement()
$writer.WriteEndElement()
$writer.WriteEndElement()
$writer.WriteEndElement()
$writer.WriteEndDocument()
$writer.Flush()
$writer.Close()

Write-Host "Layout XML written to: $layoutPath" -ForegroundColor Cyan

# --- 5. Clear cache and restart Explorer ---

$cacheDir = "$env:LOCALAPPDATA\Microsoft\Windows\Shell\DefaultLayouts"
Remove-Item $cacheDir -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Restarting Explorer..." -ForegroundColor Yellow
Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 6

# --- 6. Remove layout XML so user can modify taskbar afterward ---

Remove-Item $layoutPath -Force -ErrorAction SilentlyContinue
Write-Host "Done." -ForegroundColor Green
