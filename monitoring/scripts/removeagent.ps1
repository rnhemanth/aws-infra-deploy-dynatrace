$app = Get-WmiObject win32_product -filter "Name like 'Dynatrace OneAgent'"
msiexec /x $app.IdentifyingNumber /quiet /l*vx uninstall.log





Write-Output "execution Complete"



$foldersclearup = ("c:\PROGRAMDATA\dynatrace\oneagent\log\", "c:\PROGRAMDATA\dynatrace\oneagent\agent\config\")
foreach ($folder in $foldersclearup)
{
Write-Output $folder
Get-ChildItem $($folder) | Remove-Item -recurse -Force -ErrorAction SilentlyContinue
write-host "Content of $folder Deleted.." -BackgroundColor Green -ForegroundColor Black
}

Write-Output "Artifacts in folders cleared"
