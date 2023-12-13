function setupNetwork {

    param (
        $IP
    )

    $MaskBits = 24
    $Gateway = "192.168.23.1"
    $Dns = "8.8.8.8"
    $IPType = "IPv4"

    $adapter = Get-NetAdapter | ? {$_.Status -eq "up"}

    If (($adapter | Get-NetIPConfiguration).IPv4Address.IPAddress) {
        $adapter | Remove-NetIPAddress -AddressFamily $IPType -Confirm:$false
    }
    If (($adapter | Get-NetIPConfiguration).Ipv4DefaultGateway) {
        $adapter | Remove-NetRoute -AddressFamily $IPType -Confirm:$false
    }

    $adapter | New-NetIPAddress `
        -AddressFamily $IPType `
        -IPAddress $IP `
        -PrefixLength $MaskBits `
        -DefaultGateway $Gateway

    $adapter | Set-DnsClientServerAddress -ServerAddresses $DNS

    Restart-Computer

}