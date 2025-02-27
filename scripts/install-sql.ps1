# SQL Server Kurulum Scripti
param(
    [Parameter(Mandatory=$true)]
    [string]$SqlPassword
)

Write-Host "SQL Server Express Kurulumu Baslatiliyor..." -ForegroundColor Yellow
Write-Host "------------------------------------------------" -ForegroundColor Yellow

$tempPath = "$env:TEMP\MironSetup"
Write-Host "Indirme klasoru: $tempPath" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path $tempPath | Out-Null

try {
    # SQL Server Express kurulumu
    Write-Host "SQL Server Express kuruluyor..." -ForegroundColor Cyan
    Write-Host "Bu islem biraz zaman alabilir, lutfen bekleyin..." -ForegroundColor Yellow
    
    $sqlExpressPath = "$PSScriptRoot\..\kurulum\SQLServer2016-SSEI-Expr.exe"
    
    # SQL Server kurulum parametreleri
    $installArgs = "/IACCEPTSQLSERVERLICENSETERMS /QUIET /ACTION=Install /FEATURES=SQL /INSTANCENAME=SQLEXPRESS " + `
                  "/SQLSYSADMINACCOUNTS=`"BUILTIN\Administrators`" /SECURITYMODE=SQL /SAPWD=`"$SqlPassword`" " + `
                  "/TCPENABLED=1 /NPENABLED=1 /HIDECONSOLE=1"
    
    Write-Host "Kurulum baslatiliyor..." -ForegroundColor Yellow
    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = $sqlExpressPath
    $startInfo.Arguments = $installArgs
    $startInfo.UseShellExecute = $false
    $startInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
    $startInfo.CreateNoWindow = $true
    
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $startInfo
    $process.Start() | Out-Null
    $process.WaitForExit()
    
    Write-Host "Kurulum islemi tamamlandi. Exit Code: $($process.ExitCode)" -ForegroundColor Yellow
    
    if ($process.ExitCode -eq 0) {
        Write-Host "SQL Server Express kurulumu basariyla tamamlandi!" -ForegroundColor Green
        Write-Host "SA Kullanici sifreniz guvenli bir yerde saklanmalidir." -ForegroundColor Yellow
    } else {
        Write-Host "SQL Server kurulumunda hata olustu! Exit Code: $($process.ExitCode)" -ForegroundColor Red
        Write-Host "Lutfen log dosyalarini kontrol edin." -ForegroundColor Yellow
        
        # Log dosyalarını C: sürücüsüne kopyala
        Get-ChildItem "$env:ProgramFiles\Microsoft SQL Server\*\Setup Bootstrap\Log" -Recurse -Filter "Summary*.txt" | 
        Sort-Object LastWriteTime -Descending | 
        Select-Object -First 1 | 
        ForEach-Object {
            $targetPath = "C:\SQLServer_Summary_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
            Copy-Item $_.FullName $targetPath
            Write-Host "Kurulum ozeti kaydedildi: $targetPath" -ForegroundColor Yellow
            Get-Content $targetPath | ForEach-Object {
                Write-Host $_ -ForegroundColor Gray
            }
        }
    }
} catch {
    Write-Host "Hata olustu: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Hata detayi: $($_)" -ForegroundColor Red
} finally {
    Write-Host "`nGecici dosyalar temizleniyor..." -ForegroundColor Yellow
    Remove-Item -Path $tempPath -Recurse -Force -ErrorAction SilentlyContinue
}
