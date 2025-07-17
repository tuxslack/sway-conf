#!/bin/bash
#
# Autor:    Fernando Souza - https://www.youtube.com/@fernandosuporte/
# Data:     04/10/2023 as 19:29
# Homepage: https://github.com/tuxslack/scripts
# Licença:  MIT
#
#
# Sistema de Desligamento para o i3 com Shell Script usando o Yad
#
# https://terminalroot.com.br/2019/03/como-criar-um-sistema-de-desligamento-para-o-i3-com-shell-script.html
#
# https://youtu.be/Szoid9aH9Tw
# https://www.vivaolinux.com.br/script/Menu-de-saida-para-i3-versao-em-Zenity/
# https://www.vivaolinux.com.br/topico/Funtoo/Logout-Suspend-Reboot-e-Shutdown-no-i3wm
# https://wiki.archlinux.org/title/I3_(Portugu%C3%AAs)
#
# 
#
# Configura o sudo para usar os comandos de desligar e reiniciar o sistema com seu usuário comum.
#
#
# Instalação:
#
# mv -i ~/Downloads/i3-desligar.sh /usr/local/bin/
#
# chmod +x /usr/local/bin/i3-desligar.sh
#
#
# Opcional para o Xfce, KDE:
#
# mkdir -p ~/.local/share/applications/i3
#
# mv -i ~/Downloads/i3-desligar.desktop ~/.local/share/applications/i3
#
#
#
# Configurar a opção de "desligar" e "reiniciar" no menu do Fluxbox
#
# nano ~/.fluxbox/menu
#
#  [exec]   (Encerrar Sessão)      {/usr/local/bin/i3-desligar.sh}                <~/.fluxbox/icons/desligar.xpm>
#
#
#
#
# Backup:
#
# cd ~/ && tar -czf ~/backup-i3-desligar.tar.gz  .local/share/applications/i3/i3-desligar.desktop  /usr/local/bin/i3-desligar.sh
#
#
#
# Permissão para usuários normais executar o comando "shutdown now"
#
# O sudo pode gerar uma vulnerabilidade no seu sistema.
#
#
# ------------------------------------------------------------------------------------------------------
#
# su -c 'nano /etc/sudoers'
#
# Adiciona o usuário ao sudo:
#
# nome_do_usuario ALL=(ALL:ALL) ALL
#
#
# Faz com que o usuário não precisa colocar senha quando usar esses comandos:
#
# nome_do_usuario ALL=NOPASSWD:/usr/bin/poweroff,/usr/bin/shutdown,/usr/bin/reboot,/usr/bin/halt
#
# ------------------------------------------------------------------------------------------------------
#
#
# Not enough permissions to execute usr/bin/shutdown
#
# ./i3-desligar.sh: linha 49: i3-msg: comando não encontrado
#
#
# https://www.youtube.com/watch?v=Szoid9aH9Tw
# https://www.vivaolinux.com.br/topico/vivaolinux/Usuario-usar-comando-shutdown-r-now
# https://www.hostinger.com.br/tutoriais/comando-shutdown-linux
# https://blogs.czapski.id.au/2017/04/gtkdialog-for-rapid-prototyping-of-linux-applications-install-gtkialog-and-yad
# https://www.edivaldobrito.com.br/como-fazer-para-agendar-um-desligamento-no-linux/
# https://pt.stackoverflow.com/questions/143454/como-saber-se-comando-do-script-foi-executado-com-sucesso
#
#
#
# Não usar esse metodo para shutdown:
#
# https://www.vivaolinux.com.br/dica/Executar-shutdown-com-usuario-comum-em-5-etapas
# https://www.vivaolinux.com.br/perguntas/verPergunta.php?codigo=39868
#
#
# Você precisará reiniciar seu sistema e clicar na pequena roda dentada na janela de login e selecionar a opção "i3"
#
# Uma vez logado, você será solicitado a gerar o arquivo de configuração que será salvo em seu 
# diretório home ~/.config/i3/config, ou usar os padrões que irão salvar o arquivo no diretório/etc/i3.
#
# Neste guia, iremos com a primeira opção, então vamos pressionar ENTER para colocar o arquivo de configuração 
# em nosso diretório inicial.
#
# Em seguida, você deverá definir a tecla modificadora i3 wm, também conhecida como tecla , que pode ser a tecla 
# do logotipo do Windows ou a tecla Alt. Use as teclas de seta para cima ou para baixo para selecionar sua tecla 
# modificadora preferida.
#
#
# Mod1 equivale à tecla modificadora Alt ou Win — depende da configuração do seu sistema.
#
#
#
# i3
#
# man i3
#
#
# Arquivo de configuração do i3 =>  ~/.config/i3/config
#
#
# Combinação de teclas   Efeito
# 
# Mod1 + Enter 	Abre uma nova janela com um terminal dentro
# 
# Mod1 + A 	Focaliza a janela pai
# 
# Mod1 + S 	Muda o layout pro modo Stacked
#               Neste modo, apenas a janela com foco é exibida.
#               A barra superior exibe uma lista das janelas (com os nomes dos respectivos aplicativos)
# 
# Mod1 + W 	Muda o layout pro modo Tabbed
#               Este layout usa o mesmo princípio do Stacked.
#               A lista de janelas, no topo, contudo, consiste em apenas uma linha
# 
# Mod1 + E 	Muda o layout pro modo padrão Standard — cada nova janela ganha um novo espaço, igual ao das outras — a tela 
#               é dividida igualmente para todas as janelas.
#               A cada vez que você pressiona, o i3 alterna o layout para organizar as janelas horizontalmente/verticalmente
# 
# Mod1 + barra de espaço 	Foca o ladrilhamento/flutuação (tiling/floating)
# 
# Mod1 + D 	  dmenu (no topo)
# 
# Mod1 + → ↓ ↑ ←  Move o foco para próxima janela, de acordo com a direção da seta pressionada.
#                 Se não for possível usar as setas, use as teclas l (para cima), k (para baixo), j (para esquerda) e ; (para direita)
# 
# Mod1 + shift + Q 	                 Fecha a janela atual
# 
# Mod1 + Shift + E 	                 Fecha o i3
# 
# Mod1 + Shift + C 	                 Recarrega o arquivo de configurações sem reiniciar
# 
# Mod1 + Shift + R 	                 Recarrega o i3 com as alterações que você fez no arquivo de configurações
# 
# Mod1 + Shift + → ↓ ↑ ←                 Movimenta a janela atual (a quem detém o foco) na direção da seta
# 
# Mod1 + Shift + Barra de espaçamento    Alterna entre ladrilhamento/flutuação de janela
#
#
#
# https://pt.linux-console.net/?p=120#gsc.tab=0
# https://elias.praciano.com/2014/08/teclas-de-atalho-do-i3/
# https://www.vivaolinux.com.br/artigos/impressora.php?codigo=14847
#
# Passa o conteúdo:
#
# i3wm： Não utilize a configuração padrão!
#
# https://www.youtube.com/watch?v=L3bWio4BelE
#
#
# Enrola para passar o conteúdo para deixar o vídeo longo.
#
# https://www.youtube.com/watch?v=z5vtjmnGBKQ
#
#
# Enrola e não explica nada do conteúdo proposto no vídeo e ainda faz propaganda pessoal.
#
# https://www.youtube.com/watch?v=Sbz_DHQ82VY
#
#
#
# No modo texto, você pode configurar as teclas CTRL+ALT+DEL para desligar o sistema. 
#
#
# Pesquisar no Google:
#
# i3 config github



