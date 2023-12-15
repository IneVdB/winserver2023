#https://learn.microsoft.com/en-us/sql/database-engine/install-windows/install-sql-server-with-powershell-desired-state-configuration?view=sql-server-ver16

New-Item -Path C:\SQL2019 -ItemType Directory
$mountResult = Mount-DiskImage -ImagePath 'Z:\isos\en_sql_server_2019_standard_x64_dvd_814b57aa.iso' -PassThru
$volumeInfo = $mountResult | Get-Volume
$driveInfo = Get-PSDrive -Name $volumeInfo.DriveLetter
Copy-Item -Path ( Join-Path -Path $driveInfo.Root -ChildPath '*' ) -Destination C:\SQL2019\ -Recurse
Dismount-DiskImage -ImagePath 'Z:\isos\en_sql_server_2019_standard_x64_dvd_814b57aa.iso'

Import-DscResource -ModuleName SqlServerDsc

Configuration SQLInstall
{


    node localhost
    {
        WindowsFeature 'NetFramework45'
        {
            Name   = 'NET-Framework-45-Core'
            Ensure = 'Present'
        }


        SqlSetup 'InstallDefaultInstance'
        {
            InstanceName        = 'MSSQLSERVER'
            Features            = 'SQLENGINE'
            SourcePath          = 'C:\SQL2019'
            SQLSysAdminAccounts = @('Administrators')
            DependsOn           = '[WindowsFeature]NetFramework45'
        }
    }
}

Start-DscConfiguration -Path C:\SQLInstall -Wait -Force -Verbose