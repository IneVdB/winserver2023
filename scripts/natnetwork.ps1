# remove if it already exists
VBoxManage natnetwork remove --netname natnet1

VBoxManage natnetwork add --netname natnet1 --network "192.168.23.0/24" --enable

VBoxManage modifyvm DBserver --nic1 natnetwork --nat-network1 natnet1
VBoxManage modifyvm CAserver --nic1 natnetwork --nat-network1 natnet1
VBoxManage modifyvm DomainController --nic1 natnetwork --nat-network1 natnet1
VBoxManage modifyvm SPserver --nic1 natnetwork --nat-network1 natnet1
VBoxManage modifyvm WindowsClient --nic1 natnetwork --nat-network1 natnet1