FROM mcr.microsoft.com/windows/servercore:ltsc2019

SHELL ["powershell", "-Command"]
ENV CHOCO_URL=https://chocolatey.org/install.ps1

RUN Set-Service -Name wuauserv -StartupType Manual; Install-WindowsFeature -Name NET-Framework-Features

RUN Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]'Tls,Tls11,Tls12'; \
    iex ((New-Object System.Net.WebClient).DownloadString("$env:CHOCO_URL"));