# Trave a tela do I3 com i3lock

# https://www.youtube.com/watch?v=fdUql36AraY


# Para X11:

# awesome
# bspwm
# budgie
# cinnamon
# deepin
# enlightenment
# fluxbox
# gnome
# i3|i3wm
# jwm
# kde
# lxde
# lxqt
# mate
# xfce
# openbox


# Para Wayland:

# labwc


# ----------------------------------------------------------------------------------------


# 14/05/2025 - Adicionado swaylock para suporte ao Wayland.


# ----------------------------------------------------------------------------------------

# Verificar se os programas estão instalados


clear


which yad        2> /dev/null || { echo "Programa Yad não esta instalado."      ; exit ; }


which sudo       2> /dev/null || { yad --center --image=dialog-error --timeout=10 --no-buttons --title "Aviso" --text "Programa sudo não esta instalado." --width 450 --height 100 2>/dev/null   ; exit ; } 

which tar        2> /dev/null || { yad --center --image=dialog-error --timeout=10 --no-buttons --title "Aviso" --text "Programa tar não esta instalado." --width 450 --height 100 2>/dev/null   ; exit ; } 


which shutdown   2> /dev/null || { yad --center --image=dialog-error --timeout=10 --no-buttons --title "Aviso" --text "Programa shutdown não esta instalado." --width 450 --height 100 2>/dev/null   ; exit ; } 

