# Shrink-UbuntuWSL.ps1

# --- Locate your Ubuntu VHDX ---



$id = "79rhkp1fndgsc"
$VhdPath = "$env:LOCALAPPDATA\Packages\CanonicalGroupLimited.Ubuntu22.04LTS_${id}\LocalState\ext4.vhdx"
# C:\Users\Martin\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu22.04LTS_79rhkp1fndgsc\LocalState\ext4.vhdx

# --- Stop WSL ---
Write-Host "Shutting down WSL..."
wsl --shutdown

# --- Optimize VHD ---
if (Get-Command Optimize-VHD -ErrorAction SilentlyContinue) {
    Write-Host "Optimizing $VhdPath ..."
    Optimize-VHD -Path $VhdPath -Mode Full
    Write-Host "✅ Done!"
} else {
    Write-Warning "❌ Optimize-VHD not found. Please enable Hyper-V tools."
}
