#!/usr/bin/env bash

# ----------------------------------------------------------------------------------------
#
# Autor:              : Fernando Souza - https://www.youtube.com/@fernandosuporte/
# Projeto             : sway-conf
# Script:             : random_wallpaper_sway.sh
# Descrição           : Alterar papel de parede aleatoriamente a cada X minutos no Sway.
# Versão              : 1.0
# Licença             : MIT
# Data                : 15/07/2025 11:50:22
# Data da atualização :
# Atualização em      : https://github.com/tuxslack/sway-conf
#
# Requisitos          : yad  sway swaybg sed find killall xdg-user-dir shuf sleep grep
#
# ----------------------------------------------------------------------------------------


# Alterar o papel de parede a cada X minutos no Sway

# Script simples para radomizar wallpapers.

# Mas só vai funcionar se usar o swaybg e colocar o wallpaper lá no arquivo de 
# configuração do sway:

# Por exemplo:

# output "*" bg /caminho/pasta/wallpapers/img.png fill

# Tem que ser exec_always (que executa novamente depois de recarregar) e não exec (que só 
# executa durante a inicialização).


# Obs: Criar um path na pasta $HOME para o script.

# Cada usuário deve pode altera o tempo do loop separadamente.

# Para verificar o path: 

# echo $PATH


# exec_always --no-startup-id /usr/local/bin/random_wallpaper_sway.sh

# Esse comando garante que o script seja executado toda vez que você iniciar uma nova 
# sessão do Sway.



# Alternativa configura o wallpaper com Azote

# O Azote não tem uma opção direta de "wallpaper aleatório".


# Verifique o log de erros:

# Se o comando não está funcionando como esperado, talvez seja interessante verificar se 
# há mensagens de erro ou advertências nos logs do swaybg para mais detalhes sobre o que 
# está acontecendo.


# https://plus.diolinux.com.br/t/alterar-o-papel-de-parede-a-cada-x-minutos-no-sway/63444/2


clear

# set -e
# set -u
# set -x  # Habilite para ver comandos executados

# ----------------------------------------------------------------------------------------

# 🎨 Modos disponíveis para --mode


# A opção --mode no swaybg controla como a imagem de fundo (papel de parede) será ajustada 
# à tela. Ela funciona de forma semelhante ao que você vê em ambientes gráficos como GNOME 
# ou KDE (estilo "Preencher", "Centralizar", "Expandir", etc.).


# Modo                            Descrição

# stretch Estica a imagem para preencher a tela inteira (pode distorcer a imagem).                 - Esticar (pode distorcer)
# fill    Redimensiona a imagem para preencher a tela sem distorcer (corta partes, se necessário). - Preencher sem distorcer (o mais usado)
# fit     Redimensiona a imagem para caber na tela sem cortes (pode haver bordas).
# center  Centraliza a imagem na tela, sem redimensionar. Pode deixar muito espaço ao redor.       - Centralizar sem redimensionar
# tile    Repete a imagem em mosaico para preencher toda a tela.

# Definir um modo padrão

modo="fill"

# ----------------------------------------------------------------------------------------


# Arquivo de log

log="/tmp/random_wallpaper_sway.log"



# Para monitorar o arquivo de log:

# tail -f /tmp/random_wallpaper_sway.log




# O problema está no tipo de sinal usado.

# ⚠️ Problema:

# Você usou:

# killall -9 random_wallpaper_sway.sh

# O sinal -9 (também conhecido como SIGKILL) mata o processo de forma forçada e imediata, 
# sem dar chance ao script de:

#     executar trap

#     fazer qualquer limpeza

#     remover o lockfile

# ✅ Solução:

# Use SIGTERM (sinal padrão) ou SIGINT em vez de SIGKILL. Por exemplo:

# killall random_wallpaper_sway.sh

# Ou, se quiser ser explícito:

# killall -15 random_wallpaper_sway.sh

# Esse sinal permite que o script finalize normalmente e o trap "rm -f $lockfile" EXIT 
# seja executado, removendo o lockfile.

# 🧠 Resumo dos sinais:

# Sinal	Nome	O que faz	trap funciona?

# 15	SIGTERM	Finalização normal (padrão do kill)	✅ Sim
# 2	    SIGINT	Interrupção (ex: Ctrl+C)        	✅ Sim
# 1	    SIGHUP	Hangup (ex: terminal fechado)   	✅ Sim
# 9	    SIGKILL	Mata imediatamente	                ❌ Não


# ✅ Alternativas para garantir limpeza:

