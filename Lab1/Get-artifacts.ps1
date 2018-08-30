Function Get-Artifacts {


[cmdletbinding()]

Param(
    
    [Parameter(Mandatory=$false)]
    [switch]$Export,
    
    [Parameter(Mandatory=$true)]
    [string]$Computer

)
    
    Set-Location $HOME

    #Time Information
    $Time = @{}

    $TimeValue = Get-Date
    $TimeZone = Get-TimeZone
    $TimeUptime = Get-WmiObject Win32_OperatingSystem | Select-Object LastBootUpTime

    $Time.TimeValue = $TimeValue
    $Time.TimeZone = $TimeZone
    $Time.TimeUptime = $TimeUptime

    $Time.TimeValue | Export-Csv -NoTypeInformation  -Path timevalue.csv
    $Time.TimeZone | Export-Csv -NoTypeInformation -Path timezone.csv
    $Time.TimeUptime | Export-Csv -NoTypeInformation -Path timeuptime.csv

    $Time.TimeValue | Format-Table
    $Time.TimeZone | Format-Table
    $Time.TimeUptime | Format-Table

    #Os Versioning
    $OsVersion = Get-CimInstance Win32_OperatingSystem | Select-Object Caption, Version, OSArchitecture
    $OsVersion | Format-Table

    $OsVersion | Export-Csv -NoTypeInformation -Path osversion.csv

    #Computer Hardware Specs
    $Hardware = @{}

    $HardwareProcs = Get-ComputerInfo | Select-Object CsProcessors
    $HardwareRam = Get-ComputerInfo | Select-Object OsTotalVisibleMemorySize

    $Hardware.HardwareProcs = $HardwareProcs
    $Hardware.HardwareRam = $HardwareRam

    $Hardware.HardwareProcs | Export-Csv -NoTypeInformation -Path hardwareprocs.csv

    $Hardware.HardwareRam | Export-Csv -NoTypeInformation -Path hardwareram.csv

    $Hardware.HardwareProcs | Format-Table
    $Hardware.HardwareRam | Format-Table

    #Hard Drive Stuff
    $Drives = Get-WmiObject Win32_LogicalDisk | Select-Object DeviceID, Size
    $Drives | Format-Table

    $Drives | Export-Csv -NoTypeInformation -Path drives.csv

    #active directory stuff goes here

    #Hostname and Domain
    
    #List of Users
    $LocalUsers = Get-LocalUser | Select-Object Name,LastLogon,SID
    $LocalUsers | Format-Table

    $LocalUsers | Export-Csv -NoTypeInformation -Path local.csv
     
    #Doamin Users

    #Service Accounts
    
    #Networking Stuff
    $Networking = @{}
    
    $Networking.ARPTable = Get-NetNeighbor
    $Networking.Interfaces = Get-NetAdapter | Select-Object Name, InterfaceDescription, MacAddress
    $Networking.RoutingTable = Get-NetRoute
    $Networking.AdvancedInfo = (ipconfig /all)

    $ListeningTCPConnections = (Get-NetTCPConnection | Where-Object {($_.State -eq "Listen")})
    $Networking.ListeningProcesses = $ListeningTCPConnections

    $UDPEndpoints = Get-NetUDPEndpoint
    $Networking.UDPEndpoints = $UDPEndpoints

    $EstablishedTCPConnections = (Get-NetTCPConnection | Where-Object {($_.State -eq "Established")})
    $Networking.EstablishedConnections = $EstablishedTCPConnections

    $Networking.DNSCache = Get-DnsClientCache

    $Networking.ARPTable | Format-Table
    $Networking.Interfaces | Format-Table
    $Networking.AdvancedInfo | Format-Table
    $Networking.RoutingTable | Format-Table
    $Networking.ListeningProcesses | Format-Table
    $Networking.UDPEndpoints | Format-Table
    $Networking.EstablishedConnections | Format-Table
    $Networking.DnsCache | Format-Table

    $Networking.ARPTable | Export-Csv -NoTypeInformation -Path networkarptable.csv
    $Networking.Interfaces | Export-Csv -NoTypeInformation -Path networkinterfaces.csv
    $Networking.AdvancedInfo | Export-Csv -NoTypeInformation -Path networkadvancedinfo.csv
    $Networking.RoutingTable | Export-Csv -NoTypeInformation -Path networkroutingtable.csv
    $Networking.ListeningProcesses | Export-Csv -NoTypeInformation -Path networklistening.csv
    $Networking.UDPEndpoints | Export-Csv -NoTypeInformation -Path networkudp.csv
    $Networking.EstablishedConnections | Export-Csv -NoTypeInformation -Path networkestablished.csv
    $Networking.DnsCache | Export-Csv -NoTypeInformation -Path networkdnscache.csv

    #Networking Objects
    $NetworkObjects = @{}
    
    $NetworkObjects.Shares = Get-SmbShare
    $NetworkObjects.Printers = Get-Printer
    $NetworkObjects.WirelessProfiles = (netsh wlan show profiles)

    $NetworkObjects.Shares | Format-Table
    $NetworkObjects.Printers | Format-Table
    $NetworkObjects.WirelessProfiles | Format-Table

    $NetworkingObjects.Shares | Export-Csv -NoTypeInformation -Path objectshares.csv
    $NetworkingObjects.Printers | Export-Csv -NoTypeInformation -Path objectprinters.csv
    $NetworkingObjects.WirelessProfiles | Export-Csv -NoTypeInformation -Path objectwirelessprofiles.csv

    #Installed Software
    $InstalledSoftware = Get-WmiObject -Class Win32_Product
    $InstalledSoftware | Format-Table
    $InstalledSoftware | Export-Csv -NoTypeInformation -Path installed.csv


    #Process List
    $Processes = @{}
    $Processes.List = Get-WmiObject Win32_Process | Select-Object ProcessName,ProcessID,ParentProcessID
    $Processes.Path = Get-Process | Select-Object Path

    $Processes.List | Format-Table
    $Processes.Path | Format-Table

    $Processes.List | Export-Csv -NoTypeInformation -Path installedlist.csv
    $Process.Path | Export-Csv -NoTypeInformation -Path installedpath.csv

    #Driver things
    $Drivers = @{}
    $Drivers.List = Get-WindowsDriver -Online -All | Select-Object Driver, BootCritical, OriginalFileName, Version, Date, ProviderName

    $Drivers.List | Format-Table

    $Drivers.List | Export-Csv -NoTypeInformation -Path drivers.csv

    $UserFiles = @{}

    foreach($Folder in Get-ChildItem -Path 'C:\Users') {
        if(Test-Path "C:\Users\$($folder.Name)\Documents") {
            $UserFiles.Documents = Get-ChildItem -Path "C:\Users\$($Folder.Name)\Documents" -Recurse -File
        }
        if(Test-Path "C:\Users\$($folder.Name)\Downloads") {
            $UserFiles.Documents = Get-ChildItem -Path "C:\Users\$($Folder.Name)\Downloads" -Recurse -File
        }
    }
    
    $UserFiles | Format-Table

    $UserFiles | Export-Csv -NoTypeInformation -Path files.csv


    #Start combining the csv files here

    Get-ChildItem -Path $HOME -Filter *.csv | ForEach-Object {
    [System.IO.File]::AppendAllText("$HOME/artifacts", [System.IO.File]::ReadAllText($_.FullName))
    Remove-Item $_
    }

    Move-Item -Path $HOME/artifacts -Destination $HOME/artifacts.csv

}

Get-Artifacts -Computer "localhost"