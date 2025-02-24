try {
    $events = Get-WinEvent -FilterHashtable @{
        LogName = 'Security'
        ID = 4720
        StartTime = (Get-Date).AddMinutes(-5)
    } -ErrorAction Stop

    if ($events) {
        foreach ($event in $events) {
            $xml = [xml]$event.ToXml()
            $creator = ($xml.Event.EventData.Data | Where-Object { $_.Name -eq 'SubjectUserName' }).'#text'
            $newUser = ($xml.Event.EventData.Data | Where-Object { $_.Name -eq 'TargetUserName' }).'#text'
            Write-Output "New user $newUser created by $creator"
        }
    } else {
        Write-Output "No new user events"
    }
} catch {
    Write-Output "No new user events"
}
