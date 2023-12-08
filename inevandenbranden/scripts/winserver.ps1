#
# Add Virtual Box bin-path to PATH environment variable if necessary:
#
if ( (get-command VBoxManage.exe -errorAction silentlyContinue) -eq $null) {
    $env:path = "C:\Program Files\Oracle\VirtualBox;$env:path"
}

$vmName = 'DomainController'
$isoFile = "isos\en_windows_server_2019_x64_dvd_4cb967d8.iso"

if (-not (test-path $isoFile)) {
    "$isoFile does not exist"
    return
}

$osType = 'Windows10_64'

$vmPath = "VirtualBox VMs\$vmName"

$userName = 'winserver2'
$fullUserName = 'Windows Server 2'
$password = 'WS2023'

$hdSizeMb = 32 * 1024  # 32 GB
$memSizeMb = 4 * 1024
$vramMb = 128
$nofCPUs = 4
$sharedFolder = "$home\VirtualBox\sharedFolder"


# remove previous VM
VBoxManage controlvm    $vmName poweroff
VBoxManage unregistervm $vmName --delete

rmdir -recurse $vmPath
# rmdir -recurse $sharedFolder

# create VM
VBoxManage createvm --name $vmName --ostype $osType --register

# create hard drive
VBoxManage createmedium --filename $vmPath\hard-drive.vdi --size $hdSizeMb

# create SATA
VBoxManage storagectl    $vmName --name       'SATA Controller' --add sata --controller IntelAHCI
VBoxManage storageattach $vmName --storagectl 'SATA Controller' --port 0 --device 0 --type hdd --medium $vmPath/hard-drive.vdi

# create ide
VBoxManage storagectl    $vmName --name       'IDE Controller' --add ide
VBoxManage storageattach $vmName --storagectl 'IDE Controller' --port 0 --device 0 --type dvddrive --medium $isoFile

# enable apic
VBoxManage modifyvm $vmName --ioapic on

# boot device order
VBoxManage modifyvm $vmName --boot1 dvd --boot2 disk --boot3 none --boot4 none

# allocate memory
VBoxManage modifyvm $vmName --memory $memSizeMb --vram $vramMb

# shared folder
# VBoxManage sharedfolder add $vmName --name shr --hostpath $sharedFolder --automount

# clipboard mode
VBoxManage modifyvm  $vmName --clipboard-mode bidirectional

# vbox svga
VBoxManage modifyvm  $vmName --graphicscontroller vboxsvga

# set cpus
VBoxManage modifyvm $vmName --cpus $nofCPUs

# remove menus
VBoxManage setextradata $vmName GUI/RestrictedRuntimeMenus ALL 

# start VM
VBoxManage startvm $vmName

# set video mode hint
VBoxManage controlvm $vmName setvideomodehint 1200 900  32

# wait for finished installation
VBoxManage guestproperty wait $vmName installation_finished