#    Use kill com sinais mais suaves, como SIGTERM.

#    Verifique no início do script se o PID do lockfile ainda está vivo (mais robusto que 
# só checar existência do arquivo). Quer ver esse modelo também?




# ----------------------------------------------------------------------------------------

# Definindo o intervalo de tempo em minutos (substitua X por um valor de sua escolha)

# Dicas extras:

#  Evite intervalos muito curtos (menos de 5 min), pode acabar ficando cansativo ou até 
# sobrecarregar o sistema dependendo do método usado.


# Define o intervalo de tempo em minutos.

# Para converter horas em segundos, basta multiplicar o valor por 3600, pois:

#    ✅ 1 hora = 60 minutos × 60 segundos = 3600 segundos


tempo=5  # Alterar a cada 5 minutos (modifique conforme necessário)



# Definindo tempo como 5, e depois multiplicando esse valor por 60 para convertê-lo em 
# segundos, que é o que o comando sleep usa. Ou seja, 5 * 60 = 300, então o processo vai 
# "dormir" por 300 segundos — exatamente 5 minutos. ⏳

    # espera=$(echo "$tempo * 60" | bc) # Converte o intervalo para segundos

    # sleep $espera 

    # sleep $(($tempo*60))



    # Converte para segundos e dorme (Espera)

    # É uma substituição aritmética que multiplica o valor por 60.

    # O sleep sempre espera o tempo em segundos.

tempo=$(($tempo*60))

# O valor da variável $tempo deve esta em minutos para ser multiplicado por 60.

# 1 minuto  =  1 *   60 =   60 segundos
# 5 minutos =  5 *   60 =  300 segundos
# 1 hora    = 60 *   60 = 3600 segundos
# 2 horas   =  2 * 3600 = 7200 segundos


# 300 segundos equivalem a:

# 300 ÷ 60 = 5 minutos


# Para converter horas em segundos

# 1 hora = 3.600 segundos

# 2 horas = 2 × 3.600 = 7.200 segundos

# 0,5 hora (meia hora) = 0,5 × 3.600 = 1.800 segundos

# ----------------------------------------------------------------------------------------

  # Verifica se o yad esta instalado

  if ! command -v yad >/dev/null 2>&1; then

    echo -e "\n\033[1;31mYad não encontrado.\033[0m\n"

    exit 1

  fi

# ----------------------------------------------------------------------------------------

# Verificar dependências

for cmd in "notify-send" "mako" "sway" "swaybg" "sed" "find" "killall" "xdg-user-dir" "shuf" "sleep" "grep" ; do

    command -v "$cmd" &>/dev/null || {

        echo -e "\n\033[1;31mDependência faltando: $cmd.\033[0m\n"

        yad --center --image="error" --title "Erro" --text "Dependência faltando: $cmd." --buttons-layout=center --button="Fechar:1" --width="400" --height="150"

        exit 1

    }

done

# ----------------------------------------------------------------------------------------


# Verifica se o compositor Wayland atual suporta o protocolo layer-shell (necessário para o swaybg);

# Só executa o comando de troca de papel de parede se for compatível;


# Verifica se estamos sob uma sessão Wayland

if [ -z "$WAYLAND_DISPLAY" ]; then

    echo -e "\n\033[1;31mErro: Esta sessão não parece ser Wayland. \033[0m\n"

    yad --center --image="error" --title "Erro" --text "Esta sessão não parece ser Wayland." --buttons-layout=center --button="Fechar:1" --width="400" --height="150"

    exit 1

fi


# Verifica se o compositor suporta layer-shell

if ! loginctl show-session $(loginctl | grep "$(whoami)" | awk '{print $1}') -p Type | grep -q "wayland"; then

    echo -e "\n\033[1;31mErro: O compositor atual não é compatível com Wayland. \033[0m\n"

    yad --center --image="error" --title "Erro" --text "O compositor atual não é compatível com Wayland." --buttons-layout=center --button="Fechar:1" --width="400" --height="150"

    exit 1
fi


# Lista de compositores conhecidos que funcionam com swaybg

COMPAT_COMP=("sway" "labwc" "wayfire" "Hyprland" "river")


# Detecta compositor atual

CURRENT_COMPOSITOR=$(pgrep -a -u "$USER" -f -l "sway|labwc|wayfire|hyprland|river" | awk '{print $2}' | head -n1)


