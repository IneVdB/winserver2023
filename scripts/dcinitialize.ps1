# Define the Computer Name
$computerName = "dc1"

# Define the IPv4 Addressing
$IPv4Address = "192.168.23.22"
$IPv4Prefix = "24"
$IPv4GW = "192.168.23.10"
$IPv4DNS = "8.8.8.8"

# Get the Network Adapter's Prefix
$ipIF = (Get-NetAdapter).ifIndex

# Turn off IPv6 Random & Temporary IP Assignments
Set-NetIPv6Protocol -RandomizeIdentifiers Disabled
Set-NetIPv6Protocol -UseTemporaryAddresses Disabled

# Turn off IPv6 Transition Technologies
Set-Net6to4Configuration -State Disabled
Set-NetIsatapConfiguration -State Disabled
Set-NetTeredoConfiguration -Type Disabled

# Add IPv4 Address, Gateway, and DNS
New-NetIPAddress -InterfaceIndex $ipIF -IPAddress $IPv4Address -PrefixLength $IPv4Prefix -DefaultGateway $IPv4GW
Set-DNSClientServerAddress –interfaceIndex $ipIF –ServerAddresses $IPv4DNS

# Rename the Computer, and Restart
Rename-Computer -NewName $computerName -force
Restart-Computer

$domainName  = "WS2-2324-ine.hogent"
$netBIOSname = "WS2-2324-ine"
$mode  = "Win2016"

Install-WindowsFeature AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools

Import-Module ADDSDeployment

$forestProperties = @{

    DomainName           = $domainName
    DomainNetbiosName    = $netBIOSname
    ForestMode           = $mode
    DomainMode           = $mode
    CreateDnsDelegation  = $false
    InstallDns           = $true
    DatabasePath         = "C:\Windows\NTDS"
    LogPath              = "C:\Windows\NTDS"
    SysvolPath           = "C:\Windows\SYSVOL"
    NoRebootOnCompletion = $false
    Force                = $true

}

Install-ADDSForest @forestProperties

$baseDN = "DC=WS2-2324-ine,DC=hogent"
$resourcesDN = "OU=Resources," + $baseDN

New-ADOrganizationalUnit "Resources" -path $baseDN
New-ADOrganizationalUnit "Admin Users" -path $resourcesDN
New-ADOrganizationalUnit "Groups Security" -path $resourcesDN
New-ADOrganizationalUnit "Service Accounts" -path $resourcesDN
New-ADOrganizationalUnit "Workstations" -path $resourcesDN
New-ADOrganizationalUnit "Servers" -path $resourcesDN
New-ADOrganizationalUnit "Users" -path $resourcesDN

$ForestFQDN = "WS2-2324-ine.hogent"
$SchemaDC   = "dc1.WS2-2324-ine.hogent"

Enable-ADOptionalFeature –Identity 'Recycle Bin Feature' –Scope ForestOrConfigurationSet –Target $ForestFQDN -Server $SchemaDC -confirm:$false

