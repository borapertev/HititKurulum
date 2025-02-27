# SQL Server Kurulum Scripti

# Yönetici hakları kontrolü
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "Bu script yonetici haklari gerektiriyor!" -ForegroundColor Red
    Write-Host "Lutfen PowerShell'i yonetici olarak calistirip tekrar deneyin." -ForegroundColor Yellow
    exit
}

Write-Host "SQL Server Express Kurulumu Baslatiliyor..." -ForegroundColor Yellow
Write-Host "------------------------------------------------" -ForegroundColor Yellow

try {
    # SQL Server kurulumu kontrolü
    Write-Host "Mevcut kurulum kontrol ediliyor..." -ForegroundColor Cyan
    $sqlRegKey = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server" -ErrorAction SilentlyContinue
    $sqlInstances = @()
    
    if ($sqlRegKey -and (Get-Member -InputObject $sqlRegKey -Name "InstalledInstances" -ErrorAction SilentlyContinue)) {
        $sqlInstances = $sqlRegKey.InstalledInstances
    }
    
    if ($sqlInstances -contains "HITIT") {
        Write-Host "`nSQL Server Express zaten kurulu." -ForegroundColor Green
        return
    }

    # Temp klasörü oluştur
    $tempFolder = "$env:TEMP\SQLServerSetup"
    if (Test-Path $tempFolder) {
        Remove-Item $tempFolder -Recurse -Force
    }
    New-Item -ItemType Directory -Path $tempFolder -Force | Out-Null

    # SQL Server Express'i indir
    $sqlDownloadUrl = "https://download.microsoft.com/download/9/0/7/907AD35F-9F9C-43A5-9789-52470555DB90/ENU/SQLEXPR_x64_ENU.exe"
    $sqlInstallerPath = Join-Path $tempFolder "SQLEXPR_x64_ENU.exe"

    Write-Host "`nSQL Server Express indiriliyor..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $sqlDownloadUrl -OutFile $sqlInstallerPath

    if (Test-Path $sqlInstallerPath) {
        Write-Host "SQL Server Express indirme tamamlandi." -ForegroundColor Green
        Write-Host "`nKurulum basliyor..." -ForegroundColor Cyan
        Write-Host "Bu islem 10-20 dakika surebilir." -ForegroundColor Yellow

        # Kurulum parametreleri
        $installArgs = "/QUIET /IACCEPTSQLSERVERLICENSETERMS /ACTION=Install /FEATURES=SQLEngine /INSTANCENAME=HITIT /SECURITYMODE=SQL /SAPWD=00560056 /SQLSYSADMINACCOUNTS=`"BUILTIN\Administrators`" /BROWSERSVCSTARTUPTYPE=Automatic /ERRORREPORTING=0"
        
        # Kurulumu başlat
        $process = Start-Process -FilePath $sqlInstallerPath -ArgumentList $installArgs -Wait -PassThru -Verb RunAs
        
        if ($process.ExitCode -eq 0) {
            Write-Host "`n------------------------------------------------" -ForegroundColor Yellow
            Write-Host "SQL Server Express kurulumu basariyla tamamlandi!" -ForegroundColor Green
            Write-Host "Instance: HITIT" -ForegroundColor Cyan
            Write-Host "SA Sifresi: 00560056" -ForegroundColor Cyan
            Write-Host "------------------------------------------------" -ForegroundColor Yellow
        } else {
            Write-Host "`n------------------------------------------------" -ForegroundColor Yellow
            Write-Host "SQL Server kurulumunda hata olustu! Exit Code: $($process.ExitCode)" -ForegroundColor Red
            Write-Host "Lutfen kurulum loglarini kontrol edin: $env:ProgramFiles\Microsoft SQL Server\130\Setup Bootstrap\Log" -ForegroundColor Yellow
            Write-Host "------------------------------------------------" -ForegroundColor Yellow
        }
    } else {
        throw "SQL Server Express indirilemedi!"
    }
    
} catch {
    Write-Host "`n------------------------------------------------" -ForegroundColor Yellow
    Write-Host "Hata olustu: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Hata detayi: $($_)" -ForegroundColor Red
    Write-Host "------------------------------------------------" -ForegroundColor Yellow
} finally {
    # Temp klasörünü temizle
    if (Test-Path $tempFolder) {
        Remove-Item $tempFolder -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# Add progress bar for long operations
function Show-Progress {
    param($Activity, $Status, $PercentComplete)
    Write-Progress -Activity $Activity -Status $Status -PercentComplete $PercentComplete
}
