#!/bin/bash
file="/usr/bin/dialog"
if [ -e "$file" ]
then
  clear 1>/dev/null 2>&1
else
  echo "install git ca-certificates sudo"
  apt-get install git ca-certificates sudo -y > /dev/null 2>&1
  clear
  echo "Dialog is not installed. It will be installed now."
  echo "System update"
  sudo apt-get update >/dev/null 2>&1
  echo "System upgrade" 
  sudo apt-get upgrade -y  >/dev/null 2>&1
  echo "Dialog install"
  sudo apt-get install dialog >/dev/null 2>&1
  export NCURSES_NO_UTF8_ACS=1
  sudo touch /etc/bash.bashrc.local
  sudo echo "export NCURSES_NO_UTF8_ACS=1" >> /etc/bash.bashrc.local
fi
#check if docker is installed
if [ -e "/usr/bin/docker"]
then
  clear 1>/dev/null 2>&1
else
  echo "0" | dialog --gauge "Updating repo" 10 70 0
  sudo apt-get update 1>/dev/null 2>&1
  echo "10" | dialog --gauge "Installing docker" 10 70 0
  sudo apt-get install docker docker-ce -y 1>/dev/null 2>&1
  echo "20" | dialog --gauge "Installing ansible" 10 70 0
  sudo apt-get install ansible -y 1>/dev/null 2>&1
  echo "30" | dialog --gauge "Installing Unzip" 10 70 0
  sudo apt-get install unzip -y 1>/dev/null 2>&1
  echo "40" | dialog --gauge "Installing curl" 10 70 0
  sudo apt-get install curl -y 1>/dev/null 2>&1
  echo "50" | dialog --gauge "Installing wget" 10 70 0
  sudo apt-get install wget -y 1>/dev/null 2>&1
  echo "60" | dialog --gauge "Installing unionfs-fuse" 10 70 0
  sudo apt-get install unionfs-fuse -y 1>/dev/null 2>&1
  echo "70" | dialog --gauge "Installing python-pip" 10 70 0
  sudo apt-get install python-pip -y 1>/dev/null 2>&1
  echo "80" | dialog --gauge "Installing docker-py" 10 70 0
  sudo pip install docker-py 1>/dev/null 2>&1
  echo "90" | dialog --gauge "Setting up docker and installing Portainer" 10 70 0
  sudo groupadd docker
  sudo usermod -aG docker $USER
  ansible-playbook ./ansiblescripts/deployment.yml --tags network &>/dev/null &
  ansible-playbook ./ansiblescripts/deployment.yml --tags dockerrestart &>/dev/null &
  echo "100" | dialog --gauge "Everything installed successfuly, going back to main menu" 10 70 0
  clear
fi

OPTIONS=( A "Install Netdata"
          Z "Exit")

CHOICE=$(dialog --backtitle "Deploy Tools" \
                --title "Selection" \
                --menu "$MENU" \
                  15 38 10 \
                  "${OPTIONS[@]}" \
                  2>&1 >/dev/tty)

case $CHOICE in
  A)
    tool=netdata
    dialog --infobox "Installing: $tool" 3 30
    ansible-playbook ./ansiblescripts/deployment.yml --tags $tool &>/dev/null &
    sleep 2
    dialog --msgbox "\n Installed $tool" 0 0
    ;;
  Z)
    clear
    exit 0
    ;;
esac