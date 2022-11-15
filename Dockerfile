FROM mcr.microsoft.com/powershell:lts-7.2-nanoserver-1809

ENV CHOCO_URL=https://chocolatey.org/install.ps1
RUN pwsh -Command Set-ExecutionPolicy Bypass -Scope Process -Force; \
    pwsh -Command [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]'Tls,Tls11,Tls12'; \
    pwsh -Command iex ((New-Object System.Net.WebClient).DownloadString("$env:CHOCO_URL"));

RUN pwsh -Command Set-Service -Name wuauserv -StartupType Manual; \
    pwsh -Command Install-WindowsFeature -Name NET-Framework-Features -Verbose

RUN choco install git -y
