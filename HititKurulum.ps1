# Miron Software - Hitit Installation Tool
# Admin rights check
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "This script requires administrator rights. Please run PowerShell as administrator."
    break
}

function Show-MironLogo {
    Write-Host "
    MMMMMMMM               MMMMMMMM IIIIIIIIII RRRRRRRRRRRRRRRRR        OOOOOOOOO     NNNNNNNN        NNNNNNNN
    M:::::::M             M:::::::M I::::::::I R::::::::::::::::R     OO:::::::::OO   N:::::::N       N::::::N
    M::::::::M           M::::::::M I::::::::I R::::::RRRRRR:::::R  OO:::::::::::::OO N::::::::N      N::::::N
    M:::::::::M         M:::::::::M II::::::II RR:::::R     R:::::RO:::::::OOO:::::::ON:::::::::N     N::::::N
    M::::::::::M       M::::::::::M   I::::I    R::::R     R:::::RO::::::O   O::::::ON::::::::::N    N::::::N
    M:::::::::::M     M:::::::::::M   I::::I    R::::R     R:::::RO:::::O     O:::::ON:::::::::::N   N::::::N
    M:::::::M::::M   M::::M:::::::M   I::::I    R::::RRRRRR:::::R O:::::O     O:::::ON:::::::N::::N  N::::::N
    M::::::M M::::M M::::M M::::::M   I::::I    R:::::::::::::RR  O:::::O     O:::::ON::::::N N::::N N::::::N
    M::::::M  M::::M::::M  M::::::M   I::::I    R::::RRRRRR:::::R O:::::O     O:::::ON::::::N  N::::N:::::::N
    M::::::M   M:::::::M   M::::::M   I::::I    R::::R     R:::::RO:::::O     O:::::ON::::::N   N:::::::::::N
    M::::::M    M:::::M    M::::::M   I::::I    R::::R     R:::::RO:::::O     O:::::ON::::::N    N::::::::::N
    M::::::M     MMMMM     M::::::M   I::::I    R::::R     R:::::RO::::::O   O::::::ON::::::N     N:::::::::N
    M::::::M               M::::::M II::::::II RR:::::R     R:::::RO:::::::OOO:::::::ON::::::N      N::::::::N
    M::::::M               M::::::M I::::::::I R::::::R     R:::::R OO:::::::::::::OO N::::::N       N:::::::N
    M::::::M               M::::::M I::::::::I R::::::R     R:::::R   OO:::::::::OO   N::::::N        N::::::N
    MMMMMMMM               MMMMMMMM IIIIIIIIII RRRRRRRR     RRRRRRR     OOOOOOOOO     NNNNNNNN         NNNNNNN
    " -ForegroundColor Cyan
    Write-Host "                                 Hitit Kurulum Araci" -ForegroundColor Yellow
    Write-Host "                                 =================" -ForegroundColor Yellow
    Write-Host ""
}

function Show-Menu {
    Clear-Host
    Show-MironLogo
    Write-Host "1) IIS ve .NET Framework Kurulumu" -ForegroundColor Green
    Write-Host "2) ReportViewer 2005/2008 Kurulumu" -ForegroundColor Green
    Write-Host "3) SQL Server Express Kurulumu" -ForegroundColor Green
    Write-Host "4) SQL Server Management Studio Kurulumu" -ForegroundColor Green
    Write-Host "5) Tumunu Kur" -ForegroundColor Cyan
    Write-Host "Q) Cikis" -ForegroundColor Red
    Write-Host ""
    Write-Host "Seciminiz: " -NoNewline
}

# SQL Server sifre kontrolu
function Get-SqlPassword {
    Write-Host "`nSQL Server SA sifresi:" -ForegroundColor Yellow
    $password = Read-Host "`nSQL Server SA sifresini girin" -AsSecureString
    return $password
}

# Main program loop
do {
    Show-Menu
    $selection = Read-Host
    
    switch ($selection) {
        '1' {
            Write-Host "`nIIS ve .NET Framework kuruluyor..." -ForegroundColor Yellow
            & "$PSScriptRoot\scripts\install-iis.ps1"
        }
        '2' {
            Write-Host "`nReportViewer kuruluyor..." -ForegroundColor Yellow
            & "$PSScriptRoot\scripts\install-tools.ps1"
        }
        '3' {
            Write-Host "`nSQL Server Express kurulumu secildi." -ForegroundColor Yellow
            $sqlPassword = Read-Host -Prompt "SQL Server SA kullanici sifresi"
            & "$PSScriptRoot\scripts\install-sql.ps1" -SqlPassword $sqlPassword
        }
        '4' {
            Write-Host "`nSQL Server Management Studio kurulumu secildi." -ForegroundColor Yellow
            & "$PSScriptRoot\scripts\install-ssms.ps1"
        }
        '5' {
            Write-Host "`nTum bilesenler kuruluyor..." -ForegroundColor Cyan
            & "$PSScriptRoot\scripts\install-iis.ps1"
            & "$PSScriptRoot\scripts\install-tools.ps1"
            $sqlPassword = Get-SqlPassword
            & "$PSScriptRoot\scripts\install-sql.ps1" -SqlPassword $sqlPassword
            & "$PSScriptRoot\scripts\install-ssms.ps1"
        }
        'Q' {
            Write-Host "`nProgramdan cikiliyor..." -ForegroundColor Red
            break
        }
        default {
            Write-Host "`nGecersiz secim! Lutfen tekrar deneyin." -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
    
    if ($selection -ne 'Q') {
        Write-Host "`nDevam etmek icin bir tusa basin..." -ForegroundColor Green
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
} while ($selection -ne 'Q')
