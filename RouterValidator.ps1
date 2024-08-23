Write-Host '--------------------------------------------' -ForegroundColor Yellow
Write-Host '    Wi-Fi router Validation script v1.00    ' -ForegroundColor Yellow
Write-Host '--------------------------------------------' -ForegroundColor Yellow
Write-Host '--------------------------------------------' -ForegroundColor DarkGray
Write-Host '    Info: 23.08.2024, David Demcak          ' -ForegroundColor DarkGray
Write-Host '    Changelog:                              ' -ForegroundColor DarkGray
Write-Host '         v1.00 - Frist version              ' -ForegroundColor DarkGray
Write-Host '--------------------------------------------' -ForegroundColor DarkGray

# Checks Wi-Fi / LTE router OS and Configuration version
# Parameters: IP address, expected OS version, manifest name and manifest version

function Get-MomdemCgi
{
    Param ([string] $ipAddress)   

        
    $uicSelfCheckDigit = 0
    
    return $uicSelfCheckDigit
}


# Check if a 1st paramter was given.
if ($args.Count -ne 4)
{
    Write-Host 'Please provide device''s IP Address, expected OS version, manifest name and manifest version!' -ForegroundColor Red
    exit
}

# Regex for IP Address validation
$ipv4 = '^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'


# IP ADDRESS is given as 1st parameter
$ipAddress = $args[0]

if ($ipAddress -notmatch $ipV4)
{
    Write-Host 'IP Address (IPv4) is invalid!' -ForegroundColor Red
    exit
}


# HTTP request to get router data
$Uri = "http://$($ipAddress)/modemcgi"

# Expected OS version given as 2nd parameter
$expectedOsVersion = $args[1]

# Expected Manifest name version given as 3rd parameter
$expectedManifestName = $args[2]

# Expected Manifest name version given as 4th parameter
$expectedManifestVersion = $args[3]

# Try to download data from the device
try {
    #$response = Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -SkipCertificateCheck -Uri $Uri - -TimeoutSec 5
    $response = Invoke-RestMethod -Uri $Uri -TimeoutSec 5
}
catch {
    
    Write-Host 'Error while downloading data from the device!' -ForegroundColor Red

    if ($_.ErrorDetails.Message) {
        Write-Host $_.ErrorDetails.Message  -ForegroundColor Red
    } else {
        Write-Host $_  -ForegroundColor Red
    }
    
    exit
}

$info = $response.GetElementsByTagName("info")

# Get Device Information
$deviceName = $info.hw
$deviceSerial = $info.sn

Write-Host 'Devie name = ' $deviceName '(S/N:'$deviceSerial')' -ForegroundColor Green

# Get OS version
$osVersion = $info.ver

Write-Host 'OS = ' $osVersion -ForegroundColor Green

# Get manifest information
$manifestName = $info.manifest.name
$manifestVersion = $info.manifest.version

Write-Host 'Manifest name = ' $manifestName -ForegroundColor Green
Write-Host 'Manifest version = ' $manifestVersion -ForegroundColor Green

#"3.70r1" "WS-CD-D" "2.04"

Write-Host '--------------------------------------------------------------------' -ForegroundColor DarkCyan
Write-Host '|           |  OS version  |  Manifest name   |  Manifest version  |' -ForegroundColor DarkCyan
Write-Host '--------------------------------------------------------------------' -ForegroundColor DarkCyan
Write-Host '| Expected: |   '$expectedOsVersion'    |     '$expectedManifestName'     |       '$expectedManifestVersion'         |  ' -ForegroundColor DarkCyan
Write-Host '--------------------------------------------------------------------' -ForegroundColor DarkCyan
Write-Host '| Current:  |   '$osVersion'    |     '$manifestName'     |       '$manifestVersion'         |  ' -ForegroundColor Green
Write-Host '--------------------------------------------------------------------' -ForegroundColor DarkCyan
Write-Host -NoNewline '| Results:  '   -ForegroundColor DarkCyan
if ($expectedOsVersion -eq $osVersion) { Write-Host -NoNewline '|      OK      ' -ForegroundColor Green }
else { Write-Host -NoNewline '|     ERR      ' -ForegroundColor Red }
if ($expectedManifestName -eq $manifestName) { Write-Host -NoNewline '|       OK         ' -ForegroundColor Green }
else { Write-Host -NoNewline '|       ERR        ' -ForegroundColor Red }
if ($expectedManifestVersion -eq $manifestVersion) { Write-Host '|        OK          |' -ForegroundColor Green }
else { Write-Host '|         ERR          |' -ForegroundColor Red }
Write-Host '--------------------------------------------------------------------' -ForegroundColor DarkCyan





