$domainName  = "WS2-2324-ine.hogent"
$netBIOSname = "WS2-2324-ine"
$mode  = "Default"

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

