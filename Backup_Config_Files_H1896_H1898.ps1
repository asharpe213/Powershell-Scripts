# When logging into the servers, you will need to enter your account information.  Otherwise you will receive the following error:
# Access is denied.
# Written by a# 2/23/2017

$username = "corp\Anna"
$password = "IlovePiZZa"

If (Test-Path -Path "S:\Installers\Config Backlog\Desktop Config\MyConfig.config_old_$(get-Date -f yyyyMMdd)") {
	Rename-item "S:\Installers\Config Backlog\Desktop Config\MyConfig.config" Desktop.config_old_$(get-Date -f yyyyMMddhhmm)
}
Else {
	Rename-item "S:\Installers\Config Backlog\Desktop Config\MyConfig.config" Desktop.config_old_$(get-Date -f yyyyMMdd)
}

# Connect to remote server
$password = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ( $username, $password )
Enter-PSSession -ComputerName 6666 -Credential $cred
Copy-Item "C:\Program Files (x86)\MyProgram\bin\MyConfig.config" "S:\Installers\Config Backlog"
Exit-PSSession 
