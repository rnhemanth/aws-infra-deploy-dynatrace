

# Vars passed in from ssm
param (
  [Parameter(Mandatory=$true)]
  [string]$costcentre,
  [string]$product
)


# Tagging functions
function getenvironment { 
    $domain = (Get-WmiObject Win32_ComputerSystem).Domain
    if ($domain -match 'gplive') { return $('prd') }
    elseif ($domain -match 'ccmh') { return $('prd') }
    elseif ($domain -match 'cp') { return $('prd') }
    elseif ($domain -match 'white.local') { return $('prd') }
    elseif ($domain -match 'jersey') { return $('prd') }
    elseif ($domain -match 'iom') { return $('prd') }
    elseif ($domain -match 'hscni') { return $('prd') }
    elseif ($domain -match 'northernireland') { return $('prd') }
    elseif ($domain -match 'emishs') { return $('prd') }
    elseif ($domain -match 'cymru.nhs.uk') { return $('prd') }
    elseif ($domain -match 'devtest') { return $('dev') }
    elseif ($domain -match 'workgroup') { return $('dev') }
    elseIF ($domain -match 'DEV.') { return "dev" }
    elseIF ($domain -match 'STG.') { return "stg" }
    elseIF ($domain -match 'prd.') { return "prd" }
    elseIF ($domain -match 'england.emis-web.com') { return "prd" }
    elseIF ($domain -match 'dev.england.emis-web.com') { return "dev" }
    elseIF ($domain -match 'stg.england.emis-web.com') { return "stg" }
    elseIF ($domain -match 'shared-services.emis-web.com') { return "prd" }
    elseIF ($domain -match 'dev.england.shared-services.com') { return "dev" }
    elseIF ($domain -match 'stg.england.shared-services.com') { return "stg" }
    else { return $('unknown') }
}



function getservice {
    $compname = $env:computername
    if ($compname -match 'GP') { return $('emisweb') }
    elseif ($compname -match 'PFS1LIS') { return $string = "emis.patientfacingservices.api" }
    elseif ($compname -match 'SS') { return $('sharedservice') }
    elseif ($compname -match 'EC') { return $('emisconnect') }
    elseif ($compname -match 'AWS-TD1-CON') { return $('emisconnect') }
    elseif ($compname -match 'RP') { return $('resourcepublisher') }
    elseif ($compname -match 'LIB') { return $('library') }
    elseif ($compname -match 'IDX') { return $('index') }
    elseif ($compname -match 'API') { return $('emisweb') }
    elseif ($compname -match 'AWS-TD1-APP1') { return $('emisweb') }
    elseif ($compname -match 'ob-') { return $('DYNATRACEtesterservice') }
    elseif ($compname -match 'ENEUW2') { return $('emisweb') }
    elseif ($compname -match 'IBI') { return $('ibi') }

}




# work out the availability zone using IMDSv1 or IMDSv2

try {
    $token = Invoke-RestMethod -Uri "http://169.254.169.254/latest/api/token" -Method PUT -Headers @{ 'X-aws-ec2-metadata-token-ttl-seconds' = '21600' }
    $az = (Invoke-RestMethod -Uri "http://169.254.169.254/latest/dynamic/instance-identity/document" -Headers @{ 'X-aws-ec2-metadata-token' = $token }).availabilityZone
} catch {
    Write-Host "IMDSv2 failed. Trying IMDSv1..."
    # Attempt to get the availability zone using IMDSv1
    $az = (Invoke-RestMethod -Uri "http://169.254.169.254/latest/dynamic/instance-identity/document").availabilityZone
}
Write-Host "Availability Zone: $az"




#  add any additonal server types or loacales to accomodate for tagging and constructing host groups
$domain=(Get-WmiObject -Namespace root\cimv2 -Class Win32_ComputerSystem | Select-Object Domain -ExpandProperty Domain)
$computerName=$env:computername
$locale = switch -Wildcard ( $computerName )
{ 'EN*' { 'eng' } 'SC*' { 'scot' } 'NI*' { 'ni' } 'NWIS*' { 'wales' } '*EUW2IBI*' { 'ibi'} '*EUW2IDX*' { 'idx' } '*EUW2ECP*' { 'cph' } }



