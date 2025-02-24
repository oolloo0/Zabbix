# Settings
$ZabbixServers = @("10.40.61.19:31051","10.40.61.20:31051", "10.40.61.21:31051")  # List of Zabbix servers
$ZabbixHost = "ZPI-windows-test-lab"  # Hostname in Zabbix
$Key = "unauthorized_openfiles"  # Zabbix item key
$AllowedFolder = "D:\Shares\Management"  # Monitored folder
$LogFile = "C:\zabbix_scripts\openfiles_result.log"
        
# Check if the log file exists – if not, create an empty one
if (!(Test-Path $LogFile)) {   
    New-Item -Path $LogFile -ItemType File -Force | Out-Null
}
        
# Get the current timestamp
$TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
         
# Clear previous results
$Results = @()

# Retrieve the list of open files
$OpenFilesRaw = openfiles /query /fo TABLE | Out-String
$Lines = $OpenFilesRaw -split "`r`n"
    
# Find the index of the header row
$DataStartIndex = ($Lines | Select-String -Pattern "ID\s+Accessed By\s+Type\s+Open File").LineNumber
        
# If no data is found → send "No unauthorized access detected" to Zabbix
if ($DataStartIndex -eq $null) {
    $NoAccessEntry = "$TimeStamp | No unauthorized access detected"
    
    $NoAccessEntry | Out-File -FilePath $LogFile -Append -Encoding utf8
    foreach ($Server in $ZabbixServers) {
        & "C:\Program Files\Zabbix Agent 2\zabbix_sender.exe" -z $Server -s $ZabbixHost -k $Key -o $NoAccessEntry
    }
    exit 0
}

# Process results and filter only for the "D:\Shares\Management" folder
foreach ($line in $Lines) {
    if ($line -match "^\s*(\d+)\s+(\S+)\s+\S+\s+(.+)$") {
        $FileID = $matches[1]
        $User = $matches[2]
        $FilePath = $matches[3]
    
        # Check if exactly "D:\Shares\Management" folder is open
        if ($FilePath -eq $AllowedFolder) {
            $LogEntry = "$TimeStamp | User: $User | Folder: $FilePath"
            $Results += $LogEntry
        }
    }
}

# If the "D:\Shares\Management" folder is open, save the new entry and send it to Zabbix
if ($Results.Count -gt 0) {
    $Results | Out-File -FilePath $LogFile -Append -Encoding utf8
    $LatestEntry = $Results[-1]

    foreach ($Server in $ZabbixServers) {
        & "C:\Program Files\Zabbix Agent 2\zabbix_sender.exe" -z $Server -s $ZabbixHost -k $Key -o $LatestEntry
    }
} else {
    # If the folder is NOT open, send "No unauthorized access detected" to Zabbix
    $NoAccessEntry = "$TimeStamp | No unauthorized access detected"
    
    $NoAccessEntry | Out-File -FilePath $LogFile -Append -Encoding utf8
    foreach ($Server in $ZabbixServers) {
        & "C:\Program Files\Zabbix Agent 2\zabbix_sender.exe" -z $Server -s $ZabbixHost -k $Key -o $NoAccessEntry
    }
}
