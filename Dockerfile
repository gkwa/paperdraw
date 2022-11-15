FROM mcr.microsoft.com/powershell:lts-7.2-nanoserver-1809

SHELL ["pwsh", "-Command"]

ENV CHOCO_URL=https://chocolatey.org/install.ps1

RUN Set-ExecutionPolicy Bypass -Scope Process -Force
RUN [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]'Tls,Tls11,Tls12'
RUN iex ((New-Object System.Net.WebClient).DownloadString("$env:CHOCO_URL"));

RUN Set-Service -Name wuauserv -StartupType Manual
RUN Install-WindowsFeature -Name NET-Framework-Features

RUN choco install git -y
