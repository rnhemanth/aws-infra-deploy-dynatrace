

# Vars passed in from ssm
param (
  [Parameter(Mandatory=$true)]
  [string]$metamodifier,
  [string]$metamode
)

$metamodifier = $metamodifier.ToLower()
$tagkey,$tagvalue = $metamodifier.split(':')


write-host "input string is $metamodifier"
write-host "Metatag key is $tagkey"
write-host "Metatag value is $tagvalue"
write-host "you are running an $metamode"

############################### Stop service and ready the Env tags and ctl updates
# stop process
$servicename = "Dynatrace OneAgent"
if (Get-Service $servicename) {Stop-service -Name $($servicename) -Force -ErrorAction SilentlyContinue}


# Update the hostcustomproperties file with key metadata

if ($metamode -eq "add") {
    switch ($tagkey) 
    {
      "host-group" {
      $hgcurrent = & "C:\Program Files\dynatrace\oneagent\agent\tools\oneagentctl.exe" --get-host-group
      $hgupdated = "$($hgcurrent)_$($tagvalue)"
      & "C:\Program Files\dynatrace\oneagent\agent\tools\oneagentctl.exe" --set-host-group=$($hgupdated)
      & "C:\Program Files\dynatrace\oneagent\agent\tools\oneagentctl.exe" --set-host-property "serverfunction=$($tagvalue)"
      }
      default {& "C:\Program Files\dynatrace\oneagent\agent\tools\oneagentctl.exe" --set-host-property "$($tagkey)=$($tagvalue)"}
    }
}
elseif ($metamode -eq "remove") {
    switch ($tagkey)
    {
      "host-group" {
      $hgcurrent = & "C:\Program Files\dynatrace\oneagent\agent\tools\oneagentctl.exe" --get-host-group
      $hgupdated = $($hgcurrent) -replace "_$($tagvalue)"
      & "C:\Program Files\dynatrace\oneagent\agent\tools\oneagentctl.exe" --set-host-group=$($hgupdated)
      & "C:\Program Files\dynatrace\oneagent\agent\tools\oneagentctl.exe" --remove-host-property "serverfunction=$($tagvalue)"
      
      }
      default {& "C:\Program Files\dynatrace\oneagent\agent\tools\oneagentctl.exe" --remove-host-property "$($tagkey)=$($tagvalue)"}
    }
}

Write-Host "Meta Data updated"

# booting up the service
start-service -Name $($servicename) 

write-host "service starting and configs saved"

