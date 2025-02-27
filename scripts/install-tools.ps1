# ReportViewer Kurulum Scripti

Write-Host "ReportViewer Kurulumu Baslatiliyor..." -ForegroundColor Yellow
Write-Host "------------------------------------------------" -ForegroundColor Yellow

$tempPath = "$env:TEMP\MironSetup"
New-Item -ItemType Directory -Force -Path $tempPath | Out-Null

try {
    # ReportViewer kurulumu
    Write-Host "ReportViewer dosya konumu: $PSScriptRoot\..\reports" -ForegroundColor Cyan
    Write-Host "ReportViewer kuruluyor..." -ForegroundColor Cyan
    
    $reportViewerPath = "$PSScriptRoot\..\reports\ReportViewer.exe"
    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = $reportViewerPath
    $startInfo.Arguments = "/q"
    $startInfo.UseShellExecute = $false
    $startInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
    $startInfo.CreateNoWindow = $true
    
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $startInfo
    $process.Start() | Out-Null
    $process.WaitForExit()
    
    $reportViewerPath2 = "$PSScriptRoot\..\reports\ReportViewer (1).exe"
    $startInfo.FileName = $reportViewerPath2
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $startInfo
    $process.Start() | Out-Null
    $process.WaitForExit()
    
    Write-Host "Kurulum basariyla tamamlandi!" -ForegroundColor Green
}
catch {
    Write-Host "Hata olustu: $($_.Exception.Message)" -ForegroundColor Red
}
finally {
    # Cleanup
    Remove-Item -Path $tempPath -Recurse -Force -ErrorAction SilentlyContinue
}