if [[ ! " ${COMPAT_COMP[@]} " =~ " ${CURRENT_COMPOSITOR,,} " ]]; then

    echo -e "\n\033[1;31mErro: Compositor '${CURRENT_COMPOSITOR}' não é compatível ou não identificado. \033[0m\n"

    yad --center --image="error" --title "Erro" --text "Compositor '${CURRENT_COMPOSITOR}' não é compatível ou não identificado." --buttons-layout=center --button="Fechar:1" --width="400" --height="150"

    exit 1
fi


# ----------------------------------------------------------------------------------------

# Garantir que nunca haja duas instâncias do script random_wallpaper_sway.sh ao mesmo tempo.


lockfile="/tmp/random_wallpaper_sway.lock"

if [ -e "$lockfile" ]; then

    echo -e "\n\033[1;31mO script $0 já está em execução. Encerrando esse para evitar duplicidade.\n\npkill -f random_wallpaper_sway.sh\033[0m\n"

    sleep 1

    echo -e "\nO script $0 já está em execução. Encerrando esse para evitar duplicidade.\n\npkill -f random_wallpaper_sway.sh\n" > "$log"


notify-send -i "/usr/share/icons/gnome/256x256/apps/preferences-desktop-wallpaper.png" \
"Alteração de papel de parede no Sway" \
"\nO script $0 já está em execução. Encerrando esse para evitar duplicidade.\n\npkill -f random_wallpaper_sway.sh\n"


    ps -aux | grep random_wallpaper_sway.sh | grep -v grep | tee -a "$log"

    exit 0

fi

touch "$lockfile"


# Faz com que o lockfile seja removido automaticamente quando o script terminar de forma 
# limpa e segura.

trap "rm -f $lockfile" EXIT



# Explicando parte por parte:

# 🔹 trap

# O comando trap serve para capturar sinais do sistema (como EXIT, SIGINT, SIGTERM, etc.) 
# e executar algum comando quando eles forem recebidos.

# 🔹 "rm -f $lockfile"

# É o comando que será executado quando o script terminar: ele remove o arquivo de lock 
# (/tmp/random_wallpaper_sway.lock, por exemplo).

# 🔹 EXIT

# Esse é o sinal especial que o shell emite automaticamente quando o script está prestes 
# a sair — seja por término normal, erro, exit, Ctrl+C, ou outros motivos.


# 📌 Para que serve isso no contexto do lockfile?

# O lockfile impede que mais de uma instância do script rode ao mesmo tempo. Mas se o 
# script for encerrado sem limpar esse arquivo, ele pode bloquear execuções futuras mesmo 
# que nada esteja rodando.

# A linha trap "rm -f $lockfile" EXIT garante que:

#     Mesmo que o script seja encerrado com erro ou manualmente...

#     ...o arquivo de lock será removido automaticamente.



# Para verificar:

# ps aux | grep random_wallpaper_sway.sh | grep -v grep


# Script em execução:

# $ ps aux | grep random_wallpaper_sway.sh | grep -v grep
# fernando  8699  0.1  0.0   7052  3324 pts/3    S+   20:26   0:00 /bin/bash ./random_wallpaper_sway.sh


# ----------------------------------------------------------------------------------------

# Verifica se tempo é um número inteiro positivo

if ! [[ "$tempo" =~ ^[0-9]+$ ]]; then

        echo -e "\n\033[1;31mErro: tempo deve ser um número inteiro positivo representando minutos.\033[0m\n"

        yad --center --image="error" --title "Erro" --text "tempo deve ser um número inteiro positivo representando minutos." --buttons-layout=center --button="Fechar:1" --width="600" --height="150"

        exit 1

fi

# ----------------------------------------------------------------------------------------

# Caminho onde estão os wallpapers

# Obtém o diretório de imagens do usuário

# Garante que o script não quebre se xdg-user-dir não estiver disponível.

WALL_PATH=$(xdg-user-dir PICTURES 2>/dev/null || echo "$HOME/Imagens") # Se xdg-user-dir falhar, usa ~/Imagens como padrão.


# ----------------------------------------------------------------------------------------

# Caminho do arquivo de configuração do Sway

SWAY_CONFIG="$HOME/.config/sway/config"


# Verificar se o arquivo de configuração do Sway existe

if [ ! -f "$SWAY_CONFIG" ]; then


    # Exibe um diálogo de erro usando yad caso o arquivo não exista

    yad --center --image="error" --title "Erro" --text "Erro: O arquivo de configuração do Sway não foi encontrado em $SWAY_CONFIG. Verifique se o Sway está instalado corretamente." --buttons-layout=center --button="Fechar:1" --width="400" --height="150"

    exit 2
