#!/bin/bash


# Melhor forma de identificar o usuário com sessão gráfica ativa

# Aqui está uma versão refinada do script que:

#     Detecta o usuário com sessão gráfica ativa (Wayland/X11)

#     Usa o diretório correto para .desktop (~/.local/share/applications)

#     Atualiza os bancos de dados .desktop corretamente

# Caso comum:


# O comando update-desktop-database identifica link simbolico?

# O comando update-desktop-database não segue links simbólicos quebrados

# $ update-desktop-database ~/.local/share/applications/
# Could not parse file "/home/maria/.local/share/applications/net.epson.epsonscan2.desktop": No such file or directory

# Significa que o link simbólico está apontando para um arquivo que não existe ou não está 
# acessível no momento.

# $ ls -l /home/maria/.local/share/applications/net.epson.epsonscan2.desktop
# lrwxrwxrwx 1 maria maria 175 abr  8 00:59 /home/maria/.local/share/applications/net.epson.epsonscan2.desktop -> /var/lib/flatpak/app/net.epson.epsonscan2/x86_64/stable/d8e69711e121e6417c76eb6314d738294a4694741b03ed54c60c1283c6974875/export/share/applications/net.epson.epsonscan2.desktop

# $ ls /var/lib/flatpak/app/net.epson.epsonscan2/x86_64/stable/d8e69711e121e6417c76eb6314d738294a4694741b03ed54c60c1283c6974875/export/share/applications/net.epson.epsonscan2.desktop
# ls: não foi possível acessar '/var/lib/flatpak/app/net.epson.epsonscan2/x86_64/stable/d8e69711e121e6417c76eb6314d738294a4694741b03ed54c60c1283c6974875/export/share/applications/net.epson.epsonscan2.desktop': Arquivo ou diretório inexistente

# Verifique se o destino do link simbólico realmente existe:

# ls -l /var/lib/flatpak/app/net.epson.epsonscan2/x86_64/stable/


# O programa foi atualizado e mudou o caminho do link simbólico para o arquivo .desktop

# $ ls -l /var/lib/flatpak/app/net.epson.epsonscan2/x86_64/stable/82970575b7f2f3fda49fa897e511415728be4cec37c4cf22bfa4d2c165ff8e5d/export/share/applications/net.epson.epsonscan2.desktop 
# -rwxr-xr-x 1 root root 400 mai  9 01:23 /var/lib/flatpak/app/net.epson.epsonscan2/x86_64/stable/82970575b7f2f3fda49fa897e511415728be4cec37c4cf22bfa4d2c165ff8e5d/export/share/applications/net.epson.epsonscan2.desktop


# Como cria link simbólico onde o caminho completo do arquivo tem uma variação conforme a 
# atualização do programa Ex: /var/lib/flatpak/app/net.epson.epsonscan2/x86_64/stable/82970575b7f2f3fda49fa897e511415728be4cec37c4cf22bfa4d2c165ff8e5d/export/share/applications/net.epson.epsonscan2.desktop a parte 82970575b7f2f3fda49fa897e511415728be4cec37c4cf22bfa4d2c165ff8e5d sempre varia.


# O Flatpak já cria um link simbólico estável que aponta para a versão ativa de um aplicativo, e você pode usá-lo.

# /var/lib/flatpak/exports/share/applications/net.epson.epsonscan2.desktop


# Solução:

# $ update-desktop-database ~/.local/share/applications/
# Could not parse file "/home/fernando/.local/share/applications/net.epson.epsonscan2.desktop": No such file or directory

# $ rm ~/.local/share/applications/net.epson.epsonscan2.desktop

# $ update-desktop-database ~/.local/share/applications/

# O Wofi já ler direto o arquivo /var/lib/flatpak/exports/share/applications/net.epson.epsonscan2.desktop 
# ou tem que criar um link simbólico em ~/.local/share/applications/

# O Wofi, por padrão, lê os arquivos .desktop dos diretórios padrão do XDG, conforme a 
# variável de ambiente XDG_DATA_DIRS.

