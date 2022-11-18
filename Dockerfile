FROM mcr.microsoft.com/windows/servercore:ltsc2019

SHELL ["powershell", "-Command"]

ENV CHOCO_URL=https://chocolatey.org/install.ps1

RUN Set-Service -Name wuauserv -StartupType Manual; \
    Install-WindowsFeature -Name NET-Framework-Features

RUN Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]'Tls,Tls11,Tls12'; \
    iex ((New-Object System.Net.WebClient).DownloadString("$env:CHOCO_URL"))

RUN choco feature disable -n showDownloadProgress; \
    choco feature enable -n allowGlobalConfirmation

RUN choco install wixtoolset
RUN $wix_dir = (Get-ChildItem -Recurse C:\Program*\Wix*Toolset*\bin -Filter "heat.exe" | select-object -first 1).Directory.FullName; \
    $oldPath = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine); \
    If ($oldPath.Split(';') -inotcontains $wix_dir){ [Environment]::SetEnvironmentVariable('Path', $("{0};${wix_dir}" -f $oldPath), [EnvironmentVariableTarget]::Machine) }

RUN choco install python --version 3.9
RUN choco install git ytt dos2unix

RUN pip install --disable-pip-version-check --quiet --quiet \
    wheel pip

RUN heat -?
