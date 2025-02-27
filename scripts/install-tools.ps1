# ReportViewer Kurulum Scripti

Write-Host "ReportViewer Kurulumu Baslatiliyor..." -ForegroundColor Yellow
Write-Host "------------------------------------------------" -ForegroundColor Yellow

try {
    # Dosya yollarını kontrol et
    $reportViewerDir = Join-Path $PSScriptRoot "..\kurulum\REPORTS ViEW"
    $reportViewer1 = Join-Path $reportViewerDir "ReportViewer.exe"
    $reportViewer2 = Join-Path $reportViewerDir "ReportViewer (1).exe"

    Write-Host "Dosya konumu: $reportViewerDir" -ForegroundColor Cyan

    # Dosyaların varlığını kontrol et
    if (-not (Test-Path $reportViewer1)) {
        Write-Host "HATA: $reportViewer1 bulunamadi!" -ForegroundColor Red
        return
    }
    if (-not (Test-Path $reportViewer2)) {
        Write-Host "HATA: $reportViewer2 bulunamadi!" -ForegroundColor Red
        return
    }

    Write-Host "ReportViewer dosyalari bulundu, kurulum basliyor..." -ForegroundColor Cyan

    # İlk ReportViewer kurulumu
    Write-Host "ReportViewer 1 kuruluyor..." -ForegroundColor Yellow
    $process = Start-Process -FilePath $reportViewer1 -ArgumentList "/q" -Wait -PassThru -NoNewWindow
    if ($process.ExitCode -ne 0) {
        Write-Host "ReportViewer 1 kurulumunda hata! Exit Code: $($process.ExitCode)" -ForegroundColor Red
        return
    }

    # İkinci ReportViewer kurulumu
    Write-Host "ReportViewer 2 kuruluyor..." -ForegroundColor Yellow
    $process = Start-Process -FilePath $reportViewer2 -ArgumentList "/q" -Wait -PassThru -NoNewWindow
    if ($process.ExitCode -ne 0) {
        Write-Host "ReportViewer 2 kurulumunda hata! Exit Code: $($process.ExitCode)" -ForegroundColor Red
        return
    }

    Write-Host "Kurulum basariyla tamamlandi!" -ForegroundColor Green
} catch {
    Write-Host "Hata olustu: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Hata detayi: $($_)" -ForegroundColor Red
}
