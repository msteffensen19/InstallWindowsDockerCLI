param($Step="A")

$DockerCLIVersion = "24.0.7"
$DockerComposeVersion = "v2.23.3"
$DockerAppVersion = "v0.6.0"

# -------------------------------------
# Imports
# -------------------------------------
$script = $myInvocation.MyCommand.Definition
$scriptPath = Split-Path -parent $script
. (Join-Path $scriptpath functions.ps1)


Clear-Any-Restart

if (Should-Run-Step "A") 
{
    Write-Host "Installing Windows Containers feature ..."
    Install-WindowsFeature -Name Containers
	
	Write-Host "----------"	
	Write-Host "Updating Path to include C:\Program Files\Docker  ..."
	$old = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name path).path
	$new = "$old;C:\Program Files\Docker"
	Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name path -Value $new
	Write-Host "----------"	
	Write-Host "The Install Windows Docker CLI installation script will continue after a reboot."
	Write-Host ""
    read-host "Press ENTER to reboot " 
    Restart-And-Resume $script "B"
}

if (Should-Run-Step "B") 
{
	Write-Host "----------"
	Write-Host "Installing Docker Repository ..."

        Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
	
	Write-Host "----------"
	Write-Host "Installing Docker - this can take a couple of minutes ..."
        Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/microsoft/Windows-Containers/Main/helpful_tools/Install-DockerCE/install-docker-ce.ps1" -o install-docker-ce.ps1

        # Installing docker cli 

       .\install-docker-ce.ps1 -DockerVersion $DockerCLIVersion
     
	Write-Host "----------"
	Write-Host "Installing docker-compose and docker-app ..."
	cd C:\
 	New-Item -ItemType Directory -Path $Env:ProgramFiles\Docker

        # Using docker-compose

        Start-BitsTransfer -Source "https://github.com/docker/compose/releases/download/$DockerComposeVersion/docker-compose-windows-x86_64.exe" -Destination $Env:ProgramFiles\Docker\docker-compose.exe
        
        # Using docker-app v0.6.0

        Start-BitsTransfer -Source "https://github.com/docker/app/releases/download/$DockerAppVersion/docker-app-windows.tar.gz" -Destination $Env:ProgramFiles\Docker\docker-app-windows.tar.gz
        tar xvzf $Env:ProgramFiles\Docker\docker-app-windows.tar.gz -C $Env:ProgramFiles\Docker
        Move-Item -Path $Env:ProgramFiles\Docker\docker-app-windows.exe -Destination $Env:ProgramFiles\Docker\docker-app.exe
        del $Env:ProgramFiles\Docker\docker-app-windows.tar.gz 
    
	Write-Host "----------"	
}

Write-Host   ""
Write-Host   "This Docker-CLI-on-Windows installation is Complete."
Write-Host   ""
Write-Host   ""
read-host    "Press ENTER to exit the script "
