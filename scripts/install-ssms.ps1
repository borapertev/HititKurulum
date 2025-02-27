# SSMS Kurulum Scripti

Write-Host "SQL Server Management Studio Kurulumu Baslatiliyor..." -ForegroundColor Yellow
Write-Host "------------------------------------------------" -ForegroundColor Yellow

try {
    # SSMS yüklü mü kontrol et
    $ssmsPath = "${env:ProgramFiles(x86)}\Microsoft SQL Server Management Studio*"
    if (Test-Path $ssmsPath) {
        Write-Host "SQL Server Management Studio zaten yuklu!" -ForegroundColor Green
        Write-Host "Guncellemeleri kontrol ediliyor..." -ForegroundColor Yellow
        
        # Güncelleme kontrolü
        $process = Start-Process -FilePath "winget" -ArgumentList "upgrade --id Microsoft.SQLServerManagementStudio -h --accept-source-agreements --accept-package-agreements" -Wait -PassThru -NoNewWindow
        
        if ($process.ExitCode -eq 0) {
            Write-Host "SSMS guncel durumda!" -ForegroundColor Green
        } else {
            Write-Host "SSMS guncellemesinde hata olustu! Exit Code: $($process.ExitCode)" -ForegroundColor Red
        }
    } else {
        # SSMS kurulumu
        Write-Host "SQL Server Management Studio kuruluyor..." -ForegroundColor Cyan
        Write-Host "Bu islem biraz zaman alabilir, lutfen bekleyin..." -ForegroundColor Yellow
        
        $process = Start-Process -FilePath "winget" -ArgumentList "install --id Microsoft.SQLServerManagementStudio -h --accept-source-agreements --accept-package-agreements" -Wait -PassThru -NoNewWindow
        
        if ($process.ExitCode -eq 0) {
            Write-Host "SSMS kurulumu basariyla tamamlandi!" -ForegroundColor Green
        } else {
            Write-Host "SSMS kurulumunda hata olustu! Exit Code: $($process.ExitCode)" -ForegroundColor Red
        }
    }
} catch {
    Write-Host "Hata olustu: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Hata detayi: $($_)" -ForegroundColor Red
} finally {
    Write-Host "`nGecici dosyalar temizleniyor..." -ForegroundColor Yellow
    $tempPath = "$env:TEMP\MironSetup"
    Remove-Item -Path $tempPath -Recurse -Force -ErrorAction SilentlyContinue
}
