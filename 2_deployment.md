# Installatiehandleiding Windows Server 2

## ISO locatie

De ISO's van SQL Server 2019, Windows Server 2019, Sharepoint en Windows 10 staan in een map genaamd `isos` die op dezelfde locatie staat als waar het script wordt uitgevoerd. In het geval van het voorbeeld is dit D:\winserver2\

## Scripts toestaan op de hostmachine

- open een powershell commandline als administrator
- voer het volgende commando uit `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine`

### Installatie NAT netwerk

- open een Powershell commandline als administrator op de hostmachine
- navigeer naar de plaats waar de scripts map staat, bijvoorbeeld `cd D:\winserver2\`
- voer het netwerk script uit met `./scripts/natnetwork.ps1`

## Installatie Windows Server VMs

- open een Powershell commandline als administrator op de hostmachine
- navigeer naar de plaats waar de scripts map staat, bijvoorbeeld `cd D:\winserver2\`
- voer nu het volgende commando uit: `. ./scripts/winserver.ps1 ; createWinServerVM -hdSizeMb 51250 -memSizeMb 2048 -vramMb 128 -nofCPUs 2 -vmName "DomainController"`

Indien nodig, klik op 'I don't have a product key' (dit is een bug want de --key parameter wordt wel meegegeven in de unattended install)

herhaal deze stappen voor alle VMs maar met de volgende commando's op het einde, open telkens een nieuw PowerShell venster:

`. ./scripts/winserver.ps1 ; createWinServerVM -hdSizeMb 30720 -memSizeMb 1024 -vramMb 128 -nofCPUs 2 -vmName "CAserver"`

`. ./scripts/winserver.ps1 ; createWinServerVM -hdSizeMb 51250 -memSizeMb 4096 -vramMb 128 -nofCPUs 2 -vmName "SPserver"`

`. ./scripts/winserver.ps1 ; createWinServerVM -hdSizeMb 30720 -memSizeMb 2048 -vramMb 128 -nofCPUs 4 -vmName "DBserver"`


## Initialisatie DomainController

### Netwerk

- start de VM
- open PowerShell als administrator (indien er geen gui is, typ powershell en klik op enter om powershell te openen, indien wel klik op het zoek icoon en typ 'powershell' en rechtermuisklik op de optie Windows PowerShell en kies 'Run as Administrator')
- voer het commando `Set-ExecutionPolicy -ExecutionPolicy bypass` uit
- typ `Y` en Enter
- voer dan het volgende commando uit: `. Z:\scripts\networkinit.ps1; setupNetwork -IP "192.168.23.12"`
- De VM herstart automatisch met de juiste netwerkinstellingen.

### Setup 

- Open een powershell venster als admin op de DomainController VM
- voer het script uit met `Z:/scripts/dcinitialize.ps1`
- voer een wachtwoord in wanneer er om gevraagd wordt, bijvoorbeeld `WinServer2023`
- na opstarten, voer het DNS script uit met `Z:/scripts/usermanagement.ps1; Z:/scripts/dns_new.ps1` in een admin powershell venster
- voer het DHCP script uit met `Z:/scripts/DHCP.ps1` in een admin powershell venster

## Initialisatie Database

### Netwerk

- start de VM
- open PowerShell als administrator (indien er geen gui is, typ powershell en klik op enter om powershell te openen, indien wel klik op het zoek icoon en typ 'powershell' en rechtermuisklik op de optie Windows PowerShell en kies 'Run as Administrator')
- voer het commando `Set-ExecutionPolicy -ExecutionPolicy bypass` uit
- voer dan het volgende commando uit: `. Z:\scripts\networkinit.ps1; setupNetwork -IP "192.168.23.42"`
- Het wachtwoord is `WinServer2023`
- De VM herstart automatisch met de juiste netwerkinstellingen.

### Setup 

- Open een powershell venster als admin op de DBserver VM
- voer het script uit met `Z:/scripts/sqlserver_install.ps1`

## Initialisatie CAserver

### Netwerk

- start de VM
- open PowerShell als administrator (indien er geen gui is, typ powershell en klik op enter om powershell te openen, indien wel klik op het zoek icoon en typ 'powershell' en rechtermuisklik op de optie Windows PowerShell en kies 'Run as Administrator')
- voer het commando `Set-ExecutionPolicy -ExecutionPolicy bypass` uit
- voer dan het volgende commando uit: `. Z:\scripts\networkinit.ps1; setupNetwork -IP "192.168.23.22"`
- Het wachtwoord is `WinServer2023`
- De VM herstart automatisch met de juiste netwerkinstellingen.
- 
### Setup 

- Open een powershell venster als admin op de CAserver VM
- voer het script uit met `Z:/scripts/CA.ps1`
- typ Y en enter
- Voer het volgende commando uit in powershell: `Z:\scripts\dns_secondary.ps1`

Op de DOMAINCONTROLLER, voer volgend commando uit in admin powershell:
`Set-DnsServerPrimaryZone -Name “WS2-2324-ine.hogent” -Notify Notifyservers -notifyservers “192.168.23.22” -SecondaryServers “192.168.23.22” -SecureSecondaries TransferToSecureServers`
De server heeft nu de DNS records van de primary dns server (de domeincontroller)


## Initialisatie SPserver

### Netwerk

- start de VM
- open PowerShell als administrator (indien er geen gui is, typ powershell en klik op enter om powershell te openen, indien wel klik op het zoek icoon en typ 'powershell' en rechtermuisklik op de optie Windows PowerShell en kies 'Run as Administrator')
- voer het commando `Set-ExecutionPolicy -ExecutionPolicy bypass` uit
- typ Y en enter
- voer dan het volgende commando uit: `. Z:\scripts\networkinit.ps1; setupNetwork -IP "192.168.23.32"`
- Het wachtwoord is `WinServer2023`
- De VM herstart automatisch met de juiste netwerkinstellingen.

### Setup 

- Open een powershell venster als admin op de SPserver VM
- voer het script uit met `Z:/scripts/sharepoint_prerequisites.ps1`
- De product key is `XNPCY-7K9B8-Y63P8-82MVM-39P2H`
- SharePoint wordt automatisch geïnstalleerd
- klik op close en yes zodat de server herstart

### config sharepoint

- in de configuratie wizard, klik op next en yes zodat de services worden herstart
- kies connect to an existing farm
- database server: `DBserver`
- database name: `MSSQLSERVER`


## Installatie Windows 10 Client

- open een Powershell commandline als administrator op de host machine
- navigeer naar de plaats waar de scripts map staat, bijvoorbeeld `cd D:\winserver2\`
- voer het script uit met `./scripts/windows10.ps1`
- in de VM, klik op next
- wacht tot de VM geïnstalleerd is
- open een command prompt als admin op de windows client vm (typ in de zoekbalk cmd, rechterklik erop en kier run as administrator)
- voer het volgende commando uit: `Z:/scripts/client.bat`
- SQL Server Management Studio wordt automatisch geïnstalleerd
 