# 🐳🔧 WSL2 Docker VHDX Compactador

Otimização e compactação automática do disco WSL2 utilizado pelo Docker para liberar espaço no Windows! 🚀

---

# ❓ O que é este projeto?

Quando você usa **Docker** dentro do **WSL2** (Windows Subsystem for Linux), o Docker cria **containers**, **imagens** e **volumes** dentro do sistema de arquivos Linux.

Esses dados ficam armazenados em um **arquivo de disco virtual** chamado `ext4.vhdx`.

🛑 **Problema:**  
Mesmo apagando imagens e containers, o arquivo `.vhdx` **não diminui automaticamente** — ele continua inflado, desperdiçando espaço no seu HD!

---

# 📚 Metáfora Simples

Imagine o WSL2 como uma **caixa de papelão**. 📦  
Você joga coisas dentro (containers, imagens).  
Mesmo se esvaziar, **o tamanho da caixa não muda**!

O `.vhdx` funciona do mesmo jeito.  
Para diminuir a caixa, **você precisa "amassar"** — ou seja, compactar manualmente!

---

# 🎯 Porque isso acontece tecnicamente?

- O sistema de arquivos Linux (`ext4`) **marca espaço como livre**, mas **não remove fisicamente** os dados do VHDX.
- O Windows **não reduz automaticamente** o tamanho do VHDX para evitar impacto na performance.
- Sem intervenção manual, o espaço é desperdiçado com "dados fantasma".

---

# 📦 Objetivo deste projeto

- Instalar o Hyper-V para ter acesso ao comando `Optimize-VHD`.
- Compactar o disco `.vhdx` do WSL2 para economizar espaço.

---

# ✅ Pré-requisitos

- Windows 11 Pro 24H2 (ou superior).
- Virtualização habilitada na BIOS (Intel VT-x / AMD-V).
- Acesso de Administrador.

🔍 **Importante:**
> Este projeto foi testado e validado no **Windows 11 Pro 24H2**.  
> Outras versões podem funcionar, mas não foram testadas oficialmente.
---

# 🔍 Encontrando o caminho correto do VHDX

Cada instalação de WSL2 cria uma pasta diferente no Windows.  
**Você precisa identificar qual pasta corresponde à sua distribuição instalada!**

📁 Como localizar:
1. Abra o Explorador de Arquivos.
2. Navegue até:

```plaintext
C:\Users\SEU_USUARIO\AppData\Local\Packages\
```
🔵 Atenção:

>Onde está escrito SEU_USUARIO, você deve substituir pelo nome de usuário da máquina em que está utilizando.    
>Exemplo: se seu nome de usuário for aneto, o caminho correto seria C:\Users\aneto\AppData\Local\Packages\.

3. Procure o nome da sua distribuição, exemplos:
    - `CanonicalGroupLimited.Ubuntu_79rhkp1fndgsc`
    - `CanonicalGroupLimited.Ubuntu22.04LTS_79rhkp1fndgsc`
    - `TheDebianProject.DebianGNULinux_...`
    - etc.

4. Dentro da pasta correta, localize:

```plaintext
LocalState\ext4.vhdx
```

**Esse é o arquivo que será compactado!**

---

# 🔥 Instalação do Hyper-V pelo Terminal (PowerShell)

1. Abra o **PowerShell como Administrador**.
2. Rode:

```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
```

3. Reinicie o computador.
4. Após o reboot, verifique:

```powershell
Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V
```

Deve aparecer `State : Enabled`.

---

# 🛠️ Como usar o Script de Compactação (.ps1)

Este script:
- Encerra o WSL2.
- Compacta o arquivo `.vhdx`.
- Reinicia o WSL2 automaticamente.

### 📄 Código do Script `compactar-wsl.ps1`

```powershell
# Fecha todas as distribuições WSL
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
```

---

# ⚡ Como executar o script

1. Salve o código como `compactar-wsl.ps1`.
2. Rode via PowerShell:

```powershell
& "C:\caminho\para\seu\arquivo\compactar-wsl.ps1"
```

(Coloque o caminho entre aspas se houver espaços.)

---

# 🚨 Possível problema: Política de Execução

Se for a primeira vez rodando `.ps1`, talvez você precise liberar:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

---


# 📋 Resumo de Benefícios

- Recupera espaço perdido no disco.
- Deixa o WSL2 mais leve e rápido.
- Evita crescimento infinito do arquivo VHDX.
- Manutenção simples para ambientes de desenvolvimento com Docker.

---

# 🙌 Créditos

Projeto idealizado e implementado por [Alcides Neto](https://github.com/aneto10) - Inspirado nas melhores práticas recomendadas pela Microsoft e pela Docker para gerenciamento de espaço em ambientes Docker + WSL2.   
Agradecimentos especiais ao ChatGPT da OpenAI, utilizado como ferramenta de apoio para brainstorming, organização e geração de conteúdo técnico.


---
# 📚 Fontes / Referências Técnicas

- [Microsoft Docs - Gerenciar espaço de disco no WSL2](https://learn.microsoft.com/en-us/windows/wsl/filesystems#managing-disk-space)
- [Microsoft Docs - Compactar discos VHD usando Optimize-VHD](https://learn.microsoft.com/en-us/powershell/module/hyper-v/optimize-vhd)

- [Docker Docs - Pruning Docker Objects (system prune, volume prune)](https://docs.docker.com/config/pruning/)