# Usado no i3wm

which i3-msg     2> /dev/null || { yad --center --image=dialog-error --timeout=10 --no-buttons --title "Aviso" --text "Programa i3-msg não esta instalado." --width 450 --height 100 2>/dev/null   ; exit ; } 


# Fluxbox

which fluxbox    2> /dev/null || { yad --center --image=dialog-error --timeout=10 --no-buttons --title "Aviso" --text "Programa fluxbox não esta instalado." --width 450 --height 100 2>/dev/null   ; exit ; } 


# Bloquear a tela no i3wm

which i3lock    2> /dev/null || { yad --center --image=dialog-error --timeout=10 --no-buttons --title "Aviso" --text "Programa i3lock não esta instalado."   --width 450 --height 100 2>/dev/null   ; exit ; } 


# Usando labwc

# Bloquear a tela no labwc

which swaylock  2> /dev/null || { yad --center --image=dialog-error --timeout=10 --no-buttons --title "Aviso" --text "Programa swaylock não esta instalado." --width 450 --height 100 2>/dev/null   ; exit ; } 


# Som

which play      2> /dev/null || { yad --center --image=dialog-error --timeout=10 --no-buttons --title "Aviso" --text "Programa play não esta instalado." --width 450 --height 100 2>/dev/null   ; exit ; } 



# ----------------------------------------------------------------------------------------


# Função deve se usada em comandos que usa o sudo.


# Mostra um aviso de como configurar o SUDO para o usuário atual.

ajuda(){

yad \
--center \
--title="Desligar" \
--text="\n\n
# ------------------------------------------------------------------------------------------------------

# su -c 'nano /etc/sudoers'

 Adiciona o usuário `whoami` ao sudo:

 `whoami` ALL=(ALL:ALL) ALL


 Faz com que o usuário `whoami` não precisa colocar senha quando usar esses comandos:

 `whoami` ALL=NOPASSWD:/usr/bin/poweroff,/usr/bin/shutdown,/usr/bin/reboot,/usr/bin/halt

# ------------------------------------------------------------------------------------------------------
\n\n" \
--width="650" --height="100"  \
2> /dev/null


}







acao=$(yad \
--center \
--title "Sistema de Desligamento" \
--entry --image=icon.png \
--text "Escolha uma opção:" \
--entry-text \
"Desligar" "Reiniciar" "Encerrar Sessão" "Hibernar" "Suspender" "Bloquear a tela" \
--buttons-layout=center \
--button="OK:0" \
--button="Fechar:1" \
--width="500" --height="200" \
2> /dev/null)




case "$acao" in

# No modo texto, note que os comandos de desligamento (halt, shutdown, poweroff, ...) e reiniciar (reboot) servem apenas para o usuário Root.

# Caixa em yad para saida de erro do comando shutdown


# sudo poweroff
 
"Desligar") 
       
echo -e "\nDesligar\n"

                play ~/.config/i3/sons/service-login.ogg  > /dev/null 2>&1
                
                # sudo systemctl poweroff
                
                # sudo shutdown -h now 2> /tmp/desligar.log
                

                # dbus-send --system --print-reply --dest="org.freedesktop.ConsoleKit" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Stop
                

 # No Void Linux, você pode desligar o sistema sem usar o comando sudo. (Funcionou)
                
