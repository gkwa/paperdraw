FROM mcr.microsoft.com/windows/servercore:ltsc2019

SHELL ["powershell", "-Command"]

ENV CHOCO_URL=https://chocolatey.org/install.ps1

RUN Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]'Tls,Tls11,Tls12'; \
    iex ((New-Object System.Net.WebClient).DownloadString("$env:CHOCO_URL"))

RUN &"C:\ProgramData\chocolatey\bin\choco" feature disable -n showDownloadProgress; \
    &"C:\ProgramData\chocolatey\bin\choco" feature enable -n allowGlobalConfirmation

RUN Set-Service -Name wuauserv -StartupType Manual; Install-WindowsFeature -Name NET-Framework-Features
RUN &"C:\ProgramData\chocolatey\bin\choco" install wixtoolset
COPY wixtoolset_path.ps1 /Windows/Temp/
RUN /Windows/Temp/wixtoolset_path.ps1

RUN &"C:\ProgramData\chocolatey\bin\choco" install python --version 3.9
RUN &"C:\ProgramData\chocolatey\bin\choco" install git ytt dos2unix

RUN pip install --upgrade --disable-pip-version-check --quiet --quiet wheel pip
