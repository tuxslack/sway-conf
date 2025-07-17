#!/bin/bash
#
# Autor:           Fernando Souza - https://www.youtube.com/@fernandosuporte/
# Data:            20/06/2025-18:53:24
# Atualização em:  https://github.com/tuxslack/mako
# Script:          alternador-de-tema-mako.sh
# Versão:          0.1
# 
#
# Data da atualização:  
#
# Licença:  MIT
# 
#
# Requer: yad find mako makoctl cut sort notify-send


# Script em Bash que usa o yad (Yet Another Dialog) para gerenciar os temas 
# do Mako (notificador do Wayland) localizados em ~/.config/mako/.


# https://catppuccin.com/
# https://github.com/catppuccin




# Crie o arquivo .pot:

# xgettext -L Shell --from-code=UTF-8 -o alternador-de-tema-mako.pot alternador-de-tema-mako.sh


# ⚠️ Importante:

#    Certifique-se de que seu arquivo .sh está salvo com a mesma codificação, normalmente UTF-8.

# Criar arquivo .po a partir do .pot

# msginit --locale=pt_BR.UTF-8 --input=alternador-de-tema-mako.pot --output=alternador-de-tema-mako.po

# Compilar .po para .mo

# msgfmt alternador-de-tema-mako.po -o /usr/share/locale/pt_BR/LC_MESSAGES/alternador-de-tema-mako.mo


# Se você criou o .po manualmente, o .mo deve ser gerado assim:

# msgfmt -o /usr/share/locale/pt_BR/LC_MESSAGES/alternador-de-tema-mako.mo  alternador-de-tema-mako.po

# Define o diretório de localização e domínio de mensagens

TEXTDOMAIN=alternador-de-tema-mako
TEXTDOMAINDIR="/usr/share/locale"

export TEXTDOMAIN=alternador-de-tema-mako
export TEXTDOMAINDIR=/usr/share/locale

# export LANG=pt_BR.UTF-8


# 📌 Limitações comuns com mako (Wayland notification daemon)

#     Tamanho máximo da notificação (altura/largura)

#         O conteúdo (mensagem) que ultrapassa essas dimensões pode ser truncado ou cortado visualmente.

#         Isso é controlado pelas opções de estilo/configuração do mako.

#     Limite de notificações empilhadas

#         Por padrão, o mako pode exibir apenas um certo número de notificações simultâneas (ex: 3).

#         Notificações novas podem substituir ou ocultar as antigas, dependendo da configuração.

#     Não há rolagem (scroll)

#         mako não suporta notificações roláveis: se for muito longa, simplesmente some da tela ou é cortada.



# Aumente o tamanho da notificação no arquivo: ~/.config/mako/config

# Ex: 

# max-visible=30

# Aumente "width" e "height" conforme necessário.

# width=400
# height=1000


clear

# ----------------------------------------------------------------------------------------

