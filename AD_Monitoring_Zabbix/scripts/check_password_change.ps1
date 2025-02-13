$Events = Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4724; StartTime=(Get-Date).AddMinutes(-5)} -ErrorAction SilentlyContinue
if ($Events) {
    foreach ($Event in $Events) {
        $Details = @{
            TimeCreated = $Event.TimeCreated
            ChangedBy = ($Event.Properties[1].Value)
            TargetUser = ($Event.Properties[0].Value)
        }
        Write-Output "Time: $($Details.TimeCreated), Changed By: $($Details.ChangedBy), Target User: $($Details.TargetUser)"
    }
} else {
    Write-Output "No events found"
}