fi

# ----------------------------------------------------------------------------------------

# Verificar se o Sway está em execução

# Antes de executar o swaybg, é necessário garantir que o Sway está rodando.

# if ! pgrep -x "sway" > /dev/null; then

    # Se o Sway não estiver rodando, você verá a mensagem:

#     echo -e "\nErro: O Sway não está em execução. Certifique-se de que o Sway está rodando e tente novamente.\n"

    # Exibe um diálogo de erro usando yad

#     yad --center --image="error" --title "Erro" --text "Erro: O Sway não está em execução. Certifique-se de que o Sway está rodando e tente novamente." --buttons-layout=center --button="Fechar:1" --width="400" --height="150"


#     exit 3

# fi


# ----------------------------------------------------------------------------------------

# Verificar se o swaybg está em execução

# O swaybg é utilizado para definir o papel de parede no Sway (um compositor Wayland).


# if ! pgrep -x "swaybg" > /dev/null; then

    # Exibe um diálogo de erro usando yad se o swaybg não estiver rodando

    # yad --center --image="error" --title "Erro" --text "Erro: O swaybg não está em execução. Certifique-se de que o swaybg está rodando e tente novamente." --button="Fechar:1" --width="400" --height="150"

    # exit 4

# fi


# ----------------------------------------------------------------------------------------

# Verifica se essa opção está descomentada no arquivo ~/.config/sway/config

# output "*" bg "/home/master/Imagens/wallpapers-BigLinux/robot16.avif" fill

    # Verifica e descomenta a linha do wallpaper, se necessário (funcionando)

    # sed -i '/^#.*output "\*".*bg/s/^#//g' "$SWAY_CONFIG"




  # Verifica se o Azote está instalado

  if command -v azote >/dev/null 2>&1; then

    echo -e "\n\033[1;31mAzote encontrado.\033[0m\n"

    # Comentar qualquer linha que contenha o texto ~/.azotebg:

    # sed -i '/~\/\.azotebg/s/^/#/' "$SWAY_CONFIG"


    # Resultado no arquivo ~/.config/sway/config

    ##exec_always --no-startup-id ~/.azotebg &

  fi


# Verificação:

# Para confirmar se a linha foi comentada corretamente, podemos consultar o arquivo após o comando:

# grep "~/.azotebg" ~/.config/sway/config


sleep 2

clear

# ----------------------------------------------------------------------------------------

# Laço infinito para mudar o wallpaper continuamente



# Removendo o arquivo de log

rm "$log" 2> /dev/null


echo "

Configurado para altera o papel de parede a cada $tempo segundo(s).

" > "$log"


# Início do loop

while true; do


    # echo "Executando tarefa em: $(date +%d/%m/%Y_%H:%M:%S)" >> "$log"


    # Seleciona um novo wallpaper aleatório

    # NEW_WP=$(ls "$WALL_PATH" | shuf -n 1)


# Vantagens:

#     Simples e direto, ideal se você tiver apenas arquivos não recursivos (apenas na pasta especificada, sem subpastas).

#     Mais rápido, pois ele não faz uma busca recursiva.

# Desvantagens:

#     Só vai pegar arquivos que estão diretamente na pasta especificada. Ou seja, se houver subpastas dentro de $WALL_PATH, elas não serão incluídas.

