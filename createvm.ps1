function create_vm ($vmName) {

    if ( (get-command VBoxManage.exe -errorAction silentlyContinue) -eq $null) {
        $env:path = "C:\Program Files\Oracle\VirtualBox;$env:path"
    }

    $vms_home = "\VirtualBox VMs"
    $iso_root = "\isos"

    # all parameters
    $group_id = "/Win2Servers" # must start with '/'
    $cpu_count = 2
    $memory_size = 4096
    $vram_size = 128
    $network_mode = "nat"
    $disk_size = 32 * 1024 # 32 GB
    $disk_medium_path = "${vms_home}/${group_id}/${vm_name}/${vm_name}.vdi"
    $disk_sc_name = "${vm_name}.disk_sc" # disk storage controller
    $dvd_sc_name = "${vm_name}.dvd_sc" # dvd storage controller
    $disk_sb_type = "sata" # system bus type
    $dvd_sb_type = "ide" # system bus type
    $disk_sc_type = "IntelAhci"
    $dvd_sc_type = "PIIX4"
    $sc_port_count = 2
    $disk_sc_attach_port = 0
    $dvd_sc_attach_port = 1
    $disk_sc_attach_device = 0
    $dvd_sc_attach_device = 0
    $disk_drive_type = "hdd"
    $dvd_drive_type = "dvddrive"

    $vrdeport = 10001

    $iso_uri = ""
    switch ($vmName)
    {
        "SQLserver" {
            $iso_uri="$iso_root\en_sql_server_2019_standard_x64_dvd_814b57aa.iso"
            $ostype="Other"
        }
        "windows_server_2019" {
            $iso_uri="$iso_root\en_windows_server_2019_x64_dvd_4cb967d8.iso"
        }
    }

    echo "Removing previous VM"
    VBoxManage controlvm $vmName poweroff
    VBoxManage unregistervm $vmName --delete

    rmdir -recurse $vmPath

    echo "To create $vm_name as '$ostype' with '$iso_uri'"
    
    VBoxManage createvm --name "${vm_name}" --ostype "$ostype" --register --basefolder "$vms_home"
    VBoxManage modifyvm "$vm_name" --cpus $cpu_count --memory $memory_size --vram $vram_size --nic1 $network_mode
    VBoxManage createmedium disk --filename "$disk_medium_path" --size $disk_size
    
    # hardware disk
    VBoxManage storagectl "$vm_name" --name "$disk_sc_name" --add $disk_sb_type --controller "$disk_sc_type" --portcount $sc_port_count --hostiocache off --bootable on
    VBoxManage storageattach "$vm_name" --storagectl "$disk_sc_name" --port $disk_sc_attach_port --device $disk_sc_attach_device --type "$disk_drive_type" --medium "$disk_medium_path"
    
    # dvd
    VBoxManage storagectl "$vm_name" --name "$dvd_sc_name" --add "$dvd_sb_type" --controller "$dvd_sc_type" --portcount $sc_port_count --bootable on --hostiocache off
    VBoxManage storageattach "$vm_name" --storagectl "$dvd_sc_name" --port $dvd_sc_attach_port --device $dvd_sc_attach_device --type "$dvd_drive_type" --medium "$iso_uri"
    
    # boot from dvd before disk, after installation, we can change this
    VBoxManage modifyvm "$vm_name" --boot1 dvd --boot2 disk --boot3 none --boot4 none

    VBoxManage startvm "$vm_name"
}