#Powershell script for Windows to perform the following: 
 
#Install sysmon - https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon 
 
#Config: https://github.com/olafhartong/sysmon-modular 
 
#Install .net - https://dotnet.microsoft.com/en-us/download/dotnet-framework/net47 
 
#Increase logging size for common log paths - https://www.ninjaone.com/script-hub/how-to-increase-event-log-file-size-powershell/ 
 
#Download ghosts - https://github.com/cmu-sei/GHOSTS/releases/tag/8.0.0 
 
 
 
 
 
# Set download URLs 
 
$sysmonUrl = "https://download.sysinternals.com/files/Sysmon.zip" 
 
$sysmonConfigUrl = "https://raw.githubusercontent.com/olafhartong/sysmon-modular/master/sysmonconfig.xml" 
 
$dotNetFrameworkUrl = "http://go.microsoft.com/fwlink/?linkid=825302" 
 
$exerciseZipUrl = "https://cmu.box.com/shared/static/kqo5cl7f5f2v22xgud6o2fd26xrrwtpq.zip" 
 

# Set SSL/TLS options in case the server is old as shit or unpatched
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
 
# Set installation paths 
 
$sysmonExePath = "$env:TEMP\Sysmon.exe" 
 
$sysmonConfigPath = "$env:TEMP\config.xml" 
 
$dotNetInstallerPath = "C:\dotNetFrameworkInstaller.exe" 
 
$exerciseZipPath = "C:\exercise.zip" 
 
$exerciseFolderPath = "C:\exercise" 
 
 
 
# Log files 
 
$logs = "System", "Security", "Application", "Microsoft-Windows-Sysmon/Operational" 
 
 
 
# Download Sysmon ZIP file 
 
Write-Output "Downloading Sysmon ZIP file..." 
 
Invoke-WebRequest -Uri $sysmonUrl -OutFile "$env:TEMP\Sysmon.zip" 
 
 
 
# Download Sysmon Config file 
 
Write-Output "Downloading Sysmon Config file..." 
 
Invoke-WebRequest -Uri $sysmonConfigUrl -OutFile "$env:TEMP\config.xml" 
 
 
 
# Extract Sysmon 
 
Write-Output "Extracting Sysmon..." 
 
Expand-Archive -Path "$env:TEMP\Sysmon.zip" -DestinationPath "$env:TEMP" 
 
 
 
# Install Sysmon with configuration 
 
Write-Output "Installing Sysmon..." 
 
Start-Process -FilePath $sysmonExePath -ArgumentList "/accepteula -i $sysmonConfigPath" -Wait 
 
 
 
# Download and install .NET Framework 
 
Write-Output "Downloading .NET" 
 
Invoke-WebRequest -Uri $dotNetFrameworkUrl -OutFile $dotNetInstallerPath 
 
Write-Output "Installing .NET" 
 
Start-Process -FilePath $dotNetInstallerPath -ArgumentList "/quiet /norestart" -Wait 
 
 
 
# Increase logging size for System, Security, Application, and Sysmon to 50MB 
 
foreach ($log in $logs) { 
 
Write-Output "Increasing log size for $log" 
 
    Limit-EventLog -LogName $log -MaximumSize 50MB 
 
} 
 
 
 
Write-Output "If you get an error on the sysmon log the computer needs top be restarted for the event log to be created. Reboot run script #2" 
 
 
 
# Create exercise directory 
 
Write-Output "Creating exercise directory..." 
 
New-Item -ItemType Directory -Path $exerciseFolderPath -Force 
 
 
 
# Download exercise zip file 
 
Write-Output "Downloading ghosts zip binary" 
 
Invoke-WebRequest -Uri $exerciseZipUrl -OutFile $exerciseZipPath 
 
 
 
# Unzip exercise zip file 
 
Write-Output "Extracting ghosts zip" 
 
Expand-Archive -Path $exerciseZipPath -DestinationPath $exerciseFolderPath 
 
 
 
# Delete event logs 
 
Write-Output "Deleting logs to prepare for user sim" 
 
foreach ($log in $logs) { 
 
    Clear-EventLog -LogName $log 
 
} 
