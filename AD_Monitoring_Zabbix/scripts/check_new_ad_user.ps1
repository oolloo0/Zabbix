$Events = Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4720; StartTime=(Get-Date).AddMinutes(-5)} -ErrorAction SilentlyContinue
if ($Events) {
    foreach ($Event in $Events) {
        $Details = @{
            TimeCreated = $Event.TimeCreated
            Creator = ($Event.Properties[1].Value)
            NewUser = ($Event.Properties[0].Value)
        }
        Write-Output "Time: $($Details.TimeCreated), Created By: $($Details.Creator), New User: $($Details.NewUser)"
    }
} else {
    Write-Output "No events found"
}
