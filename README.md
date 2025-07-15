# sway-conf
Este repositório contém uma série de configurações personalizadas para o Sway, o gerenciador de janelas para Wayland. 

```
1- No arquivo ~/.config/sway/config adiciona:

Script para alterar o papel de parede a cada X minutos no Sway (radomizar wallpapers)

exec_always --no-startup-id /usr/local/bin/random_wallpaper_sway.sh



2- Comenta tudo relacionado ao Azote

Usando o Azote para gerenciar os papeis de parede

exec_always --no-startup-id ~/.azotebg &

```
