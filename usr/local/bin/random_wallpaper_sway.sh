#!/bin/bash

# ----------------------------------------------------------------------------------------
# Por       : Fernando Souza
# Projeto   : random_wallpaper_sway
# Arquivo   : random_wallpaper_sway.sh
# Descrição : Script simples para mudar wallpaper do Sway aleatoriamente.
# Versão    : 1.0
# Data      : 15/07/2025 11:50:22
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


# Arquivo de log

log="/tmp/script_log.txt"



# Para monitorar o arquivo de log:

# tail -f /tmp/script_log.txt


# ----------------------------------------------------------------------------------------

# Definindo o intervalo de tempo em minutos (substitua X por um valor de sua escolha)

# Dicas extras:

#  Evite intervalos muito curtos (menos de 5 min), pode acabar ficando cansativo ou até 
# sobrecarregar o sistema dependendo do método usado.

# Declarar o intervalo sem aspas

INTERVAL=5  # Alterar a cada 5 minutos (modifique conforme necessário)



# ----------------------------------------------------------------------------------------

  # Verifica se o yad esta instalado

  if ! command -v yad >/dev/null 2>&1; then

    echo -e "\n\033[1;31mYad não encontrado.\033[0m\n"

    exit 1

  fi

# ----------------------------------------------------------------------------------------

# Verificar dependências

for cmd in "sway" "swaybg" "sed" "find" "killall" "xdg-user-dir" "shuf" "sleep" "grep" ; do

    command -v "$cmd" &>/dev/null || {

        echo -e "\n\033[1;31m$cmd não encontrado.\033[0m\n"

        yad --center --image="error" --title "Erro" --text "$cmd não encontrado." --button="Fechar:1" --width="400" --height="150"

        exit 1

    }

done

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

    yad --center --image="error" --title "Erro" --text "Erro: O arquivo de configuração do Sway não foi encontrado em $SWAY_CONFIG. Verifique se o Sway está instalado corretamente." --button="Fechar:1" --width="400" --height="150"

    exit 2
fi

# ----------------------------------------------------------------------------------------

# Verificar se o Sway está em execução

# Antes de executar o swaybg, é necessário garantir que o Sway está rodando.

if ! pgrep -x "sway" > /dev/null; then

    # Se o Sway não estiver rodando, você verá a mensagem:

    echo -e "\nErro: O Sway não está em execução. Certifique-se de que o Sway está rodando e tente novamente.\n"

    # Exibe um diálogo de erro usando yad

    yad --center --image="error" --title "Erro" --text "Erro: O Sway não está em execução. Certifique-se de que o Sway está rodando e tente novamente." --button="Fechar:1" --width="400" --height="150"


    exit 3

fi

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


    # Para colocar a parte "Novo wallpaper:" em verde e negrito

    echo -e "\n\033[1;32mNovo wallpaper ($(date +%d/%m/%Y_%H:%M:%S)):\033[0m $NEW_WALL \n" | tee -a "$log"



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

    killall -9 swaybg

    swaybg -o "*" -i "$NEW_WALL" -m fill 2>&1 | grep -v "Found config" &



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

    # Espera o tempo definido em minutos (INTERVAL)

# Definindo INTERVAL como 5, e depois multiplicando esse valor por 60 para convertê-lo em 
# segundos, que é o que o comando sleep usa. Ou seja, 5 * 60 = 300, então o processo vai 
# "dormir" por 300 segundos — exatamente 5 minutos. ⏳

    # espera=$(echo "$INTERVAL * 60" | bc) # Converte o intervalo para segundos

    # sleep $espera 

    # sleep $(($INTERVAL*60))



    # Espera 1 minuto (60 segundos)

    sleep $(($INTERVAL*60))

done


# Fim do loop


# ----------------------------------------------------------------------------------------

exit 0


