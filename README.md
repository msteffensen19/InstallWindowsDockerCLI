# InstallWindowsDockerCLI

### Install Docker on Windows CLI without Docker Desktop

This script installs docker, docker-app and docker-compose on Windows 

without installing the Docker Desktop, which you might need to pay for.



A required REBOOT will occur after registry changes that allow containerization.

The installation will then continue and install docker, docker-app and docker-compose

On a Windows machine, open a CMD window and run this command:

    git clone https://github.com/msteffensen19/InstallWindowsDockerCLI.git

Open Windows Explorer and right-click the file InstallWindowsDockerCLI.ps1 and 

select Run with PowerShell.


The versions that are installed are editable variables in the .ps1 file. 

Defaults are:

- docker                        24.0.7

- docker-app                v2.23.3

- docker-compose       v0.6.0
