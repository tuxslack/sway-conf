#!/bin/bash

# Arquivo .desktop para reiniciar o Sawy com notificação para informar ao usuário sobre 
# a ação.


# Com isso:

#    O nome, descrição e palavras-chave do atalho aparecem no idioma do usuário (pt/en/es).

#    As notificações também aparecem traduzidas dinamicamente.

#    O script funciona de forma portátil com base na variável LANG.

# 💡 Esse script cobre pt, en, es, fr, de — e usa inglês como fallback.


# /usr/share/applications/restart-sway.desktop


clear

# Detecta o idioma principal (ex: "pt" de "pt_BR.UTF-8")

LANGUAGE=$(echo "$LANG" | cut -d_ -f1)

# echo "$LANGUAGE"


# Define mensagens traduzidas

case "$LANGUAGE" in
  pt)
    TITLE="Reiniciando o Sway..."
    BODY="Aguarde alguns segundos."
    ;;
  en)
    TITLE="Restarting Sway..."
    BODY="Please wait a few seconds."
    ;;
  es)
    TITLE="Reiniciando Sway..."
    BODY="Espere unos segundos."
    ;;
  fr)
    TITLE="Redémarrage de Sway..."
    BODY="Veuillez patienter quelques secondes."
    ;;
  de)
    TITLE="Sway wird neu gestartet..."
    BODY="Bitte warten Sie einen Moment."
    ;;
  *)
    TITLE="Restarting Sway..."
    BODY="Please wait a few seconds."
    ;;
esac


# Envia notificação

# notify-send -t 7000 -i "/usr/share/icons/hicolor/96x96/actions/xfsm-reboot.png" "$TITLE" "$BODY"

notify-send -t 7000 -i "/usr/share/icons/extras/Sway.png" "$TITLE" "$BODY"


# Para testar ícones disponíveis no seu sistema:

# ls /usr/share/icons/hicolor/*/apps/


# Verifique quais ícones estão disponíveis

# Você pode listar os ícones disponíveis com:

# find /usr/share/icons/ -name "*.png" | grep reboot


# Ou listar ícones genéricos:

# find /usr/share/icons/ -name "*.png" | grep system


# Recarrega configuração do sway (não reinicia sessão)

swaymsg reload


exit 0

