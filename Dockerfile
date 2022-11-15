FROM mcr.microsoft.com/powershell:lts-7.2-nanoserver-1809

SHELL ["pwsh", "-Command"]

RUN Set-Service -Name wuauserv -StartupType Manual
RUN Install-WindowsFeature -Name NET-Framework-Features
