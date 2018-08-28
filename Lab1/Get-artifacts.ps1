Function Get-Artifacts {

import-module Ac

[cmdletbinding()]

Param(
    
    [Parameter(Mandatory=$false)]
    [switch]$Export,
    
    [Parameter(Mandatory=$true)]
    [string]$Computer

)


$Creds = Get-Credential

Invoke-Command -ComputerName $Computer -Credential $Creds {
    
    #Time Information
    $TimeValue = Get-Date
    $TimeZone = Get-TimeZone
    $TimeUptime = Get-WmiObject Win32_OperatingSystem | Select-Object LastBootUpTime

    $Time = New-Object –TypeName PSObject
    $Time | Add-Member –MemberType NoteProperty –Name Time -Value $TimeValue
    $Time | Add-Member –MemberType NoteProperty –Name TimeZone -Value $TimeZone
    $Time | Add-Member –MemberType NoteProperty –Name Uptime -Value $TimeUptime.LastBootUpTime

    $Time | Format-Table

    #Os Versioning
    $OsVersion = Get-CimInstance Win32_OperatingSystem | Select-Object Caption, Version, OSArchitecture
    $OsVersion | Format-Table

    #Computer Hardware Specs
    $HardwareProcs = Get-ComputerInfo | Select-Object CsProcessors
    $HardwareRam = Get-ComputerInfo | Select-Object OsTotalVisibleMemorySize

    $Hardware = New-Object -TypeName PSObject
    $Hardware | Add-Member -MemberType NoteProperty -Name Processors -Value $HardwareProcs
    $Hardware | Add-Member -MemberType NoteProperty -Name Memory -Value $HardwareRam
    $Hardware | Format-Table

    #Hard Drive Stuff
    $Drives = Get-WmiObject Win32_LogicalDisk | Select-Object DeviceID, Size
    $Drives | Format-Table

    #active directory stuff goes here

    #Hostname and Domain
    
    #List of Users
    $LocalUsers = Get-WmiObject -Class win32_useraccount -Property * | Select-Object Name, SID
    $LocalUsers | Format-Table
     
    #Doamin Users

    #Service Accounts
    Get-WmiObject win32_service | Format-Table startname | select -Unique


}

}

Get-Artifacts -Computer "localhost"