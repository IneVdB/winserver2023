Add-WindowsFeature -Name DNS -IncludeManagementTools

Add-DnsServerSecondaryZone -Name "caserver.WS2-2324-ine.hogent" -ZoneFile "caserver.WS2-2324-ine.hogent.dns" -MasterServers 192.168.23.12
Start-DnsServerZoneTransfer -Name "caserver.WS2-2324-ine.hogent"
Add-DnsServerResourceRecord -ComputerName "domaincontrolle" -ZoneName ".WS2-2324-ine.hogent" -NS -NameServer NewDnsServerNameHere
#Restart-Computer


