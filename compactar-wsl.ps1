# Fecha todas as distribuições WSL
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
wsl --shutdown

Start-Sleep -Seconds 5

# Ajuste aqui o nome da sua distro!
$distroFolder = "CanonicalGroupLimited.Ubuntu22.04LTS_79rhkp1fndgsc"

# Caminho do VHDX
$VhdPath = "C:\Users\SEU_USUARIO\AppData\Local\Packages\$distroFolder\LocalState\ext4.vhdx"

# Verifica se o arquivo VHDX existe
if (Test-Path $VhdPath) {
    Write-Output "Compactando o disco VHDX com Optimize-VHD..."
    Optimize-VHD -Path $VhdPath -Mode Full
    Write-Output "Compactação finalizada!"
} else {
    Write-Output "Arquivo VHDX não encontrado no caminho informado: $VhdPath"
}

# Opcional: reinicia o WSL automaticamente
wsl
