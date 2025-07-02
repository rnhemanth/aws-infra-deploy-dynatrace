

# Vars passed in from ssm
param (
  [Parameter(Mandatory=$true)]
  [string]$costcentre,
  [string]$product,
  [string]$msiName,
  [string]$monitormode,
  [string]$automationmode,
  [string]$serverFunction
)



write-host $serverFunction

write-host $costcentre


write-host $monitormode

write-host $automationmode