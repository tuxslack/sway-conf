#!/bin/bash

# swaylock

# Um dos bloqueadores de tela mais populares para Wayland.


# Configurar um atalho no seu ~/.config/labwc/rc.xml


# Dica extra: bloqueio automático

# Você pode usar algo como xautolock (em X11) ou ferramentas como swayidle em Wayland para 
# bloquear automaticamente após inatividade.



# Configurar o bloqueio automático com swayidle

# Crie ou edite o seu script de inicialização do labwc, normalmente ~/.config/labwc/autostart:

# pluma ~/.config/labwc/autostart

# Adicione essa linha ao final:

# swayidle -w \
#   timeout 300 '/usr/local/bin/lock_wayland.sh.sh' \
#   timeout 600 'systemctl suspend' \
#   resume '/usr/local/bin/lock_wayland.sh.sh'



# Alternativas ao systemctl suspend no Void Linux:

# swayidle -w \
#   timeout 300 '/usr/local/bin/lock_wayland.sh.sh' \
#   timeout 600 'loginctl suspend' \
#   resume '/usr/local/bin/lock_wayland.sh.sh'


# ⚠️ Certifique-se de que o serviço elogind está em execução:

# sudo sv status elogind

# fail: elogind: unable to change to service directory: file does not exist


#     Isso fará:
# 
#         Bloqueio após 5 minutos (300s) de inatividade
# 
#         Suspensão automática após 10 minutos
# 
#         Rebloqueio ao retornar do modo suspenso



clear


# ----------------------------------------------------------------------------------------


# Função para verificar a existência de comando


verificar(){



# Verifica dependências:


if ! command -v yad >/dev/null 2>&1; then

    echo "O comando yad não esta instalado."

    exit 1

fi



# Lista de comandos a verificar

programas=("swaylock" "swayidle")


# Lista para armazenar os programas ausentes

faltando=()

for prog in "${programas[@]}"; do

    if ! command -v "$prog" >/dev/null 2>&1; then

        faltando+=("$prog")

    fi

done


# Se houver programas ausentes, exibe aviso com yad

if [ ${#faltando[@]} -gt 0 ]; then

    yad --center \
        --window-icon="dialog-warning" \
        --title="Dependências ausentes" \
        --text="❌ Os seguintes comandos não estão instalados:\n\n${faltando[*]}" \
        --buttons-layout=center \
        --button="OK:0" \
        --width="400" --height="200" \
        2>/dev/null

    exit 2

fi


}


verificar


# echo "Todas as dependências estão instaladas ✅"

# ----------------------------------------------------------------------------------------


swaylock

# swaylock -f -i $HOME/.config/sway/wallpapers/lockscreen_wallpaper.jpg

# swaylock -f -c 000000

# ----------------------------------------------------------------------------------------

exit 0

