FROM mcr.microsoft.com/windows/servercore:ltsc2019

SHELL ["powershell", "-Command"]

ENV CHOCO_URL=https://chocolatey.org/install.ps1

RUN Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]'Tls,Tls11,Tls12'; \
    iex ((New-Object System.Net.WebClient).DownloadString("$env:CHOCO_URL"))

RUN &C:\ProgramData\chocolatey\bin\choco feature disable -n showDownloadProgress; \
    &C:\ProgramData\chocolatey\bin\choco feature enable -n allowGlobalConfirmation

RUN Set-Service -Name wuauserv -StartupType Manual; \
    Install-WindowsFeature -Name NET-Framework-Features; \
    Set-Service -Name wuauserv -StartupType Automatic; \
    &C:\ProgramData\chocolatey\bin\choco install wixtoolset; \
    Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1" -Force; \
    $wix_dir = (Get-ChildItem -Recurse C:\Program*\Wix*Toolset*\bin `\
        -Filter "heat.exe" | Select-Object -First 1).Directory.FullName; \
    Install-ChocolateyPath -PathToInstall $wix_dir

RUN &C:\ProgramData\chocolatey\bin\choco install python --version 3.9.13
RUN &C:\ProgramData\chocolatey\bin\choco install git ytt dos2unix golang

RUN python -m pip install --upgrade --quiet --quiet wheel pip

RUN &C:\ProgramData\chocolatey\bin\choco list --local-only
