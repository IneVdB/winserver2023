New-Item -Path C:\SQL2019 -ItemType Directory -Force
New-Item -Path C:\SQLdisk -ItemType Directory -Force

$errorOutputFile = "C:\Temp\ErrorOutput.txt"
$standardOutputFile = "C:\Temp\StandardOutput.txt"

Copy-Item 'Z:\isos\en_sql_server_2019_standard_x64_dvd_814b57aa.iso' -Destination "C:/SQLdisk"
Copy-Item "Z:\scripts/ConfigurationFile.ini"  -Destination "C:/SQLdisk"

$pathToConfig = "C:/SQLdisk/ConfigurationFile.ini"
New-Item "C:\Temp" -ItemType "Directory" -Force
Remove-Item $errorOutputFile -Force -ErrorAction SilentlyContinue
Remove-Item $standardOutputFile -Force -ErrorAction SilentlyContinue
$isoLocation = 'C:\SQLdisk\en_sql_server_2019_standard_x64_dvd_814b57aa.iso'
$passwd="WinServer2023"
$user="WS2-2324-ine/winserver"


Write-Host "Mounting SQL Server Image"
$drive = Mount-DiskImage -ImagePath $isoLocation

Write-Host "Getting Disk drive of the mounted image"
$disks = Get-WmiObject -Class Win32_logicaldisk -Filter "DriveType = '5'"

foreach ($disk in $disks){
    $driveLetter = $disk.DeviceID
}

if ($driveLetter)
{
    Write-Host "Starting the install of SQL Server"
    Start-Process $driveLetter\Setup.exe /ConfigurationFile=$pathToConfig -Wait -RedirectStandardOutput $standardOutputFile -RedirectStandardError $errorOutputFile
}

$standardOutput = Get-Content $standardOutputFile -Delimiter "\r\n"

Write-Host $standardOutput

$errorOutput = Get-Content $errorOutputFile -Delimiter "\r\n"

Write-Host $errorOutput


Dismount-DiskImage -InputObject $drive


#Install-Module -Name SqlServer -RequiredVersion 22.2.0 -ErrorAction SilentlyContinue