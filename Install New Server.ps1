# Script for installing software on a new server
# a# 1.30.17
# Prerequisites: Powershell 3.0, Anna has admin permissions to machine
# Install module from https://gallery.technet.microsoft.com/scriptcenter/2d191bcd-3308-4edd-9de2-88dff796b0bc/

$ServerName = 'H2170'

# Collect the latest config file from TFS
$CollectionUrl = 'http://tfs.corp.com:8080/tfs/defaultcollection' 
Add-Type -AssemblyName 'Microsoft.TeamFoundation.Client, Version=11.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a' 
Add-Type -AssemblyName 'Microsoft.TeamFoundation.VersionControl.Client, Version=11.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a' 
$Collection = New-Object -TypeName Microsoft.TeamFoundation.Client.TfsTeamProjectCollection -ArgumentList $CollectionUrl 
$VersionControl = $Collection.GetService([Microsoft.TeamFoundation.VersionControl.Client.VersionControlServer]) 
$DestinationFile = "\C:\Users\Anna\DeploymentScripts\AppServiceConfig.xml"
$VersionControl.DownloadFile('$/QA/Software Deployment Scripts/AppServerConfig.xml', $DestinationFile) 

# Connect to remote server
$password = ConvertTo-SecureString "IlikePiZZa" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("corp\Anna", $password )
Enter-PSSession -ComputerName $ServerName -Credential $cred

# Verify access to S drive (\\c01M21\c01M21)
If (!(Test-Path S:))
{
$map = new-object -ComObject WScript.Network
$map.MapNetworkDrive("S:", "\\c01M21\c01M21", $true, "corp\Anna", "IlikePiZZa")
Write-Host "I successfully mapped the S drive for you."
}
else 
{Write-Host "The S drive is already correctly mapped."}

# Verify access to X drive (\\c01r01\c01r01)
If (!(Test-Path X:))
{
$map = new-object -ComObject WScript.Network
$map.MapNetworkDrive("X:", "\\c01r01\c01r01", $true, "corp\Anna", "IlikePiZZa")
Write-Host "I successfully mapped the X drive for you."
}
else 
{Write-Host "The X drive is already correctly mapped."}

# Installing Windows Updates
New-Item C:\Users\Anna\Documents\WindowsPowerShell\Modules\PSWindowsUpdate -type directory 
Copy-Item \\c01M21\c01M21\Contacts\Anna\PSWindowsUpdate\* C:\Users\Anna\Documents\WindowsPowerShell\Modules\PSWindowsUpdate
Import-Module PSWindowsUpdate
Get-WUInstall -WindowsUpdate -IgnoreUserInput -WhatIf -Verbose 

# Install IIS 7.5 Windows Server 2008 R2
cmd.exe 
"CMD /C START /w PKGMGR.EXE /l:log.etw /iu:IIS-WebServerRole;IIS-WebServer;IIS-CommonHttpFeatures;IIS-StaticContent;IIS-DefaultDocument;IIS-DirectoryBrowsing;IIS-HttpErrors;IIS-HttpRedirect;IIS-ApplicationDevelopment;IIS-ASP;IIS-CGI;IIS-ISAPIExtensions;IIS-ISAPIFilter;IIS-ServerSideIncludes;IIS-HealthAndDiagnostics;IIS-HttpLogging;IIS-LoggingLibraries;IIS-RequestMonitor;IIS-HttpTracing;IIS-CustomLogging;IIS-ODBCLogging;IIS-Security;IIS-BasicAuthentication;IIS-WindowsAuthentication;IIS-DigestAuthentication;IIS-ClientCertificateMappingAuthentication;IIS-IISCertificateMappingAuthentication;IIS-URLAuthorization;IIS-RequestFiltering;IIS-IPSecurity;IIS-Performance;IIS-HttpCompressionStatic;IIS-HttpCompressionDynamic;IIS-WebServerManagementTools;IIS-ManagementScriptingTools;IIS-IIS6ManagementCompatibility;IIS-Metabase;IIS-WMICompatibility;IIS-LegacyScripts;WAS-WindowsActivationService;WAS-ProcessModel;IIS-FTPServer;IIS-FTPSvc;IIS-FTPExtensibility;IIS-WebDAV;IIS-ASPNET;IIS-NetFxExtensibility;WAS-NetFxEnvironment;WAS-ConfigurationAPI;IIS-ManagementService;MicrosoftWindowsPowerShell"
exit

# Install .Net 3.5 using Server Manger Add Roles and Features Wizard
# To install from TFS https://blogs.technet.microsoft.com/heyscriptingguy/2014/04/21/powershell-and-tfs-the-basics-and-beyond/
Install-WindowsFeature -ConfigurationFilePath \\c01M21\c01M21\Contacts\Anna\DeploymentScripts\ArcMapAppServiceConfig.xml

cmd.exe 
"iisreset"
"C:\Windows\Microsoft.NET\Framework\v2.0.50727\aspnet_regiis.exe -i"
exit 