dbus-send --system --print-reply \
--dest="org.freedesktop.login1" \
/org/freedesktop/login1 \
"org.freedesktop.login1.Manager.PowerOff" \
boolean:true



# Como saber se comando do anterior foi executado com sucesso?

if [ $? -eq 0 ]
then      

echo "Desligando..."

else

yad \
--center \
--title="Desligar" \
--text="\n\nOcorreu um problema ao usar o comando shutdown:\n\n$(cat /tmp/desligar.log)" \
--image="gtk-dialog-error" \
--window-icon="gtk-dialog-error" \
--width="500" --height="100" \
--buttons-layout=center \
--button="OK:0" \
2> /dev/null

rm -Rf /tmp/desligar.log

ajuda 

fi


;;

# sudo reboot
    
"Reiniciar")     
  
echo -e "\nReiniciar\n"

                play ~/.config/i3/sons/service-login.ogg  > /dev/null 2>&1
          
                 # sudo systemctl reboot   
                  
                 # sudo reboot       
                     
                 # sudo shutdown -r now 2> /tmp/reiniciar.log
                 
                 # dbus-send --system --print-reply --dest="org.freedesktop.ConsoleKit" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Restart


# No Void Linux
 
dbus-send --system --print-reply \
--dest="org.freedesktop.login1" \
/org/freedesktop/login1 \
"org.freedesktop.login1.Manager.Reboot" \
boolean:true



# Como saber se comando do anterior foi executado com sucesso?

if [ $? -eq 0 ]
then      

echo "Reiniciando..."

else

yad \
--center \
--title="Reiniciar" \
--text="\n\nOcorreu um problema ao usar o comando shutdown:\n\n$(cat /tmp/reiniciar.log)" \
--image="gtk-dialog-error" \
--window-icon="gtk-dialog-error" \
--width="500" --height="100" \
--buttons-layout=center \
--button="OK:0" 2> /dev/null


rm -Rf /tmp/reiniciar.log

ajuda 

fi


;;
    
    
"Encerrar Sessão") 

echo -e "\nLogout\n"


# i3-msg exit 2> /tmp/logout.log || yad --title="Logout" --text="\n\nOcorreu um problema ao usar o comando 'i3-msg exit':\n\n$(cat /tmp/logout.log)" \
# --center --image="gtk-dialog-error" --window-icon="gtk-dialog-error" --width=500 --height=100 --button="OK:0" 2> /dev/null && rm -Rf /tmp/logout.log && ajuda 



                clear
                
                play ~/.config/i3/sons/desktop-logout.ogg > /dev/null 2>&1
                
                
                # Forma de indicar em qual ambiente o usuário esta logado.
                #
                # Identifica a sessão do usuário atraves da variavel $DESKTOP_SESSION
                #
                # echo $DESKTOP_SESSION
                
                
                DESKTOP_SESSION=$(echo $DESKTOP_SESSION)
                
                if [[ $DESKTOP_SESSION == *"Xfce"* ]]; then
                
                   # Xfce Session
  
  
#     man xfce4-session-logout
#
#                   
#     xfce4-session-logout takes the following command line options:
#
#       --logout
#              Log out without displaying the logout dialog.
#
#       --halt Halt without displaing the logout dialog.
#
#       --reboot
#              Reboot without displaying the logout dialog.
#
#       --suspend
#              Suspend without displaying the logout dialog.
#
#       --hibernate
#              Hibernate without displaying the logout dialog.
#
#       --hybrid-sleep
#              Hybrid Sleep without displaying the logout dialog.
#
#       --fast Do a fast shutdown.  This instructs the session manager not to
#              save the session, but instead to quit everything quickly.

                   
                   echo "Você está usando o ambiente XFCE."
                        
                                xfce4-session-logout --logout
                                                
                elif [[ $DESKTOP_SESSION == *"dwm"* ]]; then
                        echo "Você está usando o ambiente DWM."
                                        
                elif [[ $DESKTOP_SESSION == *"hyprland"* ]]; then
                        echo "Você está usando o ambiente Hyprland."
                  
                elif  [[ "$DESKTOP_SESSION" == "Openbox" ]]; then
                
				openbox --exit
				
		elif [[ "$DESKTOP_SESSION" == "bspwm" ]]; then
		
		# elif [[ $DESKTOP_SESSION == *"bspwm"* ]]; then
		
                  echo "Você está usando o ambiente BSPWM."
                  
				bspc quit
				
		elif [[ "$DESKTOP_SESSION" == "i3" ]]; then
		
                # elif [[ $DESKTOP_SESSION == *"i3"* ]]; then
                		
		# Não esta funcionando [[ ]] problema era #!/bin/sh no inicio.
		
		  echo "Você está usando o ambiente i3."
		  
                               i3-msg exit
				
		elif [[ "$DESKTOP_SESSION" == "Fluxbox" ]]; then
				
                  echo "Você está usando o ambiente Fluxbox."
                  	
                  	       fluxbox-remote exit			



		elif [[ "$DESKTOP_SESSION" == "labwc" ]]; then
				

                  echo -e "\nVocê está usando o ambiente labwc. \n"
                  	
                  	       # Usar swaymsg (se disponível e compatível)

                           # Labwc é compatível com o protocolo do Sway IPC.

                           



