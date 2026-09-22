#!/bin/bash
optimisation() {
    echo "Installation de zram"
    echo ""
    sudo apt-get -y install zram-config && sudo service zram-config --full-restart
    echo ""
    cat /proc/swaps

    echo "Installation de prelink"
    echo ""
    sudo apt-get -y install prelink && sed -i 's/PRELINKING=unknown/PRELINKING=yes/' /etc/default/prelink
    /etc/cron.daily/prelink
    echo 'DPkg::Post-Invoke {"echo Pré-raccordement des bibliothèques en cours, veuillez patienter...;/etc/cron.daily/prelink";}'|sudo tee -a /etc/apt/apt.conf.d/98prelink
    echo ""
    echo "Installation de preload"
    sudo apt install preload -y
    echo "tlp"
    sudo apt install tlp tlp-ui -y
    sudo tlp start
    sudo systemctl enable tlp
    echo "Fin de l'installation des optimisation"
}

media() {
    echo "Installation des media"
    sudo apt install ubuntu-restricted-extras -y
    echo ""
    echo "Installation de smplayer"
    sudo apt install smplayer smplayer-l10n smplayer-themes
    echo ""
    echo "Installation de vlc"
    sudo snap install vlc
    echo ""
    echo "Installation de rhythmbox"
    sudo add-apt-repository ppa:fossfreedom/rhythmbox
    sudo apt-get update
    sudo apt-get install rhythmbox -y
    sudo add-apt-repository ppa:fossfreedom/rhythmbox-plugins
    sudo apt-get update
    sudo apt-get install rhythmbox-plugin-complet -y


}

browser() {
    echo "Installation des navigateurs"
    echo ""
    echo "Installation de chrome"
    sudo snap install chromium
    echo ""
    echo "Installation de opera"
    wget -qO - https://deb.opera.com/archive.key | sudo apt-key add -
    sudo add-apt-repository -y 'deb https://deb.opera.com/opera-stable/ stable non-free'
    sudo apt-get update
    sudo apt install -y -V opera-stable
    echo "Vivaldi"
    wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | sudo apt-key add -
    sudo add-apt-repository 'deb https://repo.vivaldi.com/archive/deb/ stable main'
    sudo apt update && sudo apt install vivaldi-stable -y
    echo "Brave"
    sudo snap install brave
    echo "Fin de l'installation du browser"
}

application() {
    echo "Installation des applications"
    echo ""
    echo "Installation de curl"
    sudo apt -y install curl
    echo ""
    echo "Installation de synaptic"
    sudo apt -y install synaptic
    echo ""
    echo "Installation de libreoffice"
    sudo snap install libreoffice
    echo ""
    echo "Installation de pencil"
    sudo apt-get -y install pencil
    echo ""
    echo "Installation de meld"
    sudo apt -y install meld
    echo ""
    echo "Installation de scan"
    sudo apt -y install simple-scan
    echo ""
    echo "Installation de dia"
    sudo apt -y install dia
    echo ""
    echo "Installation de mcomix"
    sudo apt -y install mcomix
    echo ""
    echo "Installation de mlocate"
    sudo apt-get -y install mlocate
    echo ""
    echo "Installation de thunar"
    sudo apt -y install thunar && sudo apt install -y thunar-archive-plugin && sudo apt install thunar-volman
    echo ""
    echo "Installation de jdownloader"
    sudo snap install jdownloader2
    echo ""
    echo "Installation de transmission"
    sudo apt install transmission
    echo "Installation de gimp"
    sudo snap install gimp
    echo ""
    echo "Installation de Trello"
    sudo snap install trello-desktop
    echo " Fin de l'installation des applications"
}

email() {
    echo "Installation des clients pour pour communiquer"
    echo ""
    echo "Installation de mailspring"
    sudo snap install mailspring
    echo ""
    echo "Installatino de discord"
    sudo snap install discord
    echo ""
    echo "Fin de l'installation des mails"
}

dev() {
    echo "Installation des logiciel pour le developpement"
    echo ""
    echo "Installation de github desktop"
    wget -qO - https://apt.packages.shiftkey.dev/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/shiftkey-packages.gpg > /dev/null
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/shiftkey-packages.gpg] https://apt.packages.shiftkey.dev/ubuntu/ any main" > /etc/apt/sources.list.d/shiftkey-packages.list'
    sudo apt update
    sudo apt install github-desktop
    echo ""
    echo "Installation de remmina"
    sudo snap install remmina
    echo ""
    echo "Installation de zeal"
    sudo apt install zeal
    echo "Installation de vscode"
    sudo snap install code --classic
    echo ""
    echo "Installation de dbeaver"
    sudo snap install dbeaver-ce
    echo ""
    echo "Installation de virtualbox"
    sudo apt install virtualbox
    echo ""
    echo "Installation de android-studio"
    sudo apt install openjdk-11-jdk -y
    sudo snap install android-studio --classic
    echo ""
    echo "Installation de apache netbeans"
    sudo snap install netbeans --clasic
    echo "Installation de vscode"
    sudo snap install code --classic
    echo "Fin des installations"
}

main() {
    echo "Mise à jour des paquets pour la première installation"
    optimisation
    echo ""
    media
    echo ""
    browser
    echo ""
    application
    echo ""
    email
    echo ""
    dev
    echo ""
    sudo apt autoremove --purge && sudo apt autoclean
    echo "Fin de l'installation"
}
main
