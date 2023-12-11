# Installatiehandleiding Windows Server 2

## ISO locatie

De ISO's van SQL Server 2019, Windows Server 2019, Sharepoint en Windows 10 staan in een map genaamd `isos` die op dezelfde locatie staat als waar het script wordt uitgevoerd. In het geval van het voorbeeld is dit D:\winserver2\

## Installatie Windows 10 Client

- open een Powershell commandline
- navigeer naar de plaats waar de scripts map staat, bijvoorbeeld `cd D:\winserver2\`
- voer het script uit met `./scripts/windows10.ps1`

## Opzet Windows server VMs


### Installatie DomeinController

- open een Powershell commandline als administrator
- navigeer naar de plaats waar de scripts map staat, bijvoorbeeld `cd D:\winserver2\`
- voer het script uit met `. ./scripts/winserver.ps1`
- creer de VM met het commando `createWinServerVM -hdSizeMb 51250 -memSizeMb 2048 -vramMb 128 -nofCPUs 2 -vmName "DomainController"`
- kies de juiste taalinstellingen
- klik op 'install now'
- klik op 'I don't have a product key' bij de product key activatie
- kies de 2019 standard MET desktop experience uit de lijst
- accepteer de license
- kies voor custom installatie
- klik op next
- wacht geduldig tot Windows Server geïnstalleerd is

### Installatie Certificate Authority server

- open een Powershell commandline als administrator
- navigeer naar de plaats waar de scripts map staat, bijvoorbeeld `cd D:\winserver2\`
- voer het script uit met `. ./scripts/winserver.ps1`
- creer de VM met het commando `createWinServerVM -hdSizeMb 30720 -memSizeMb 2048 -vramMb 128 -nofCPUs 2 -vmName "CAserver"`
- kies de juiste taalinstellingen
- klik op 'install now'
- klik op 'I don't have a product key' bij de product key activatie
- kies de 2019 standard ZONDER desktop experience uit de lijst
- accepteer de license
- kies voor custom installatie
- klik op next
- wacht geduldig tot Windows Server geïnstalleerd is
- kies een wachtwoord voor het admin account ('WinServer2023')

### Installatie Sharepoint server

- open een Powershell commandline als administrator
- navigeer naar de plaats waar de scripts map staat, bijvoorbeeld `cd D:\winserver2\`
- voer het script uit met `. ./scripts/winserver.ps1`
- creer de VM met het commando `createWinServerVM -hdSizeMb 51250 -memSizeMb 4096 -vramMb 128 -nofCPUs 2 -vmName "SPserver"`
- kies de juiste taalinstellingen
- klik op 'install now'
- klik op 'I don't have a product key' bij de product key activatie
- kies de 2019 standard desktop MET experience uit de lijst
- accepteer de license
- kies voor custom installatie
- klik op next
- wacht geduldig tot Windows Server geïnstalleerd is

### Installatie Database server

- open een Powershell commandline als administrator
- navigeer naar de plaats waar de scripts map staat, bijvoorbeeld `cd D:\winserver2\`
- voer het script uit met `. ./scripts/winserver.ps1`
- creer de VM met het commando `createWinServerVM -hdSizeMb 30720 -memSizeMb 2048 -vramMb 128 -nofCPUs 4 -vmName "DBserver"`
- kies de juiste taalinstellingen
- klik op 'install now'
- klik op 'I don't have a product key' bij de product key activatie
- kies de 2019 standard ZONDER desktop experience uit de lijst
- accepteer de license
- kies voor custom installatie
- klik op next
- wacht geduldig tot Windows Server geïnstalleerd is