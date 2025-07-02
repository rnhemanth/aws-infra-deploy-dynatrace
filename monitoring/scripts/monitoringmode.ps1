

# Vars passed in from ssm
param (
  [Parameter(Mandatory=$true)]
  [string]$monitoringmode
)


write-host "you are changing the monitoring mode to $($monitoringmode)"


############################### Stop service and ready the Env tags and ctl updates
# stop process
$servicename = "Dynatrace OneAgent"
if (Get-Service $servicename) {Stop-service -Name $($servicename) -Force -ErrorAction SilentlyContinue}


# Update the hostcustomproperties file with key metadata

& "C:\Program Files\dynatrace\oneagent\agent\tools\oneagentctl.exe" --set-monitoring-mode="$($monitoringmode)"

Write-Host "Monitoring mode updated"

# booting up the service
start-service -Name $($servicename) 

write-host "service starting and configs saved"
