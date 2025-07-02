# script intialisations
$elsdir = "C:\ProgramData\Datadog\EMISErrorLogScraper\"
$ddservices = @("datadogagent", "datadog-process-agent", "datadog-system-probe", "datadog-trace-agent", "EMISErrorLogScraper")



# Step Remove els if its on a db server
if (Get-Service "EMISErrorLogScraper" -ErrorAction SilentlyContinue)
    {
    write-host "ELS is present"
    Stop-Service -Name EMISErrorLogScraper
    Write-Host "STOPPED ELS Service"

    
    sc.exe delete "EMISErrorLogScraper"
    write-host "Service deleted"

        if ( Test-Path $elsdir ) 
        {
        Get-ChildItem -Path  $elsdir -Force -Recurse | Remove-Item -force -recurse
        Remove-Item $elsdir -Force
        write-host "ELS Folder removed"
        }

    }

else {
    Write-Host "not present"
    }






########## step 2:  remove dd and tracer


$ddstate = get-service -Name datadogagent -ErrorAction SilentlyContinue

if ($ddstate.Status -eq 'Running') 
    {
        Stop-Service -Name datadogagent -Force -Verbose
    }
    
    
    #uninstall apm .net tracer remove first
try {
    start-process msiexec -Wait -ArgumentList ('/log', 'C:\uninst.log', '/norestart', '/q', '/x', (Get-CimInstance -ClassName Win32_Product -Filter "Name='Datadog .NET Tracer 64-bit'" -ComputerName .).IdentifyingNumber)
    Write-Host "Datadog .NET Tracer 64-bit uninstalled."
    }

Catch 
    {
    Write-Host "Datadog .NET Tracer 64-bit not installed."
    }


    # wait a minuite let me finish
Start-Sleep 1


    #Uninistall dd
try {    
    start-process msiexec -Wait -ArgumentList ('/log', 'C:\uninst.log', '/norestart', '/q', '/x', (Get-CimInstance -ClassName Win32_Product -Filter "Name='Datadog Agent'" -ComputerName .).IdentifyingNumber)
    Write-Host "Datadog Agent uninstalled."
    }

Catch {
    Write-Host "Datadog Agent not installed."
    }





####### verify everything has gone.


foreach ($srv in $ddservices) 
{ 

    if (Get-Service $srv -ErrorAction SilentlyContinue) 
    {
    Write-Host "$($srv) is still present"
    }
    else
    {
    write-host "$($srv) removed"
    }
}