echo -e "\n🔍 Verificando se 'swaymsg' está instalado... \n"

if ! command -v swaymsg &> /dev/null; then

    echo "❌ 'swaymsg' não está instalado."

    exit 1

fi


echo "✅ 'swaymsg' encontrado."


# Como saber se o Labwc esta com suporte habilitado para IPC?


echo -e "\n🔍 Tentando localizar socket IPC do Labwc... \n"


USER_ID=$(id -u)

SOCKET_PATH="/run/user/$USER_ID/labwc.sock"


if [ ! -S "$SOCKET_PATH" ]; then


    # echo "❌ Socket IPC não encontrado em $SOCKET_PATH"
    # echo -e "Labwc pode não ter iniciado com suporte a sway-ipc. \n"



    echo "❌ Não foi possível conectar via IPC."
    echo "Labwc pode não ter sido compilado com suporte a sway-ipc."


    sleep 2


                          # ⚠️ Isso só funciona se o swaymsg estiver instalado e se o Labwc tiver suporte habilitado para IPC.




# O comando "loginctl kill-user $USER" não encerra necessariamente todos os processos 
# iniciados pelo usuário, especialmente se eles estiverem fora do cgroup gerenciado 
# pelo systemd ou se o script foi iniciado de maneira que o systemd não está ciente 
# dele (por exemplo, diretamente por um terminal sem session de systemd, via nohup, 
# disown, etc).

                  	       # loginctl kill-user $USER

                           pkill -u $USER


                          # Matar o processo do Labwc (forçado)

                          # Se você quiser forçar o encerramento (não recomendado, pois não salva estado nem fecha janelas graciosamente):

                          # pkill labwc

                          # Ou mais especificamente:

                          killall -9 labwc

                          #  ⚠️ Use apenas se o ambiente estiver travado ou não responder.


    exit 1





else


echo -e "\n✅ Socket encontrado: $SOCKET_PATH \n"



echo -e "\n🔌 Testando conexão com o Labwc via swaymsg... \n"

VERSION=$(swaymsg -s "$SOCKET_PATH" -t get_version 2>/dev/null)

if [ $? -eq 0 ]; then

    echo "✅ IPC FUNCIONANDO: $VERSION"

    swaymsg exit



fi




fi




		elif [[ "$DESKTOP_SESSION" == "sway" ]]; then
				
                  echo "Você está usando o ambiente Sway."

# O comando "loginctl kill-user $USER" não encerra necessariamente todos os processos 
# iniciados pelo usuário, especialmente se eles estiverem fora do cgroup gerenciado 
# pelo systemd ou se o script foi iniciado de maneira que o systemd não está ciente 
# dele (por exemplo, diretamente por um terminal sem session de systemd, via nohup, 
# disown, etc).

                  	       # loginctl kill-user $USER

                           pkill -u $USER


                  	       swaymsg exit	




                else

                        notify-send -i gtk-dialog-info -t 100000 "Sair do sistema" "\nNão foi possível identificar o ambiente de desktop em uso."
                fi
			

				