$type = switch -Wildcard ( $computerName )
{  
    '*IBISIS*' { 'db'; break } 
    '*IBISRS*' { 'db'; break } 
    '*IBIMGT*' { 'mgmt'; break }
    '*IBISAS*' { 'db'; break } 
    '*EUW2ECPH0*' { 'app'; break }
    #add new none emis web services above this line and include break so multiple are not detected. 
    '*APP*' { 'app'; break } 
    '*DB*' { 'db'; break } 
    '*RS*' { 'rs'; break } 
     
}



$speciality = switch -Wildcard ( $computerName )
{ '*GP*' { 'gp' } '*CM*' { 'ccmh' } '*DEV*' { 'dev' } '*STG*' { 'stg' } '*UAT*' { 'ccmhuat' } '*TRN*' { 'ccmhtrn' }  'ENEUW2CS*' { 'clinical-svcs'} '*EUW2IBI*' { 'ibi'} '*EUW2IDX*' { 'index' } '*EUW2ECP*' { 'comm-pharm' } }


#pd tag
if (($speciality -eq 'ccmhuat') -or ($speciality -eq 'ccmhtrn') )
{
$pd = [String]::Concat('aws_',$locale,'_',$computerName.Substring(6,6)).ToLower()
}
elseif ($speciality -eq 'ibi')
{$pd = [String]::Concat('aws_',$locale,'_',$computerName.Substring($computerName.Length - 2)).ToLower()}
elseif ($speciality -eq 'index')
{$pd = [String]::Concat('aws_',$locale)}
elseif ($speciality -eq 'comm-pharm')
{$pd = [String]::Concat('aws_',$locale,'_','cph_connect')}
#### new environments added above this line
elseif (($speciality -eq 'dev') -or ($speciality -eq 'stg') )
{$pd = $speciality}
else {$pd = [String]::Concat('aws_',$locale,'_',$computerName.Substring(6,4)).ToLower()}


$environment = getenvironment

$hostgroup =  $locale+"_"+$environment+"_"+$type
$proxystr = "185.46.212.92:443"

#################################### End of Taging logic





############################### Stop service and ready the Env tags and ctl updates
# stop process
$servicename = "Dynatrace OneAgent"
if (Get-Service $servicename) {Stop-service -Name $($servicename) -Force -ErrorAction SilentlyContinue}



# Formulate key pair values for metadata instead of tags.
$replacements = @{


    'host' = $env:computername
    'Environment' = $environment 
    'pd' = $pd
    'service' = getservice
    'speciality' = $speciality
    'region' = $locale
    'dc' = $az
    'domain' = $domain
    'type' = $type
    
    
}

# Update the hostcustomproperties file with key metadata
foreach ($key in $replacements.Keys) {
& "C:\Program Files\dynatrace\oneagent\agent\tools\oneagentctl.exe" --set-host-property "$($key)=$($replacements[$key])"

}

Write-Host "Dynatrace Metadata set"

#set host group
& "C:\Program Files\dynatrace\oneagent\agent\tools\oneagentctl.exe" --set-host-group=$($hostgroup)

Write-Host "Dynatrace Host Groiup set"


#set proxy
& "C:\Program Files\dynatrace\oneagent\agent\tools\oneagentctl.exe" --set-proxy=$($proxystr)


#set costcentre
& "C:\Program Files\dynatrace\oneagent\agent\tools\oneagentctl.exe" --set-host-property=dt.cost.costcenter=$($costcentre)

Write-Host "Dynatrace Host costcentre set"

#set product

& "C:\Program Files\dynatrace\oneagent\agent\tools\oneagentctl.exe" --set-host-property=dt.cost.product=$($product)


Write-Host "Dynatrace Host product set"




# booting up the service
start-service -Name $($servicename) 

write-host "service staring and configs saved"

