FROM mcr.microsoft.com/windows/servercore:1803

SHELL ["pwsh", "-Command"]

RUN Set-Service -Name wuauserv -StartupType Manual; Install-WindowsFeature -Name NET-Framework-Features