# Install Python, no settings need to be changed from default
msiexec.exe /i "\\c01m21\c01m21\Technical\Software\Python\python-2.7.5.msi" /passive

# Install custom oracle client
cmd.exe 
\\c01m21\c01m21\Technical\oracle\winnt_12c_client32\client32\setup.exe -responseFile "\\c01m21\c01m21\Contacts\Anna\DeploymentScripts\InstallCustomOracle12c.rsp"
exit 
Copy-Item "C:\drive\oracle\tsnames.ora" "C:\apps\oracle\ora12102\network\admin folder"
Copy-Item "C:\drive\oracle\sqlnet.ora" "C:\apps\oracle\ora12102\network\admin folder"

# Add a folder on the desktop for the installers
New-Item C:\Users\Anna\Desktop\Installers -type directory 

Copy-Item "\\c01m21\c01m21\Technical\Everything\Everything.exe" "C:\Users\Anna\Desktop\Installers"
Copy-Item "\\c01m21\c01m21\Technical\Everything\EverythingSetup.exe" "C:\Users\Anna\Desktop\Installers" 
msiexec.exe /i "C:\Users\Anna\Desktop\Installers\Everything.exe" /passive
msiexec.exe /i "C:\Users\Anna\Desktop\Installers\EverythingSetup.exe" /passive

Copy-Item "\\c01M21\c01M21\Designer\Installers\Services\WindowsServices.msi" "C:\Users\Anna\Desktop\Installers"
Copy-Item "\\c01M21\c01M21\Designer\Installers\Services\Installer.msi" "C:\Users\Anna\Desktop\Installers"
msiexec.exe /i "C:\Users\Anna\Desktop\Installers\TIF_WindowsServices_4.1.0.msi" /passive 
msiexec.exe /i "C:\Users\Anna\Desktop\Installers\SE.Avisa.Tif.Installer.msi" /passive

# Message Queuing
Import-Module Servermanager
Add-WindowsFeature MSMQ

# Install the latest .msi
$dir ="\\c01m21\c01m21\Designer\Installers\Desktop Installer\"
$filter = "*.msi"
$latest = Get-ChildItem -Path $dir -Filter $filter | Sort-Object LastWriteTime -Descending | Select-Object -First 1
Write-Host gc($dir + "\" + $latest.name) # For testing purposes
Copy-Item ($dir + $latest.name) "C:\Users\Anna\Desktop\Installers\"
msiexec.exe /i ("C:\Users\"\Desktop\Installers" + $latest.name") /passive

# Grant the Service.AppPool full control permissions to the private$/tiferror private$/tifinbound and private$/tifoutbound queues
Get-MsmqQueue -Name "tifinbound" -QueueType Private | Set-MsmqQueueAcl -UserName "NT AUTHORITY\SYSTEM" -Allow FullControl
Get-MsmqQueue -Name "tifinbound" -QueueType Private | Set-MsmqQueueAcl -UserName "IIS APPPOOL\Tif.Service.AppPool" -Allow FullControl
Get-MsmqQueue -Name "tifoutbound" -QueueType Private | Set-MsmqQueueAcl -UserName "NT AUTHORITY\SYSTEM" -Allow FullControl
Get-MsmqQueue -Name "tiferror" -QueueType Private | Set-MsmqQueueAcl -UserName "NT AUTHORITY\SYSTEM" -Allow FullControl

# Add a health.html page to the root folder to verify the server is running
Copy-Item \\c01M21\c01M21\ConfigurationFilesContacts\health.html C:\inetpub\wwwroot\Service

# Verify correct installations 
Test-Path "C:\Users\.NET v2.0"
Test-Path "C:\apps\Oracle"

# Verify the error logs have no errors, save to S:\ drive
$TimeStamp = get-Date -f yyyyMMddhhmm
$Path = "C:\Users\Anna\Desktop\Error Logs\Error_Log_$ServerName_$TimeStamp.csv"
Get-WinEvent -LogName "Application" -MaxEvents 100 -EA SilentlyContinue | Where-Object {$_.id -in $EventID -and $_.Timecreated -gt (Get-date).AddHours(-24)} | Sort TimeCreated -Descending | Export-Csv $Path -NoTypeInformation

write-host "Script complete, restarting server now." -foreground "green"

# Restart Server 
Restart-Computer -wait

# Disconnect from server
Exit-PSSession

write-host "Session ended." -foreground "green"

# Send email
write-host "Issuing email informing script has completed" -foreground "green"
$Outlook = New-Object -ComObject Outlook.Application
$Mail = $Outlook.CreateItem(0)
$Mail.To = "anna.xxxx@me.com"
$Mail.Subject = "Server Setup Complete"
$Mail.Body = "Server has been set up for Designer.  Attached is the latest error logs for the application."
$mail.Attachments.Add("C:\Users\Anna\Desktop\Error Logs\Error_Log_$ServerName_$TimeStamp.csv")
$Mail.Send()
