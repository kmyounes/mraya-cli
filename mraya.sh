#!/bin/bash
#Author: Kasmi Mohamed Youens
#For Open Minds Club
set -e

OS=$(lsb_release -si)
OS_version=$(lsb_release -sr)
SUDO=''
HEIGHT=20
WIDTH=70
CHOICE_HEIGHT=4
BACKTITLE="Mraya@OMC"
TITLE="Mraya@OMC"
MENU="Que voulez vous faire ?:"
SOURCE="http://mirror/source.list"

####=======colors==============
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
##############################


#=== Testing Version ===
if [ "$OS" != "Ubuntu" ] ; then
    echo "Sorry yout OS is not supported by our mirrors"
	echo "With Love , OMC <3"
    exit 1;
fi;
if [[ "$OS_version" != "16.04" ]] ; then
    echo "${red}Sorry${reset},your version of UBUTNU is not supported by our mirrors"
	echo "With Love , ${red}OMC <3${reset}"
    exit 1;
fi;

if  [[ $EUID != 0 ]] ; then
    SUDO="sudo"
fi

#====Dependecies Check=====
if  [[ $(which lsb_release) ]] && [[  $(which wget) ]]  && [[  $(which dialog) ]] ; then echo ; else
$SUDO apt update > /dev/null 2>&1
$SUDO apt install -y lsb-release wget dialog
fi


#==== Install =========
if [[ ! -e /usr/bin/mraya ]] ; then
	$SUDO mv ./mraya.sh /usr/bin/mraya
fi




OPTIONS=(1 "Configurer le sources.list avec le mirroir du club"
         2 "Reconfigurer le sources.list avec la configuration initiale"
         )

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
	    	cd /etc/apt || exit 2;
    		if [ ! -e sources.list.original ]; then
       		 $SUDO mv sources.list sources.list.original
			 $SUDO wget $SOURCE > /dev/null 2>&1 ||  mv sources.list.original sources.list && echo "${red}Sorry${reset},cannot reach OMC's Mirros" && exit 1
    		else
        	$SUDO rm sources.list ; $SUDO wget $SOURCE
    		fi
    		$SUDO apt update
			exit 0;
            ;;
        2)
           	cd /etc/apt  || exit 2;
            $SUDO mv sources.list.original sources.list >/dev/null 2>&1 || echo "Not paired with OMC's mirrors" && exit 1;
           	$SUDO apt update
			exit 0;
            ;;
esac
