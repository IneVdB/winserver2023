function setupNetwork {

    param (
        $IP
    )

    $MaskBits = 24
    $Gateway = "192.168.23.1"
    $Dns = "192.168.23.12"
    $IPType = "IPv4"

    $adapter = Get-NetAdapter | ? {$_.Status -eq "up"}

    If (($adapter | Get-NetIPConfiguration).IPv4Address.IPAddress) {
        $adapter | Remove-NetIPAddress -AddressFamily $IPType -Confirm:$false
    }
    If (($adapter | Get-NetIPConfiguration).Ipv4DefaultGateway) {
        $adapter | Remove-NetRoute -AddressFamily $IPType -Confirm:$false
    }

    if ($IP -eq "DHCP") {
        Add-Computer WS2-2324-ine.hogent -Credential WS2-2324-ine\winserver2
        $adapter | Set-NetIPInterface -DHCPEnabled
        $adapter | Set-DnsClientServerAddress -ResetServerAddresses
    } else {
        $adapter | New-NetIPAddress `
        -AddressFamily $IPType `
        -IPAddress $IP `
        -PrefixLength $MaskBits `
        -DefaultGateway $Gateway

        $adapter | Set-DnsClientServerAddress -ServerAddresses $DNS
            
        if ($IP -ne "192.168.23.12") {
            Add-Computer WS2-2324-ine.hogent -Credential WS2-2324-ine\winserver2
        }

    }


    Restart-Computer

}