New-Item -Path C:\Sharepoint -ItemType Directory
$mountResult = Mount-DiskImage -ImagePath 'Z:\isos\officeserver.img' -PassThru
$volumeInfo = $mountResult | Get-Volume
$driveInfo = Get-PSDrive -Name $volumeInfo.DriveLetter
Copy-Item -Path ( Join-Path -Path $driveInfo.Root -ChildPath '*' ) -Destination C:\Sharepoint\ -Recurse
Dismount-DiskImage -ImagePath 'Z:\isos\officeserver.img'