;;



"Hibernar") 

                echo -e "\nHibernar\n" 

                play ~/.config/i3/sons/service-logout.ogg > /dev/null 2>&1
              
                
# Lembrando que estes comandos foram adaptados para serem executados como usuário comum, mas 
# é possível que o sistema solicite a senha de root, dependendo das configurações de permissões.


# dbus-send --system --print-reply \
# --dest="org.freedesktop.login1" \
# /org/freedesktop/login1 \
# "org.freedesktop.login1.Manager.Hibernate" \
# boolean:true


;;

"Suspender") 
                echo -e "\nSuspender\n" 

                play ~/.config/i3/sons/service-logout.ogg > /dev/null 2>&1
                
                
                # sudo systemctl suspend
                
                
# Lembrando que estes comandos foram adaptados para serem executados como usuário comum, mas 
# é possível que o sistema solicite a senha de root, dependendo das configurações de permissões.


# dbus-send --system --print-reply \
# --dest="org.freedesktop.login1" \
# /org/freedesktop/login1 \
# "org.freedesktop.login1.Manager.Suspend" \
# boolean:true  

;;

"Bloquear a tela")

echo -e "\nBloquear a tela\n"


            
# unity
# kde
# gnome
# xfce      OK
# cinnamon
# mate
# lxde
# hyprland
# dwm
# Openbox
# bspwm
# i3        OK
# Fluxbox   OK

                clear
            
                play ~/.config/i3/sons/service-login.ogg   > /dev/null 2>&1
                
                
                
                # Forma de indicar em qual ambiente o usuário esta logado.
                #
                # Identifica a sessão do usuário atraves da variavel $DESKTOP_SESSION
                #
                # echo $DESKTOP_SESSION
                
                
                DESKTOP_SESSION=$(echo $DESKTOP_SESSION)
                
                if [[ $DESKTOP_SESSION == *"Xfce"* ]]; then
                
                   # Xfce Session
  
                   
                   echo "Você está usando o ambiente XFCE."

		if [ -f /usr/bin/xfce4-screensaver ]; then
		
			xfce4-screensaver-command --lock
		else
		
			xflock4
                 
                fi
                                
                                                
                elif [[ $DESKTOP_SESSION == *"dwm"* ]]; then
                        echo "Você está usando o ambiente DWM."
                                        
                elif [[ $DESKTOP_SESSION == *"hyprland"* ]]; then
                        echo "Você está usando o ambiente Hyprland."
                  
                elif  [[ "$DESKTOP_SESSION" == "Openbox" ]]; then
                
                  echo "Você está usando o ambiente Openbox."
                  	
                  
                if [ -f /usr/bin/i3lock ]; then
                
			i3lock -i ~/.config/i3/i3lock.png &
			
		fi	
					
				
		elif [[ "$DESKTOP_SESSION" == "bspwm" ]]; then
		
		# elif [[ $DESKTOP_SESSION == *"bspwm"* ]]; then
		
                  echo "Você está usando o ambiente BSPWM."
                  
                  
                if [ -f /usr/bin/i3lock ]; then
                
			i3lock -i ~/.config/i3/i3lock.png &
			
		fi	
						
				
		elif [[ "$DESKTOP_SESSION" == "i3" ]]; then
		
                # elif [[ $DESKTOP_SESSION == *"i3"* ]]; then
                		
		# Não esta funcionando [[ ]] problema era #!/bin/sh no inicio.
		
		  echo "Você está usando o ambiente i3."
		  

                if [ -f /usr/bin/i3lock ]; then
                
			i3lock -i ~/.config/i3/i3lock.png &
			
		fi		  
                               
				
		elif [[ "$DESKTOP_SESSION" == "Fluxbox" ]]; then
				
                  echo "Você está usando o ambiente Fluxbox."
                  
		if [ -f /usr/bin/xlock ]; then
		
			xlock
		else
		
			i3lock -i ~/.config/i3/i3lock.png &
		
		fi
		
		elif [[ "$DESKTOP_SESSION" == "labwc" ]]; then
				

                  echo -e "\nVocê está usando o ambiente labwc. \n"


