
# These aprams to be passed in from ssm doc hashed for now while testing.
param (
  [Parameter(Mandatory=$true)]
  [string]$msiName,
  [string]$monitormode
)


$hostname = $env:computername

#$monitormode  moved out and set in ssm doc
$logaccess = "true"
$proxystr = "185.46.212.92:443"

# Define the path to the Dynatrace OneAgent installer
$installerPath = "C:\EMIS\Dynatrace\Agent\$($msiName)"


# Define the installation parameters
$parameters = "/quiet --set-monitoring-mode=$($monitormode) --set-app-log-content-access=$($logaccess) --set-host-name=$($hostname) --set-host-tag=installtags=notset --set-host-group=standard --set-proxy=$($proxystr)"

# Run the installer with the specified parameters
Start-Process -FilePath $installerPath -ArgumentList $parameters -Wait -NoNewWindow
