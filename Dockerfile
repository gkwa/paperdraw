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
    Set-Service -Name wuauserv -StartupType Automatic
RUN &C:\ProgramData\chocolatey\bin\choco install wixtoolset

RUN $wix_dir = 'C:\Program Files (x86)\WiX Toolset v3.11\bin'; \
    $Path = $wix_dir; \
    $Path = [Environment]::GetEnvironmentVariable("PATH", "Machine") + [IO.Path]::PathSeparator + $Path; \
    [Environment]::SetEnvironmentVariable("Path", $Path, "Machine")

RUN &C:\ProgramData\chocolatey\bin\choco install python --version 3.9.13
RUN &C:\ProgramData\chocolatey\bin\choco install git ytt dos2unix golang

RUN python -m pip install --upgrade --quiet --quiet wheel pip

RUN &C:\ProgramData\chocolatey\bin\choco list --local-only