# O labwc (Lab Wayland Compositor) é um compositor leve para Wayland que se inspira no
# Openbox. Ele não oferece um sistema de bloqueio de tela integrado por padrão, mas você 
# pode usar ferramentas externas para isso.

# swaylock -h


# O swaylock é a ferramenta de bloqueio de tela mais comum e recomendada para ambientes 
# que utilizam o Wayland com o compositor Sway. No entanto, não é a única opção para 
# bloquear a tela em Wayland.



# 🟢 1. swaylock-effects

#     Uma versão modificada do swaylock com suporte a efeitos visuais como desfoque 
# (blur), escurecimento e imagens customizadas.

#     Muito usado por quem quer algo mais estético.

#     Requer compilar a partir do código-fonte na maioria dos casos.

# 🔗 https://github.com/mortie/swaylock-effects


# 🟡 2. gtklock

#     Um bloqueador de tela baseado em GTK, com suporte a Wayland.

#     Altamente personalizável com temas em GTK.

#     Boa integração com ambientes como Hyprland, Wayfire, River, além de Sway.

# 🔗 https://github.com/jovanlanik/gtklock


# 🟠 3. waylock

#     Foco em simplicidade e segurança.

#     Escrito em Rust.

#     Menos personalizável que o swaylock, mas muito leve.

# 🔗 https://github.com/ifreund/waylock



# Conclusão

# Se você usa Sway ou outro compositor Wayland, o swaylock e suas variantes (como 
# swaylock-effects) são as escolhas naturais, mas gtklock e waylock também são ótimas 
# opções dependendo do seu foco (visual ou minimalismo).


        if [ -f /usr/sbin/swaylock ]; then
                
           # swaylock -i ~/.config/i3/i3lock.png &

           swaylock &
			
		fi


# Qualquer bloqueador X11 via XWayland (não recomendado)

# Ferramentas como i3lock, xtrlock, etc., podem funcionar via XWayland, mas não são seguras 
# sob Wayland, pois não bloqueiam o acesso real à entrada.


		elif [[ "$DESKTOP_SESSION" == "sway" ]]; then
				

                  echo -e "\nVocê está usando o ambiente sway. \n"


        if [ -f /usr/sbin/swaylock ]; then
                
           # swaylock -i ~/.config/i3/i3lock.png &

           swaylock &
			
		fi
	                  	
                  	       			
                else

                        notify-send -i gtk-dialog-info -t 100000 "Sair do sistema" "\nNão foi possível identificar o ambiente de desktop em uso."
                fi
                
                
                                

                # Usa um ou outro bloqueiado de tela se estiver instalado no sistema.
                
#                if [ -f /usr/bin/i3lock ]; then
                
#			i3lock -i ~/.config/i3/i3lock.png &
			
			
#		elif [ -f /usr/bin/xlock ]; then
		
#			xlock	
					
			
#		elif [ -f /usr/bin/betterlockscreen ]; then
		
#			betterlockscreen -l
			
			
#		elif [ -f /usr/bin/xflock4 ]; then
		
#			xflock4
			
							
#		elif [ -f /usr/bin/xfce4-screensaver ]; then
		
#			xfce4-screensaver-command --lock


#		elif [ -f /usr/bin/xscreensaver ]; then
		
#			xscreensaver-command -lock

						
#		elif [ -f /usr/bin/light-locker ]; then
		
#			light-locker-command -l
			
#		elif [ -f /usr/bin/gnome-screensaver ]; then
		
#			gnome-screensaver-command -l				
#		else
		
#			notify-send -i gtk-dialog-info -t 100000 "Sair do sistema" "\nNão foi localizado nenhum bloqueador de tela conhecido:\n\n* i3lock\n* xlock\n* betterlockscreen\n* xflock4\n* xfce4-screensaver\n* XScreenSaver\n* Light Locker\n* GNOME Screensaver\n\nObs: No i3wm recomenda-se usar o i3lock como bloqueador de tela."
#		fi

		
# XSecureLock
# Xlockmore		
		
		

;;


*) : ;;

esac
		

exit 0

