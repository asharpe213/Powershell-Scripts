# Script for backing up config files for H1896 and H1898
# Documentation for the steps can be found at http://sharepoint/departments/GIS/Wiki/Designer%20deployment.aspx
# When logging into the servers, you will need to enter your x account information.  Otherwise you will receive the following error:
# Access is denied.
# Remember to remove your password from the document 
# Written by a# 2/23/2017

$username = "corp\aas2222"
$password = "IlovePiZZa"

If (Test-Path -Path "\\c01m21\c01m21\GISDevelopment\Designer\Installers\Config Backlog\H1896\Desktop Config\Desktop.config_old_$(get-Date -f yyyyMMdd)") {
	Rename-item "\\c01m21\c01m21\GISDevelopment\Designer\Installers\Config Backlog\H1896\Desktop Config\Desktop.config" Desktop.config_old_$(get-Date -f yyyyMMddhhmm)
}
Else {
	Rename-item "\\c01m21\c01m21\GISDevelopment\Designer\Installers\Config Backlog\H1896\Desktop Config\Desktop.config" Desktop.config_old_$(get-Date -f yyyyMMdd)
}

If (Test-Path -Path "\\c01m21\c01m21\GISDevelopment\Designer\Installers\Config Backlog\H1898\Desktop Config\Desktop.config_old_$(get-Date -f yyyyMMdd)") {
	Rename-item "\\c01m21\c01m21\GISDevelopment\Designer\Installers\Config Backlog\H1898\Desktop Config\Desktop.config" Desktop.config_old_$(get-Date -f yyyyMMddHHmm)
}
Else {
	Rename-item "\\c01m21\c01m21\GISDevelopment\Designer\Installers\Config Backlog\H1898\Desktop Config\Desktop.config" Desktop.config_old_$(get-Date -f yyyyMMdd)
}

If (Test-Path -Path "\\c01m21\c01m21\GISDevelopment\Designer\Installers\Config Backlog\H1896\Extended Data Config\ExtendedDataConfiguration.xml_old_$(get-Date -f yyyyMMdd)") {
	Rename-Item "\\c01m21\c01m21\GISDevelopment\Designer\Installers\Config Backlog\H1896\Extended Data Config\ExtendedDataConfiguration.xml" ExtendedDataConfiguration.xml_old_$(get-Date -f yyyyMMddHHmm)
}
Else {
	Rename-Item "\\c01m21\c01m21\GISDevelopment\Designer\Installers\Config Backlog\H1896\Extended Data Config\ExtendedDataConfiguration.xml" ExtendedDataConfiguration.xml_old_$(get-Date -f yyyyMMdd)
}

If (Test-Path -Path "\\c01m21\c01m21\GISDevelopment\Designer\Installers\Config Backlog\H1898\Extended Data Config\ExtendedDataConfiguration.xml_old_$(get-Date -f yyyyMMdd)") {
	Rename-Item "\\c01m21\c01m21\GISDevelopment\Designer\Installers\Config Backlog\H1898\Extended Data Config\ExtendedDataConfiguration.xml" ExtendedDataConfiguration.xml_old_$(get-Date -f yyyyMMddHHmm)
}
Else {
	Rename-Item "\\c01m21\c01m21\GISDevelopment\Designer\Installers\Config Backlog\H1898\Extended Data Config\ExtendedDataConfiguration.xml" ExtendedDataConfiguration.xml_old_$(get-Date -f yyyyMMdd)
}

If (Test-Path -Path "\\c01m21\c01m21\GISDevelopment\Designer\Installers\Config Backlog\H1896\Locator Config\LocatorConfiguration.xml_old_$(get-Date -f yyyyMMdd)") {
	Rename-Item "\\c01m21\c01m21\GISDevelopment\Designer\Installers\Config Backlog\H1896\Locator Config\LocatorConfiguration.xml" LocatorConfiguration.xml_old_$(get-Date -f yyyyMMddHHmm)
}
Else {
	Rename-Item "\\c01m21\c01m21\GISDevelopment\Designer\Installers\Config Backlog\H1896\Locator Config\LocatorConfiguration.xml" LocatorConfiguration.xml_old_$(get-Date -f yyyyMMdd)
}

If (Test-Path -Path "\\c01m21\c01m21\GISDevelopment\Designer\Installers\Config Backlog\H1898\Locator Config\LocatorConfiguration.xml_old_$(get-Date -f yyyyMMdd)") {
	Rename-Item "\\c01m21\c01m21\GISDevelopment\Designer\Installers\Config Backlog\H1898\Locator Config\LocatorConfiguration.xml" LocatorConfiguration.xml_old_$(get-Date -f yyyyMMddHHmm)
}
Else {
	Rename-Item "\\c01m21\c01m21\GISDevelopment\Designer\Installers\Config Backlog\H1898\Locator Config\LocatorConfiguration.xml" LocatorConfiguration.xml_old_$(get-Date -f yyyyMMdd)
}

# Connect to remote server 1896
$password = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ( $username, $password )
Enter-PSSession -ComputerName H1896 -Credential $cred
Copy-Item "C:\Program Files (x86)\Miner and Miner\SE.Avista.ArcFM.Desktop\Desktop.config" "\\c01m21\c01m21\GISDevelopment\Designer\Installers\Config Backlog\H1896\Desktop Config"
Copy-Item "C:\Program Files (x86)\Miner and Miner\SE.Avista.ArcFM.Desktop\ExtendedDataConfiguration.xml" "\\c01m21\c01m21\GISDevelopment\Designer\Installers\Config Backlog\H1896\Extended Data Config"
Copy-Item "C:\Program Files (x86)\ArcGIS\Desktop10.2\bin\LocatorConfiguration.xml" "\\c01m21\c01m21\GISDevelopment\Designer\Installers\Config Backlog\H1896\LocatorConfiguration"
Exit-PSSession 

# Connect to remote server 1898
$password = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ( $username, $password )
Enter-PSSession -ComputerName H1898 -Credential $cred
Copy-Item "C:\Program Files (x86)\Miner and Miner\SE.Avista.ArcFM.Desktop\Desktop.config" "\\c01m21\c01m21\GISDevelopment\Designer\Installers\Config Backlog\H1898\Desktop Config"
Copy-Item "C:\Program Files (x86)\Miner and Miner\SE.Avista.ArcFM.Desktop\ExtendedDataConfiguration.xml" "\\c01m21\c01m21\GISDevelopment\Designer\Installers\Config Backlog\H1898\Extended Data Config"
Copy-Item "C:\Program Files (x86)\ArcGIS\Desktop10.2\bin\LocatorConfiguration.xml" "\\c01m21\c01m21\GISDevelopment\Designer\Installers\Config Backlog\H1898\LocatorConfiguration"
Exit-PSSession 