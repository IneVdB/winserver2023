# Installatiehandleiding Windows Server 2

## ISO locatie

De ISO's van SQL Server 2019, Windows Server 2019, Sharepoint en Windows 10 staan in een map genaamd `isos` die op dezelfde locatie staat als waar het script wordt uitgevoerd. In het geval van het voorbeeld is dit D:\winserver2\

## Installatie Windows 10 Client

- open een Powershell commandline
- navigeer naar de plaats waar de scripts map staat, bijvoorbeeld `cd D:\winserver2\`
- voer het script uit met `./scripts/windows10.ps1`

## Opzet Windows server VMs

- open een Powershell commandline als administrator
- navigeer naar de plaats waar de scripts map staat, bijvoorbeeld `cd D:\winserver2\`
- voer het script uit met `. ./scripts/winserver.ps1`
- voer nu het volgende commando uit: `createWinServerVM -hdSizeMb 51250 -memSizeMb 2048 -vramMb 128 -nofCPUs 2 -vmName "DomainController"`

herhaal deze stappen voor alle VMs maar met de volgende commando's op het einde, open telkens een nieuw PowerShell venster:

`createWinServerVM -hdSizeMb 30720 -memSizeMb 2048 -vramMb 128 -nofCPUs 2 -vmName "CAserver"`

`createWinServerVM -hdSizeMb 51250 -memSizeMb 4096 -vramMb 128 -nofCPUs 2 -vmName "SPserver"`

`createWinServerVM -hdSizeMb 30720 -memSizeMb 2048 -vramMb 128 -nofCPUs 4 -vmName "DBserver"`

## Installatie GuestAdditions

### VM met GUI

- In de bovenste balk selecteer Devices -> insert guest additions DC image
- In de VM file explorer, ga naar This PC -> guest additions CD en dubbelklik op VBoxWindowsAdditions.exe
- doorloop de installer, op het einde kies voor Reboot Now en klik op Finish
- De VM herstart nu met GuestAdditions geïnstalleerd