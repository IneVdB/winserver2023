function createWinServerVM {    
    param (
        $hdSizeMb,
        $memSizeMb,
        $vramMb,
        $nofCPUs,
        $vmName
    )

    #
    # Add Virtual Box bin-path to PATH environment variable if necessary:
    #
    if ( (get-command VBoxManage.exe -errorAction silentlyContinue) -eq $null) {
        $env:path = "C:\Program Files\Oracle\VirtualBox;$env:path"
    }

    # remove existing settings
    Remove-Item -LiteralPath "$env:USERPROFILE\VirtualBox VMs\$vmName" -Force -Recurse -ErrorAction SilentlyContinue

    $isoFile = "isos\en_windows_server_2019_x64_dvd_4cb967d8.iso"

    if (-not (test-path $isoFile)) {
        "$isoFile does not exist"
        return
    }

    $osType = 'Windows10_64'

    $image = 1
    if ( ($vmName) -eq "DomainController" -or ($vmName) -eq "SPserver")
    {
        $image = 2
    }   

    $vmPath = "VirtualBox VMs\$vmName"
    New-Item -Path "VirtualBox VMs\" -Name $vmName -ItemType Directory -Force

    $userName = 'winserver2'
    $fullUserName = 'Windows Server 2'
    $password = 'WinServer2023'

    $sharedFolder = (get-item "scripts/" ).parent.FullName

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

    VBoxManage modifyvm $vmName --nic1 natnetwork --nat-network1 natnet1

    $postInstall="powershell.exe -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command E:/vboxadditions/VBoxWindowsAdditions.exe /S ; shutdown /r"

    # set cpus
    VBoxManage modifyvm $vmName --cpus $nofCPUs

    VBoxManage unattended install $vmName      `
        --iso=$isoFile                           `
        --user=$userName                         `
        --password=$password                     `
        --full-user-name=$fullUserName           `
        --install-additions                      `
        --time-zone=CET                          `
        --locale=be_EN                           `
        --image-index=$image                     `
        --key=V82N947P28FM8VV4HJG43DDVJ          `
        --post-install-command=$postInstall

    VBoxManage setextradata $vmName GUI/RestrictedRuntimeMenus ALL

    # start VM
    VBoxManage startvm $vmName

    # set video mode hint
    VBoxManage controlvm $vmName setvideomodehint 1200 900  32

    # wait for finished installation
    #VBoxManage guestproperty wait $vmName installation_finished
}
