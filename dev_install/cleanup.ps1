# Martes Cleanup - Remove old Docker builds and compact WSL disks
# Run as Administrator for disk compaction
#
# Usage: .\cleanup.ps1          - Docker cleanup only
#        .\cleanup.ps1 -Compact - Also compact WSL virtual disks

param(
    [switch]$Compact
)

Write-Host "=== Martes Docker Cleanup ===" -ForegroundColor Cyan
Write-Host ""

# Step 1: Run Docker cleanup inside WSL
Write-Host "[1/3] Cleaning up old Docker images and build cache..." -ForegroundColor Yellow
wsl -d Ubuntu-22.04 bash -c "cd /home/martin/martes/docker/nginx && bash cleanup.sh 2>/dev/null"

Write-Host ""
Write-Host "[2/3] Final Docker disk usage:" -ForegroundColor Yellow
wsl -d Ubuntu-22.04 bash -c "docker system df"

if ($Compact) {
    Write-Host ""
    Write-Host "[3/3] Compacting WSL virtual disks..." -ForegroundColor Yellow
    Write-Host "Shutting down WSL..."
    wsl --shutdown
    Start-Sleep -Seconds 5

    # Docker Desktop WSL disk
    $dockerVhd = "$env:LOCALAPPDATA\Docker\wsl\data\ext4.vhdx"
    if (Test-Path $dockerVhd) {
        $sizeBefore = (Get-Item $dockerVhd).Length / 1GB
        Write-Host "Docker disk: $([math]::Round($sizeBefore, 1)) GB - compacting..." -ForegroundColor Gray
        if (Get-Command Optimize-VHD -ErrorAction SilentlyContinue) {
            Optimize-VHD -Path $dockerVhd -Mode Full
            $sizeAfter = (Get-Item $dockerVhd).Length / 1GB
            $saved = $sizeBefore - $sizeAfter
            Write-Host "  $([math]::Round($sizeBefore, 1)) GB -> $([math]::Round($sizeAfter, 1)) GB (saved $([math]::Round($saved, 1)) GB)" -ForegroundColor Green
        } else {
            Write-Warning "Optimize-VHD not available. Enable Hyper-V tools or use diskpart."
        }
    }

    # Ubuntu/martes-dev WSL disk
    $ubuntuId = "79rhkp1fndgsc"
    $ubuntuVhd = "$env:LOCALAPPDATA\Packages\CanonicalGroupLimited.Ubuntu22.04LTS_${ubuntuId}\LocalState\ext4.vhdx"
    if (Test-Path $ubuntuVhd) {
        $sizeBefore = (Get-Item $ubuntuVhd).Length / 1GB
        Write-Host "Ubuntu WSL disk: $([math]::Round($sizeBefore, 1)) GB - compacting..." -ForegroundColor Gray
        if (Get-Command Optimize-VHD -ErrorAction SilentlyContinue) {
            Optimize-VHD -Path $ubuntuVhd -Mode Full
            $sizeAfter = (Get-Item $ubuntuVhd).Length / 1GB
            $saved = $sizeBefore - $sizeAfter
            Write-Host "  $([math]::Round($sizeBefore, 1)) GB -> $([math]::Round($sizeAfter, 1)) GB (saved $([math]::Round($saved, 1)) GB)" -ForegroundColor Green
        } else {
            Write-Warning "Optimize-VHD not available. Enable Hyper-V tools or use diskpart."
        }
    }

    Write-Host ""
    Write-Host "Starting WSL again..."
    wsl -d Ubuntu-22.04 echo "WSL started"
} else {
    Write-Host ""
    Write-Host "Tip: Run '.\cleanup.ps1 -Compact' as admin to also shrink WSL virtual disks." -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "Done!" -ForegroundColor Green
