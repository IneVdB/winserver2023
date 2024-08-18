$errorOutputFile = "C:\Temp\ErrorOutput.txt"
$standardOutputFile = "C:\Temp\StandardOutput.txt"

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
    Start-Process $driveLetter\setup.exe -Wait -RedirectStandardOutput $standardOutputFile -RedirectStandardError $errorOutputFile
}

$standardOutput = Get-Content $standardOutputFile -Delimiter "\r\n"

Write-Host $standardOutput

$errorOutput = Get-Content $errorOutputFile -Delimiter "\r\n"

Write-Host $errorOutput

Dismount-DiskImage -InputObject $drive