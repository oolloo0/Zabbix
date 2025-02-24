$minutesToCheck = 5
$startTime = (Get-Date).AddMinutes(-$minutesToCheck)

$events = Get-WinEvent -FilterHashtable @{
        LogName   = 'Security'
        ID        = 4728, 4729
        StartTime = $startTime
    } -ErrorAction SilentlyContinue

if ($events) {
    foreach ($event in $events) {
        $xml = [xml]$event.ToXml()
        $eventData = @{}
        $xml.Event.EventData.Data | ForEach-Object { 
            $eventData[$_.Name] = $_.'#text' 
        }
        $member = ($eventData.MemberName -split ',')[0] -replace 'CN=',''

        switch ($event.Id) {
            4728 { 
                Write-Output "Added $member to $($eventData.TargetUserName) by $($eventData.SubjectUserName)"
            }
            4729 { 
                Write-Output "Removed $member from $($eventData.TargetUserName) by $($eventData.SubjectUserName)"
            }
        }
    }
}
else {
    Write-Output "No group membership changes"
}