# O Flatpak já instala os arquivos .desktop em um local que deve estar incluso por padrão 
# no caminho buscado pelo Wofi, ou seja:
# 🟢 Sim, o Wofi normalmente já lê diretamente de:

# /var/lib/flatpak/exports/share/applications/

# E também:

# ~/.local/share/flatpak/exports/share/applications/

# Esses caminhos fazem parte de XDG_DATA_DIRS, e o Wofi consulta essa variável para montar 
# sua lista de apps.


# ✅ Como confirmar os diretórios usados pelo Wofi

# Execute:

# echo $XDG_DATA_DIRS

# Se a saída incluir /var/lib/flatpak/exports/share e/ou ~/.local/share/flatpak/exports/share, 
# então o Wofi deve encontrar os .desktop do Flatpak automaticamente.

# $ echo $XDG_DATA_DIRS
# /home/maria/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share


# 🛠️ Passo 2: Se esses caminhos não aparecerem

# Se os diretórios do Flatpak não estiverem presentes, você pode corrigi-los editando seu 
# arquivo de ambiente.

# a) Para shells como bash/zsh, adicione ao ~/.profile, ~/.bash_profile, ou ~/.zshenv:

# export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share:/usr/local/share:/usr/share"

#     Dica: Inclua os diretórios padrão /usr/local/share:/usr/share no final para evitar 
# que o resto do sistema fique "invisível".

# Depois disso, reinicie a sessão (ou execute source ~/.profile).


# 🔍 Como verificar se está funcionando

# Você pode testar com:

# $ wofi --show drun

# E procurar por "epson" ou parte do nome do app.


# ❗️Quando o link simbólico é necessário?

# Você só precisa criar um link simbólico em ~/.local/share/applications/ se:

#     Você alterou a variável XDG_DATA_DIRS no seu ambiente e excluiu o diretório /var/lib/flatpak/exports/...;

#     Seu sistema ou ambiente (como uma sessão Wayland personalizada, tiling WM minimalista 
# etc.) não inclui os caminhos do Flatpak por padrão;

#     Você está tentando corrigir um caso específico em que o Wofi (ou outro menu de lançador) 
# não está encontrando o app.



# Como descubrir se a base de dados dos arquivos .dektop esta desatualizada em 
# /usr/share/applications/ para pode usar o comando "update-desktop-database /usr/share/applications"?


# O comando update-desktop-database atualiza a cache de associações MIME e ações adicionais 
# de arquivos .desktop (não o menu em si), mas só precisa ser usado quando esses arquivos 
# contêm certas entradas como MimeType=.

# ✅ Quando é necessário rodar update-desktop-database?

# Você só precisa rodar o comando se:

#  O .desktop define um campo MimeType=.

#  Ou o arquivo foi removido/modificado diretamente em /usr/share/applications/ ou 
# /usr/local/share/applications/ fora do controle do gerenciador de pacotes.

#  Ou se algum programa não aparece nas opções de “Abrir com...”, mesmo estando instalado.


# ❓ Como saber se a base está desatualizada?

# 1. Verifique se há arquivos com MimeType= que não aparecem no sistema

# grep -r MimeType= /usr/share/applications/

# Isso lista os .desktop que precisam de registro. Se você criou/modificou um desses 
# recentemente, pode ser necessário rodar o comando.

# 2. Compare timestamps

# Veja se algum .desktop é mais novo que o banco de dados .cache:

# ls -lt /usr/share/applications/ | head
# ls -l /usr/share/applications/mimeinfo.cache

# Se um arquivo .desktop com MimeType= é mais novo que mimeinfo.cache, pode ser que o 
# banco esteja desatualizado.


# 3. Use desktop-file-validate

# Para verificar se há erros ou avisos nos arquivos .desktop:

# desktop-file-validate /usr/share/applications/*.desktop

# 🧠 Importante:

#    O comando update-desktop-database não atualiza o menu do sistema. Para isso, você 
# geralmente precisa apenas de um gtk-update-icon-cache ou reiniciar o ambiente gráfico 
# (dependendo do sistema).

