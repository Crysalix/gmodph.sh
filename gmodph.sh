#!/bin/bash

#Colors
ok="[\e[0;32m OK \e[0;39m]"
warn="[\e[1;33mWARN\e[0;39m]"
fail="[\e[0;31mFAIL\e[0;39m]"
info="[\e[0;36mINFO\e[0;39m]"
warning="\e[0;31mWARNING!\e[0;39m"
threedot="[....]"

#Settings
srcdsPath='Steam/steamapps/common/GarrysModDS/srcds_run'
gmodphScreen='gmodph
serverIP='127.0.0.1'

# FUNCTIONS
function root_check(){
    if [ $(whoami) = "root" ]; then
        for ((r=0 ; r<5 ; r++))
            do
                echo -e "$warning Run this script as root is not recommended !"
                sleep 0.5
        done
        read -p "Do you want to continue [y/N]? " yn
        yn=$(echo $yn | awk '{print tolower($0)}')
        if [ -z $yn ] || [ $yn != "y" ]; then
            echo Abort.
            exit 1
        fi
    fi
}

function start_servers(){
        screen -dmS $gmodphScreen $srcdsPath +ip $serverIP -port 27015 +hostname "Pixelife!  |  PropHunt  #1  |  pixe-life.org" -game garrysmod +gamemode prop_hunt +map ph_myprophuntmap1 +maxplayers 42 -nohltv
        screen -dmS $gmodphScreen $srcdsPath +ip $serverIP -port 27016 +hostname "Pixelife!  |  PropHunt  #2  |  pixe-life.org" -game garrysmod +gamemode prop_hunt +map ph_myprophuntmap2 +maxplayers 42 -nohltv
}

function stop_servers(){
    echo -e "$threedot Sending quit command."
    for ((r=1 ; r<2 ; r++))
    do
        if ps ax | grep -v grep | grep -i SCREEN | grep $gmodphScreen$r > /dev/null
        then
            screen -p 0 -S gmodph$r -X eval 'stuff \015quit\015' > /dev/null
        else
            echo -e "$info Server $r already stopped."
        fi
    done
}

function restart_servers(){
    stop_servers
    sleep 1
    start_servers
}

function input_servers(){
    for ((r=1 ; r<2 ; r++))
    do
        if ps ax | grep -v grep | grep -i SCREEN | grep $gmodphScreen$r > /dev/null
        then
            i=0
            for param in "$@"
            do
                if [ $i -eq 0 ] ; then
                    ((i=$i+1))
                else
                    commande="$commande$param"
                    commande="$commande "
                fi
            done
            bash -c "screen -p 0 -S $gmodphScreen$r -X eval 'stuff \"$commande\"\015'"
        else
            echo -e "$fail Server $r is not runing !"
        fi
    done
}

function update_servers(){
  if [ $2 = '-v' ]; then
    Steam/steamcmd.sh +@sSteamCmdForcePlatformType linux +login anonymous +app_update 4020 validate +exit
    Steam/steamcmd.sh +@sSteamCmdForcePlatformType linux +login anonymous +app_update 232330 validate +exit
  else
    Steam/steamcmd.sh +@sSteamCmdForcePlatformType linux +login anonymous +app_update 4020 validate +quit >> $
    Steam/steamcmd.sh +@sSteamCmdForcePlatformType linux +login anonymous +app_update 232330 validate +quit >$
  fi
}

case $1 in
    start)
        start_servers;;
    stop)
        stop_servers;;
    restart)
        restart_servers;;
    input)
        input_servers;;
    *)
        echo -e "Usage: $0 {start|stop|restart|input|update}"
        exit 1;;
esac

exit 0
