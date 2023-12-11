funtion setupNetwork {

    param (
        $computerName,
        $IPv4Address
    )

    #$computerName = "dc1"

    #$IPv4Address = "192.168.23.22"
    $IPv4Prefix = "24"
    $IPv4GW = "192.168.23.10"
    $IPv4DNS = "8.8.8.8"

    $ipIF = (Get-NetAdapter).ifIndex

    Set-NetIPv6Protocol -RandomizeIdentifiers Disabled
    Set-NetIPv6Protocol -UseTemporaryAddresses Disabled

    Set-Net6to4Configuration -State Disabled
    Set-NetIsatapConfiguration -State Disabled
    Set-NetTeredoConfiguration -Type Disabled

    New-NetIPAddress -InterfaceIndex $ipIF -IPAddress $IPv4Address -PrefixLength $IPv4Prefix -DefaultGateway $IPv4GW
    Set-DNSClientServerAddress –interfaceIndex $ipIF –ServerAddresses $IPv4DNS

    Rename-Computer -NewName $computerName -force
    Restart-Computer

}