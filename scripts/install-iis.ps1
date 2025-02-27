# IIS and .NET Framework Installation Script

Write-Host "Starting IIS and .NET Framework Installation..." -ForegroundColor Yellow
Write-Host "------------------------------------------------" -ForegroundColor Yellow

try {
    # IIS Web Server and basic features
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole -All -NoRestart
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServer -All -NoRestart
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-CommonHttpFeatures -All -NoRestart
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-DefaultDocument -All -NoRestart
    
    # ASP.NET 2.0-4.8
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-ASPNET -All -NoRestart
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-ASPNET45 -All -NoRestart
    Enable-WindowsOptionalFeature -Online -FeatureName NetFx3 -All -NoRestart # .NET Framework 3.5 (includes 2.0)
    
    # IIS Management Tools
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-ManagementConsole -All -NoRestart
    
    Write-Host "IIS ve .NET Framework kurulumu basariyla tamamlandi!" -ForegroundColor Green
}
catch {
    Write-Host "An error occurred during installation: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Lutfen PowerShell'i yonetici olarak calistirdiginizdan emin olun." -ForegroundColor Yellow
}
