Add-WindowsFeature -Name DNS -IncludeManagementTools

#Add-DnsServerPrimaryZone -Name "WS2-2324-ine.hogent" -ReplicationScope "Forest"
Add-DnsServerPrimaryZOne -NetworkID 192.168.23.0/24 -ReplicationScope "Forest"

Add-DnsServerForwarder -IPAddress 8.8.8.8 -PassThru
Add-DnsServerForwarder -IPAddress 8.8.4.4 -PassThru

Add-DnsServerResourceRecordA -Name CAserver -ZoneName WS2-2324-ine.hogent -IPv4Address 192.168.23.22
Add-DnsServerResourceRecordA -Name SPserver -ZoneName WS2-2324-ine.hogent -IPv4Address 192.168.23.32
Add-DnsServerResourceRecordA -Name DBserver -ZoneName WS2-2324-ine.hogent -IPv4Address 192.168.23.42

Add-DnsServerResourceRecordPtr -Name 22 -ZoneName "23.168.192.in-addr.arpa" -PtrDomainName "CAserver.WS2-2324-ine.hogent"
Add-DnsServerResourceRecordPtr -Name 32 -ZoneName "23.168.192.in-addr.arpa" -PtrDomainName "SPserver.WS2-2324-ine.hogent"
Add-DnsServerResourceRecordPtr -Name 42 -ZoneName "23.168.192.in-addr.arpa" -PtrDomainName "DBserver.WS2-2324-ine.hogent"

Restart-Computer


