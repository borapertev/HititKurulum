# SSMS Kurulum Scripti

# Yönetici hakları kontrolü
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "Bu script yonetici haklari gerektiriyor!" -ForegroundColor Red
    Write-Host "Lutfen PowerShell'i yonetici olarak calistirip tekrar deneyin." -ForegroundColor Yellow
    exit
}

Write-Host "SQL Server Management Studio Kurulumu Baslatiliyor..." -ForegroundColor Yellow
Write-Host "------------------------------------------------" -ForegroundColor Yellow
Write-Host "Not: Bu kurulum biraz zaman alabilir" -ForegroundColor Cyan
Write-Host "Lutfen kurulum tamamlanana kadar bekleyin..." -ForegroundColor Cyan
Write-Host "------------------------------------------------" -ForegroundColor Yellow

try {
    # Kurulum dosyası yolu
    $setupPath = Join-Path $PSScriptRoot "..\kurulum\SSMS-Setup-ENU.exe"
    
    if (-not (Test-Path $setupPath)) {
        throw "Kurulum dosyasi bulunamadi: $setupPath"
    }
    
    # SSMS kurulumu kontrolü - Registry'den kontrol et
    Write-Host "Mevcut kurulum kontrol ediliyor..." -ForegroundColor Cyan
    $installed = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | 
                Where-Object { $_.DisplayName -like "*SQL Server Management Studio*" }
    
    if ($installed) {
        Write-Host "`nSQL Server Management Studio zaten kurulu." -ForegroundColor Green
        Write-Host "Versiyon: $($installed.DisplayVersion)" -ForegroundColor Cyan
        return
    }

    # SSMS kurulumu
    Write-Host "`nSQL Server Management Studio kuruluyor..." -ForegroundColor Cyan
    Write-Host "Bu islem yaklasik 5-10 dakika surebilir." -ForegroundColor Yellow
    
    # Temp klasörünü temizle
    $tempFolder = "$env:TEMP\SSMSSetup"
    if (Test-Path $tempFolder) {
        Remove-Item $tempFolder -Recurse -Force
    }
    New-Item -ItemType Directory -Path $tempFolder -Force | Out-Null
    
    # Kurulum işlemini başlat
    $process = Start-Process -FilePath $setupPath -ArgumentList "/install /quiet /norestart /log `"$tempFolder\SSMS_Setup.log`"" -Wait -PassThru -Verb RunAs
    
    # Kurulum durumunu kontrol et
    $logFile = "$tempFolder\SSMS_Setup.log"
    if (Test-Path $logFile) {
        Write-Host "`nKurulum log dosyasi: $logFile" -ForegroundColor Cyan
        Get-Content $logFile -Tail 5 | ForEach-Object {
            Write-Host $_ -ForegroundColor Gray
        }
    }
    
    if ($process.ExitCode -eq 0 -or $process.ExitCode -eq 3010) {
        Write-Host "`n------------------------------------------------" -ForegroundColor Yellow
        Write-Host "SQL Server Management Studio kurulumu basariyla tamamlandi!" -ForegroundColor Green
        Write-Host "Programi baslat: Start > Microsoft SQL Server Management Studio" -ForegroundColor Cyan
        if ($process.ExitCode -eq 3010) {
            Write-Host "NOT: Degisikliklerin tamamlanmasi icin bilgisayarin yeniden baslatilmasi gerekebilir." -ForegroundColor Yellow
        }
        Write-Host "------------------------------------------------" -ForegroundColor Yellow
    } else {
        Write-Host "`n------------------------------------------------" -ForegroundColor Yellow
        Write-Host "SSMS kurulumunda hata olustu! Exit Code: $($process.ExitCode)" -ForegroundColor Red
        Write-Host "Log dosyasini kontrol edin: $logFile" -ForegroundColor Yellow
        Write-Host "Lutfen yonetici haklariyla calistirdiginizdan emin olun." -ForegroundColor Yellow
        Write-Host "------------------------------------------------" -ForegroundColor Yellow
    }
    
} catch {
    Write-Host "`n------------------------------------------------" -ForegroundColor Yellow
    Write-Host "Hata olustu: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Hata detayi: $($_)" -ForegroundColor Red
    Write-Host "Lutfen yonetici haklariyla calistirdiginizdan emin olun." -ForegroundColor Yellow
    Write-Host "------------------------------------------------" -ForegroundColor Yellow
} finally {
    # Temp klasörünü temizle
    if (Test-Path $tempFolder) {
        Remove-Item $tempFolder -Recurse -Force -ErrorAction SilentlyContinue
    }
}
