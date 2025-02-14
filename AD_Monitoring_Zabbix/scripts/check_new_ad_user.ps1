$Events = Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4720; StartTime=(Get-Date).AddMinutes(-5)} -ErrorAction SilentlyContinue
if ($Events) { Write-Host 1 } else { Write-Host 0 }
