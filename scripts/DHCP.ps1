Install-WindowsFeature DHCP -IncludeManagementTools
netsh dhcp add securitygroups
Restart-Service dhcpserver
Add-DhcpServerInDC

Add-DhcpServerv4Scope -name “ClientScope” -StartRange 192.168.23.51 -EndRange 192.168.23.100 -SubnetMask 255.255.255.0 -State Active
Add-DhcpServerv4ExclusionRange -ScopeID 192.168.23.0 -StartRange 192.168.23.1 -EndRange 192.168.23.50
Set-DhcpServerv4OptionValue -OptionID 3 -Value 192.168.23.1 -ScopeID 192.168.23.0
Set-DhcpServerv4OptionValue -DnsDomain WS2-2324-ine.hogent -DnsServer 192.168.23.12

