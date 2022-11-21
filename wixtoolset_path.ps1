$wix_dir = (Get-ChildItem -Recurse C:\Program*\Wix*Toolset*\bin -Filter "heat.exe" | select-object -first 1).Directory.FullName
$oldPath = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine)
if ($oldPath.Split(';') -inotcontains $wix_dir){ `
  [Environment]::SetEnvironmentVariable('Path', $("{0};${wix_dir}" -f $oldPath), [EnvironmentVariableTarget]::Machine) `
}