#    Para arquivos em ~/.local/share/applications/, você não precisa rodar esse comando, 
# a não ser que use MimeType.


# ✅ Quando rodar, use:

# sudo update-desktop-database /usr/share/applications

# Ou:

# update-desktop-database ~/.local/share/applications



# ----------------------------------------------------------------------------------------

clear


# Função: Detecta o usuário com sessão gráfica ativa

get_active_user() {

    # Tenta via loginctl (systemd)

    if command -v loginctl >/dev/null 2>&1; then
        USERNAME=$(loginctl list-sessions --no-legend | awk '$3 == "wayland" || $3 == "x11" { print $2; exit }')
        if [ -n "$USERNAME" ]; then
            echo "$USERNAME"
            return
        fi
    fi

    # Fallback: tenta via processo do sway ou X

    USERNAME=$(ps -eo user,comm | awk '/(sway|X|wayland)/ && $1 != "root" { print $1; exit }')
    echo "$USERNAME"
}

# Detectar usuário com sessão gráfica ativa

ACTIVE_USER=$(get_active_user)

if [ -z "$ACTIVE_USER" ]; then
    echo "❌ Não foi possível detectar um usuário com sessão gráfica ativa."
    exit 1
fi

# Caminho correto para o diretório home

USER_HOME=$(eval echo "~$ACTIVE_USER")
USER_DESKTOP_DIR="$USER_HOME/.local/share/applications"

echo "👤 Sessão gráfica ativa detectada para: $ACTIVE_USER"
echo "📂 Diretório de .desktop: $USER_DESKTOP_DIR"

# ----------------------------------------------------------------------------------------

# Atualizar banco de dados do usuário ativo

if [ -d "$USER_DESKTOP_DIR" ]; then

    echo "🔄 Atualizando banco de dados do usuário..."

    # sudo -u "$ACTIVE_USER" update-desktop-database "$USER_DESKTOP_DIR"


# Executa o comando e captura stderr (erros)

ERROR_OUTPUT=$(sudo -u "$ACTIVE_USER" update-desktop-database "$USER_DESKTOP_DIR" 2>&1)

# Verifica se houve saída de erro

if [ -n "$ERROR_OUTPUT" ]; then

    # Exibe mensagem de erro usando yad

# Executa yad diretamente como o usuário da sessão gráfica

    sudo -u "$ACTIVE_USER" \
         DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u "$ACTIVE_USER")/bus" \
    yad --center \
        --title="Erro ao atualizar desktop database" \
        --width=500 \
        --center \
        --text="Ocorreu um erro ao executar:\nsudo -u "$ACTIVE_USER" update-desktop-database "$USER_DESKTOP_DIR"\n\nErro:\n$ERROR_OUTPUT" \
        --buttons-layout=center \
        --button=Fechar:0 \
        --image=dialog-error

    exit

fi


else
    echo "⚠️ Diretório $USER_DESKTOP_DIR não encontrado."
fi

# ----------------------------------------------------------------------------------------

# Atualizar banco de dados global (requer root)

if [ -d "/usr/share/applications" ]; then

    echo "🔄 Atualizando banco de dados global..."

    # sudo update-desktop-database /usr/share/applications


# Executa o comando e captura stderr (erros)

ERROR_OUTPUT=$(sudo update-desktop-database /usr/share/applications 2>&1)

# Verifica se houve saída de erro

if [ -n "$ERROR_OUTPUT" ]; then

    # Exibe mensagem de erro usando yad

    sudo -u "$ACTIVE_USER" \
         DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u "$ACTIVE_USER")/bus" \
    yad --center \
        --title="Erro ao atualizar desktop database" \
        --width=500 \
        --center \
        --text="Ocorreu um erro ao executar:\nsudo update-desktop-database /usr/share/applications\n\nErro:\n$ERROR_OUTPUT" \
        --buttons-layout=center \
        --button=Fechar:0 \
        --image=dialog-error

    exit

fi



else

    echo "⚠️ Diretório /usr/share/applications não encontrado."

fi

# ----------------------------------------------------------------------------------------

echo "✅ Atualização concluída."

sleep 20


exit 0

