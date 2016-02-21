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

case $1 in
    start)
        start_servers;;
    stop)
        stop_servers;;
    *)
        echo -e "Usage: $0 {start|stop}"
        exit 1;;
esac

exit 0
