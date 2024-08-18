# remove if it already exists
VBoxManage natnetwork remove --netname natnet1

VBoxManage natnetwork add --netname natnet1 --network "192.168.23.0/24" --dhcp off --enable 
