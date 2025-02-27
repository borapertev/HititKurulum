# IIS ve .NET Framework Kurulum Scripti

Write-Host "IIS ve .NET Framework Kurulumu Baslatiliyor..." -ForegroundColor Yellow
Write-Host "------------------------------------------------" -ForegroundColor Yellow

try {
    # Windows özelliklerini yükle
    Write-Host "Windows ozellikleri yukleniyor..." -ForegroundColor Cyan
    
    $features = @(
        "IIS-WebServerRole",
        "IIS-WebServer",
        "IIS-CommonHttpFeatures",
        "IIS-HttpErrors",
        "IIS-ApplicationDevelopment",
        "IIS-NetFxExtensibility45",
        "IIS-NetFxExtensibility",
        "IIS-HealthAndDiagnostics",
        "IIS-HttpLogging",
        "IIS-Security",
        "IIS-RequestFiltering",
        "IIS-Performance",
        "IIS-WebServerManagementTools",
        "IIS-ManagementScriptingTools",
        "IIS-IIS6ManagementCompatibility",
        "IIS-StaticContent",
        "IIS-DefaultDocument",
        "IIS-DirectoryBrowsing",
        "IIS-WebSockets",
        "IIS-ASPNET",
        "IIS-ASPNET45",
        "IIS-ASP",
        "IIS-CGI",
        "IIS-ISAPIExtensions",
        "IIS-ISAPIFilter",
        "IIS-ServerSideIncludes",
        "NetFx4Extended-ASPNET45",
        "WAS-WindowsActivationService",
        "WAS-ProcessModel",
        "WAS-NetFxEnvironment",
        "WAS-ConfigurationAPI",
        "NetFx3",
        "NetFx3ServerFeatures"
    )

    foreach ($feature in $features) {
        Write-Host "Yukleniyor: $feature" -ForegroundColor Cyan
        $result = Enable-WindowsOptionalFeature -Online -FeatureName $feature -All -NoRestart
        if ($result.RestartNeeded) {
            Write-Host "UYARI: $feature icin sistem yeniden baslatilmasi gerekebilir." -ForegroundColor Yellow
        }
    }

    Write-Host "IIS ve .NET Framework kurulumu tamamlandi!" -ForegroundColor Green
    Write-Host "NOT: Tum ozelliklerin aktif olmasi icin sistemi yeniden baslatmaniz gerekebilir." -ForegroundColor Yellow

} catch {
    Write-Host "Hata olustu: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Hata detayi: $($_)" -ForegroundColor Red
}
