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
which docker
if ! [ $? -eq 0 ]
then
  docker --version | grep "Docker version"
  if ! [ $? -eq 0 ]
  then
    sudo apt-get update 1>/dev/null 2>&1
    sudo apt-get remove docker docker-engine docker.io containerd runc 1>/dev/null 2>&1
    sudo apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common -y 1>/dev/null 2>&1
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - 1>/dev/null 2>&1
    sudo apt-key fingerprint 0EBFCD88 1>/dev/null 2>&1
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" 1>/dev/null 2>&1
    sudo apt-get update 1>/dev/null 2>&1
    sudo apt-get install docker-ce docker-ce-cli containerd.io -y 1>/dev/null 2>&1
    sudo apt-get install ansible -y 1>/dev/null 2>&1
    sudo apt-get install unzip -y 1>/dev/null 2>&1
    sudo apt-get install curl -y 1>/dev/null 2>&1
    sudo apt-get install wget -y 1>/dev/null 2>&1
    sudo apt-get install python-pip -y 1>/dev/null 2>&1
    sudo pip install docker-py 1>/dev/null 2>&1
    sudo groupadd docker
    sudo usermod -aG docker $USER
    ansible-playbook ./ansiblescripts/deployment.yml --tags network &>/dev/null &
    ansible-playbook ./ansiblescripts/deployment.yml --tags dockerrestart &>/dev/null &
  then 
    clear 1>/dev/null 2>&1
  fi
else
  clear 1>/dev/null 2>&1
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
