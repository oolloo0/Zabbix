$Events = Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4728,4729; StartTime=(Get-Date).AddMinutes(-5)} -ErrorAction SilentlyContinue
if ($Events) {
    foreach ($Event in $Events) {
        $Action = if ($Event.Id -eq 4728) { "Added to" } else { "Removed from" }
        $Details = @{
            TimeCreated = $Event.TimeCreated
            PerformedBy = ($Event.Properties[1].Value)
            TargetUser = ($Event.Properties[0].Value)
            GroupName = ($Event.Properties[2].Value)
        }
        Write-Output "Time: $($Details.TimeCreated), Performed By: $($Details.PerformedBy), User: $($Details.TargetUser), Action: $Action Group: $($Details.GroupName)"
    }
} else {
    Write-Output "No events found"
}
