$profilePath = $PROFILE
if (!(Test-Path -Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force | Out-Null
}
$mainCode = Get-Content -Path ".\main.ps1"
Add-Content -Path $profilePath -Value $mainCode
Write-Host "cfolder installation completed!"