ajuda(){

    message=$(gettext 'Copy or move the content of your chosen version of themes/ to %s')


yad --center --title="✅ $(gettext 'Theme for Mako')" --text="
$(gettext 'Installation'):


cd ~/

git clone https://github.com/tuxslack/mako.git

cd mako/

mkdir -p $HOME/.config/mako/


$(printf "$message" "$HOME/.config/mako/config")

mv -i themes/* $HOME/.config/mako/

alternador-de-tema-mako.sh


https://github.com/catppuccin/mako" \
--buttons-layout=center \
--button="$(gettext 'OK')":0

}


# ----------------------------------------------------------------------------------------

    message=$(gettext 'Error: Command %s not found.')


for cmd in yad find mako makoctl cut sort notify-send; do

  command -v "$cmd" >/dev/null 2>&1 || { echo "$(printf "$message" "$cmd")" >&2;  yad --center --title="❌ $(gettext 'Theme for Mako')" --text="$(printf "$message" "$cmd")" --buttons-layout=center --button="$(gettext 'OK')":0 ; exit 1; }

done

# ----------------------------------------------------------------------------------------

# Verificar se a pasta existe

if [ ! -d "$HOME/.config/mako" ]; then

    # A mensagem será exibida apenas se a pasta não existir

    echo -e "\n$(gettext 'The ~/.config/mako directory does NOT exist.') \n"

    ajuda

    clear

    exit 

fi

# ----------------------------------------------------------------------------------------

yad --center --title="✅ $(gettext 'Theme for Mako')" --text="

$(gettext 'Settings'):

$(gettext 'Increase the notification size in the file: ~/.config/mako/config')

$(gettext 'Example'): 

max-visible=30

$(gettext "Increase 'width' and 'height' as needed.")

width=400
height=1000

$(gettext 'Reload the mako with'):

$ makoctl reload
" \
--buttons-layout=center \
--button="$(gettext 'OK')":0



THEMES_DIR="$HOME/.config/mako"
CONFIG_FILE="$THEMES_DIR/config"

# THEMES=$(find "$THEMES_DIR" -maxdepth 1 -type f ! -name "config" -exec basename {} \;)


# Lista arquivos que:
#
# - São arquivos comuns
# - Não se chamam 'config'
# - Não terminam com .sh, .log, .desktop ou .txt


# THEMES=$(find "$THEMES_DIR" -maxdepth 2 -type f \
#     ! -name "config" \
#     ! -name "*.sh" \
#     ! -name "*.txt" \
#     ! -name "*.log" \
#     -exec basename {} \; | sort)


THEMES=$(find "$THEMES_DIR" -maxdepth 2 -type f \
    ! -iname "config" \
    ! -iname "*.desktop" \
    ! -iname "*.sh" \
    ! -iname "install" \
    ! -iname "AUTHORS" \
    ! -iname "Makefile" \
    ! -iname "COPYING" \
    ! -iname "CONTRIBUTORS" \
    ! -iname "Changelog" \
    ! -iname "*.html" \
    ! -iname "FAQ" \
    ! -iname "NEWS" \
    ! -iname "TODO" \
    ! -iname "CREDITS" \
    ! -iname "README" \
    ! -iname "*.txt" \
    ! -iname "*.md" \
    ! -iname "license" \
    ! -iname "*.png" \
    ! -iname "*.jpg" \
    ! -iname "*.svg" \
    ! -iname "*.jpeg" \
    ! -iname "*.py" \
    ! -iname "*.heic" \
    ! -iname "*.avif" \
    ! -iname "*.webp" \
    ! -iname "*.ico" \
    ! -iname "*.gif" \
    ! -iname "*.pdf" \
    ! -iname "*.doc" \
    ! -iname "*.docx" \
    ! -iname "*.log" | sort)

# -maxdepth 1: limita a busca a apenas esse diretório, sem entrar em subpastas.
# Ou seja, só os arquivos e pastas que estão diretamente dentro de THEMES_DIR.

# O -maxdepth 2 faz o find buscar arquivos em até dois níveis de profundidade dentro da pasta $THEMES_DIR.

# Vai pegar os nomes de arquivos listados e ordenar alfabeticamente.

if [ -z "$THEMES" ]; then

    message=$(gettext 'No themes found in %s')

    yad --center --title="$(gettext 'Mako Themes')" --text="❌ $(printf "$message" "$THEMES_DIR")" --buttons-layout=center --button="$(gettext 'OK')":0

    exit 1

fi

# echo "$THEMES"



SELECTED=$( echo "$THEMES" | awk '{ print "🎨 " $0 }' | yad \
    --center \
    --list \
    --separator="|" \
    --title="$(gettext 'Choose Mako Theme')" \
    --column="$(gettext 'Theme')" \
    --buttons-layout=center \
    --button="$(gettext 'Cancel')":1 --button="$(gettext 'OK')":0 \
    --width="800" --height="850")

SELECTED=$(echo "$SELECTED" | cut -d'|' -f1)

# echo "$SELECTED"


if [ -z "$SELECTED" ]; then

    exit 0

fi





# Remove emoji 🎨 para obter o nome do arquivo

SELECTED=$(echo "$SELECTED" | sed 's/^🎨 //')


# Tema: catppuccin-latte-sky

ls -l "$CONFIG_FILE" > "$THEMES_DIR"/tema_antigo.log



# cp "$THEMES_DIR/$SELECTED" "$CONFIG_FILE"

rm -Rf "$CONFIG_FILE"

sleep 1

ln -sf "$SELECTED" "$CONFIG_FILE"


# ls -l "$CONFIG_FILE"
# ls    "$SELECTED"


# Recarregue o mako

makoctl reload


SELECTED="$(basename "$SELECTED")"


# Não traduziu

# Ex: Theme catppuccin-frappe-yellow applied successfully.

message=$(gettext 'Theme %s applied successfully.')

echo -e "\n$(printf "$message" "$SELECTED") \n"

notify-send "$(gettext 'Theme Test')" "$(gettext 'If you are seeing this notification, the theme is applied.')"

yad --center --title="✅ $(gettext 'Applied theme')" --text="$(printf "$message" "$SELECTED")" --buttons-layout=center --button="$(gettext 'OK')":0


clear

exit 0