#     Não é muito flexível se você deseja lidar com subpastas ou organizar seus wallpapers em diferentes pastas.


    # Seleciona um arquivo aleatório na pasta

    # NEW_WP=$(find "$WALL_PATH" -type f | shuf -n 1)

    NEW_WP=$(find "$WALL_PATH" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" -o -iname "*.tiff" -o -iname "*.avif" -o -iname "*.heic" \) | shuf -n 1)


# Vantagens:

#     Busca recursiva: Vai encontrar todos os arquivos dentro da pasta $WALL_PATH, incluindo aqueles em subpastas.

#     Mais flexível e robusto se você tiver wallpapers organizados em várias pastas e quiser garantir que todos os arquivos (independente da subpasta) sejam considerados.

#     Você pode até adicionar filtros para buscar apenas tipos específicos de arquivo (exemplo: -name "*.jpg" ou -name "*.png").

# Desvantagens:

#     Um pouco mais lento que o ls, pois precisa percorrer todo o diretório e suas subpastas.

#     Exige mais processamento se você tiver uma estrutura de pastas muito grande.



# shuf -n 1: Seleciona aleatoriamente um arquivo da lista resultante.


    # Define o caminho completo para o novo wallpaper

    # NEW_WALL="$WALL_PATH/$NEW_WP"

    NEW_WALL="$NEW_WP"


    # echo -e "\nNovo wallpaper: $NEW_WALL \n"

    echo -e "\nNovo wallpaper ($(date +%d/%m/%Y_%H:%M:%S)): $NEW_WALL \n" >> "$log"


    # Para colocar a parte "Novo wallpaper:" em verde e negrito

    echo -e "\n\033[1;32mNovo wallpaper ($(date +%d/%m/%Y_%H:%M:%S)):\033[0m $NEW_WALL \n"


    # Atualiza a configuração no arquivo de configuração do Sway

    # sed -i "s|^output \"\*\" bg .*$|output \"*\" bg $NEW_WALL fill|" "$SWAY_CONFIG"


   # Não está alterando o papel de parede no arquivo ~/.config/sway/config

   # output "*" bg "/home/master/Imagens/wallpapers-BigLinux/robot16.avif" fill

# ----------------------------------------------------------------------------------------


    # Reinicia o swaybg

    # killall -9 swaybg ; swaybg -o "*" -i "$NEW_WALL" -m fill &


# É um log do Sway indicando que ele encontrou a configuração correta para o display HDMI-A-1.

# 2025-07-14 20:46:04 - [main.c:282] Found config * for output HDMI-A-1 (LG Electronics LG HDR WFHD 0x0001C1F6)


# Executa o swaybg para definir um papel de parede, e depois filtra a saída para ocultar 
# mensagens que contenham "Found config".


# Reinicia o swaybg para aplicar o novo wallpaper


# Mata instâncias anteriores do swaybg

# Verifica se há um processo exatamente chamado swaybg rodando.

if pgrep -x "swaybg" > /dev/null; then

    # Se o swaybg estiver rodando, você verá a mensagem:

    # echo -e "\n\033[1;31mO swaybg está em execução. Matando...\033[0m\n"

    # killall swaybg 2>/dev/null

    # killall -9 swaybg


    #🔹 Uso de pkill em vez de killall -9

    # Mais seguro e elegante, permite finalizar o swaybg corretamente com SIGTERM.

    # Envia o sinal TERM para matar o processo swaybg.

    pkill -TERM swaybg

fi


    # Define o papel de parede

    swaybg -o "*" -i "$NEW_WALL" -m "$modo" 2>&1 | grep -v "Found config" &



# O comando "killall -9 swaybg" pode estar terminando o processo do swaybg se ele já 
# estiver em execução. Isso é necessário para garantir que o novo papel de parede seja 
# aplicado corretamente.




# Executar o swaybg

# Para usá-lo, você deve especificar um arquivo de imagem que será definido como o fundo 
# da sua tela. O comando básico para rodar o swaybg é:

# swaybg -i /caminho/para/imagem.jpg -m fill


# Explicando os parâmetros:


# -o <output>: Especifica a saída (monitor ou display) onde o papel de parede será definido.

#    Exemplo: -o DP-1, -o HDMI-A-1, ou -o eDP-1, dependendo da sua configuração de display.


# Aplicar o papel de parede a todas as saídas:

# Se você quiser que o mesmo papel de parede seja exibido em todos os monitores, você pode 
# usar o caractere curinga *, que aplica o papel de parede a todas as saídas disponíveis.

# -o "*"


#     -i /caminho/para/imagem.jpg: Define a imagem que será usada como papel de parede. 
# Substitua /caminho/para/imagem.jpg pelo caminho real da imagem que você deseja usar.



# -m <mode>: O modo de exibição da imagem. Pode ser:


#    fill: A imagem é esticada para cobrir toda a tela (pode distorcer a imagem).

# Define o modo de exibição da imagem. O modo fill faz com que a imagem seja esticada para 
# cobrir toda a tela.


#    fit: A imagem é redimensionada para se ajustar à tela sem cortar ou distorcer.


# Papel de parede centralizado:

#    center: A imagem é centralizada sem redimensionamento.

# swaybg -i ~/Imagens/minha_imagem.jpg -m center


# Papel de parede esticado:

#    stretch: A imagem é esticada para cobrir a tela, mas pode ser distorcida.

# swaybg -i ~/Imagens/minha_imagem.jpg -m stretch


# ----------------------------------------------------------------------------------------

    # Espera o tempo

    sleep $tempo


done


# Fim do loop


# ----------------------------------------------------------------------------------------

exit 0


