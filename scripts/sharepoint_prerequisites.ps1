Import-Module Servermanager

Install-WindowsFeature NET-HTTP-Activation,NET-Non-HTTP-Activ,NET-WCF-Pipe-Activation45,NET-WCF-HTTP-Activation45,Web-Server,Web-WebServer,Web-Common-Http,Web-Static-Content,Web-Default-Doc,Web-Dir-Browsing,Web-Http-Errors,Web-App-Dev,Web-Asp-Net,Web-Asp-Net45,Web-Net-Ext,Web-Net-Ext45,Web-ISAPI-Ext,Web-ISAPI-Filter,Web-Health,Web-Http-Logging,Web-Log-Libraries,Web-Request-Monitor,Web-Http-Tracing,Web-Security,Web-Basic-Auth,Web-Windows-Auth,Web-Filtering,Web-Performance,Web-Stat-Compression,Web-Dyn-Compression,Web-Mgmt-Tools,Web-Mgmt-Console,WAS,WAS-Process-Model,WAS-NET-Environment,WAS-Config-APIs,Windows-Identity-Foundation,Xps-Viewer -IncludeManagementTools -verbose -Source D:\sources\sxs

New-Item -Path C:\Sharepoint -ItemType Directory -Force
New-Item -Path C:\SPdisk -ItemType Directory -Force

$errorOutputFile = "C:\Temp\ErrorOutput.txt"
$standardOutputFile = "C:\Temp\StandardOutput.txt"

Write-Host "Copying SharePoint Server Image"

Copy-Item 'Z:\isos\officeserver.img' -Destination "C:/SPdisk"

New-Item "C:\Temp" -ItemType "Directory" -Force
Remove-Item $errorOutputFile -Force -ErrorAction SilentlyContinue
Remove-Item $standardOutputFile -Force -ErrorAction SilentlyContinue
$isoLocation = 'C:/SPdisk/officeserver.img'

Write-Host "Mounting SharePoint Server Image"
$drive = Mount-DiskImage -ImagePath $isoLocation

Write-Host "Getting Disk drive of the mounted image"
$disks = Get-WmiObject -Class Win32_logicaldisk -Filter "DriveType = '5'"

foreach ($disk in $disks){
    $driveLetter = $disk.DeviceID
}

if ($driveLetter)
{
    Write-Host "Starting prerequisites install of Sharepoint Server"
    Start-Process $driveLetter\PrerequisiteInstaller.exe -Wait -RedirectStandardOutput $standardOutputFile -RedirectStandardError $errorOutputFile
    #Z:/scripts/sharepoint_install.ps1
}

$standardOutput = Get-Content $standardOutputFile -Delimiter "\r\n"

Write-Host $standardOutput

$errorOutput = Get-Content $errorOutputFile -Delimiter "\r\n"

Write-Host $errorOutput


Dismount-DiskImage -InputObject $drive