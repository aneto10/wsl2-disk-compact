# Instala o Hyper-V no Windows
Write-Output "Instalando Hyper-V..."
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

Write-Output "Instalação finalizada. Reinicie o computador para concluir."