$zip = Join-Path $env:USERPROFILE 'Downloads\apache-maven-3.9.6-bin.zip'
$dest = 'C:\apache-maven-3.9.6'
if (-Not (Test-Path $dest)) {
    New-Item -ItemType Directory -Path $dest | Out-Null
}
Invoke-WebRequest -Uri 'https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip' -OutFile $zip -UseBasicParsing
Expand-Archive -LiteralPath $zip -DestinationPath 'C:\' -Force
if (Test-Path 'C:\apache-maven-3.9.6\bin') {
    $currentUserPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    if ($currentUserPath -notlike '*C:\apache-maven-3.9.6\bin*') {
        [Environment]::SetEnvironmentVariable('Path', "$currentUserPath;C:\apache-maven-3.9.6\bin", 'User')
    }
    $env:Path = 'C:\apache-maven-3.9.6\bin;' + $env:Path
}
Write-Host 'Maven installation completed.'
