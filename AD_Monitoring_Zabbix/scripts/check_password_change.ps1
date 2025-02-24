$events = Get-WinEvent -FilterHashtable @{
  LogName = 'Security'; ID = 4724;
  StartTime = (Get-Date).AddMinutes(-5)
}
if ($events) {
  foreach ($event in $events) {
    $xml = [xml]$event.ToXml()
    $whoDidIt  = ($xml.Event.EventData.Data | Where-Object { $_.Name -eq 'SubjectUserName' }).'#text'
    $whoWasChanged = ($xml.Event.EventData.Data | Where-Object { $_.Name -eq 'TargetUserName' }).'#text'
    Write-Output "Password changed by $whoDidIt for $whoWasChanged"
  }
} else {
  Write-Output "No password change events"
}

