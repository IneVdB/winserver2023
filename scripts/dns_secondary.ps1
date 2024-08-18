Add-WindowsFeature -Name DNS -IncludeManagementTools

Add-DnsServerSecondaryZone -Name "WS2-2324-ine.hogent" -ZoneFile "WS2-2324-ine.hogent.dns" -MasterServers 192.168.23.12


