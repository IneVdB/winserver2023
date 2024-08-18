#
# Add Virtual Box bin-path to PATH environment variable if necessary:
#
if ( (get-command VBoxManage.exe -errorAction silentlyContinue) -eq $null) {
    $env:path = "C:\Program Files\Oracle\VirtualBox;$env:path"
}

$vmName = 'WindowsClient'
$isoFile = "isos\SW_DVD9_Win_Pro_10_20H2.10_64BIT_English_Pro_Ent_EDU_N_MLF_X22-76585.ISO"

if (-not (test-path $isoFile)) {
    "$isoFile does not exist"
    return
}

# remove existing settings
Remove-Item -LiteralPath "$env:USERPROFILE\VirtualBox VMs\$vmName" -Force -Recurse -ErrorAction SilentlyContinue

New-Item -Path "VirtualBox VMs\" -Name $vmName -ItemType Directory -Force

$osType = 'Windows10_64'

$vmPath = "VirtualBox VMs\$vmName"

$userName = 'winserver2'
$fullUserName = 'Windows Server 2'
$password = 'WinServer2023'

$hdSizeMb = 50 * 1024
$memSizeMb = 2 * 1024
$vramMb = 128
$nofCPUs = 2
$sharedFolder = (get-item "scripts/" ).parent.FullName


#detect
VBoxManage.exe unattended detect --iso=$isoFile

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
VBoxManage sharedfolder add $vmName --name shr --hostpath $sharedFolder --automount

# clipboard mode
VBoxManage modifyvm  $vmName --clipboard-mode bidirectional

# vbox svga
VBoxManage modifyvm  $vmName --graphicscontroller vboxsvga

# set cpus
VBoxManage modifyvm $vmName --cpus $nofCPUs

VBoxManage modifyvm WindowsClient --nic1 natnetwork --nat-network1 natnet1

$postInstall="powershell.exe -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command E:/vboxadditions/VBoxWindowsAdditions.exe /S ; shutdown /r"


# install
VBoxManage unattended install $vmName      `
  --iso=$isoFile                           `
  --user=$userName                         `
  --password=$password                     `
  --full-user-name=$fullUserName           `
  --install-additions                      `
  --time-zone=CET                          `
  --locale=be_EN                           `
  --key=DR2NF-6G3PF-D3BVR-KKRJY-PR473      `
  --post-install-command=$postInstall      `
  --image-index=1

# remove menus
VBoxManage setextradata $vmName GUI/RestrictedRuntimeMenus ALL 

# start VM
VBoxManage startvm $vmName

# set video mode hint
VBoxManage controlvm $vmName setvideomodehint 1200 900  32

# wait for finished installation
# VBoxManage guestproperty wait $vmName installation_finished