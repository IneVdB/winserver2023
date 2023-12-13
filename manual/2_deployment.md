# Installatiehandleiding Windows Server 2

## ISO locatie

De ISO's van SQL Server 2019, Windows Server 2019, Sharepoint en Windows 10 staan in een map genaamd `isos` die op dezelfde locatie staat als waar het script wordt uitgevoerd. In het geval van het voorbeeld is dit D:\winserver2\

## Installatie Windows 10 Client

- open een Powershell commandline
- navigeer naar de plaats waar de scripts map staat, bijvoorbeeld `cd D:\winserver2\`
- voer het script uit met `./scripts/windows10.ps1`

## Installatie Windows Server VMs

- open een Powershell commandline als administrator
- navigeer naar de plaats waar de scripts map staat, bijvoorbeeld `cd D:\winserver2\`
- voer het script uit met `. ./scripts/winserver.ps1`
- voer nu het volgende commando uit: `createWinServerVM -hdSizeMb 51250 -memSizeMb 2048 -vramMb 128 -nofCPUs 2 -vmName "DomainController"`

herhaal deze stappen voor alle VMs maar met de volgende commando's op het einde, open telkens een nieuw PowerShell venster:

`createWinServerVM -hdSizeMb 30720 -memSizeMb 2048 -vramMb 128 -nofCPUs 2 -vmName "CAserver"`

`createWinServerVM -hdSizeMb 51250 -memSizeMb 4096 -vramMb 128 -nofCPUs 2 -vmName "SPserver"`

`createWinServerVM -hdSizeMb 30720 -memSizeMb 2048 -vramMb 128 -nofCPUs 4 -vmName "DBserver"`

### Installatie NAT netwerk

- open een Powershell commandline als administrator
- navigeer naar de plaats waar de scripts map staat, bijvoorbeeld `cd D:\winserver2\`
- voer het netwerk script uit met `./scripts/natnetwork.ps1`
  
### Installatie GuestAdditions

Doe dit voor alle Vm's:

- In de bovenste balk selecteer Devices -> insert guest additions DC image
- (op desktop experience) open een command prompt
- verander naar de CD drive met `E:`
- installeer de Guestadditions met `VBoxWindowsAdditions.exe /l` (`VBoxWindowsAdditions.exe /S` is ook een optie indien geen output gewenst is)
- doorloop de installer met default settings, op het einde kies voor Reboot Now en klik op Finish
- De VM herstart nu met GuestAdditions geïnstalleerd

### Netwerkinstellingen VM's

Doe dit voor alle VM's behalve de Windows 10 Client:

- start de VM
- open een command prompt als administrator
- Typ `Z:` en Enter
- voer het commando `PowerShell Set-ExecutionPolicy -ExecutionPolicy bypass` uit
- voer dan het volgende commando uit, voor de juiste VM:

DomainController: `PowerShell ". ./scripts/networkinit.ps1; setupNetwork -IP "192.168.23.12""`
CAserver: `PowerShell ". ./scripts/networkinit.ps1; setupNetwork -IP "192.168.23.22""`
SPserver: `PowerShell ". ./scripts/networkinit.ps1; setupNetwork -IP "192.168.23.32""`
DBserver: `PowerShell ". ./scripts/networkinit.ps1; setupNetwork -IP "192.168.23.42""`

De VM herstart automatisch met de juiste netwerkinstellingen.



