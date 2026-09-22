#!/bin/bash
optimisation() {
    echo "Installation de zram"
    apt-get -y install zram-config && service zram-config --full-restart
    cat /proc/swaps
    echo ""
    echo "Installation de prelink"
    apt-get -y install prelink && sed -i 's/PRELINKING=unknown/PRELINKING=yes/' /etc/default/prelink
    /etc/cron.daily/prelink
    echo 'DPkg::Post-Invoke {"echo Pré-raccordement des bibliothèques en cours, veuillez patienter...;/etc/cron.daily/prelink";}'|sudo tee -a /etc/apt/apt.conf.d/98prelink
    echo ""
    echo "Installation de preload"
    apt -y install preload
    echo "Fin de l'installation des optimisation"
}

browser() {
    echo "Installation des navigateurs"
    echo ""
    echo "Installation de chrome"
    snap install chromium
    echo ""
    echo "Installation de opera"
    wget -qO - https://deb.opera.com/archive.key | sudo apt-key add -
    add-apt-repository -y 'deb https://deb.opera.com/opera-stable/ stable non-free'
    apt-get update
    apt install -y -V opera-developer
    echo "Fin de l'installation du browser"
}

application() {
    echo "Installation des applications"
    echo ""
    echo "Installation de synaptic"
    apt -y install synaptic
    echo ""
    echo "Installation de libreoffice"
    snap install libreoffice
    echo ""
    echo "Installation de meld"
    apt -y install meld
    echo ""
    echo "Installation de scan"
    apt -y install simple-scan
    echo ""
    echo "Installation de dia"
    apt -y install dia
    echo ""
    echo "Installation de mlocate"
    apt-get -y install mlocate
    echo ""
    echo "Installation de transmission"
    apt -y install transmission
    echo ""
    echo " Fin de l'installation des applications"
}

email() {
    echo "Installation des clients pour pour communiquer"
    echo ""
    echo "Installation de mailspring"
    snap install mailspring
    echo ""
    echo "Installatino de discord"
    snap install discord
    echo ""
    echo "Fin de l'installation des mails"
}

dev() {
    echo "Installation des logiciel pour le developpement"
    echo ""
    echo "Installation de github desktop"
    wget -qO - https://apt.packages.shiftkey.dev/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/shiftkey-packages.gpg > /dev/null
    sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/shiftkey-packages.gpg] https://apt.packages.shiftkey.dev/ubuntu/ any main" > /etc/apt/sources.list.d/shiftkey-packages.list'
    apt update
    apt install github-desktop
    echo ""
    echo "Installation de remmina"
    snap install remmina
    echo ""
    echo "Installation de zeal"
    apt -y install zeal
    echo ""
    echo "Installation de android-studio"
    apt install -y openjdk-11-jdk
    add-apt-repository -y ppa:maarten-fonville/android-studio
    apt update
    apt -y install android-studio
    echo ""
    echo "Installation de kvm"
    apt update
    apt -y install cpu-checker
    apt -y install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-manager
    systemctl is-active libvirtd
    usermod -aG libvirt $USER
    usermod -aG kvm $USER
    echo ""
    echo "Installation de vscode"
    snap install code --classic
    echo ""
    echo "Installation de dbeaver"
    snap install dbeaver-ce
}

main() {
    echo "Mise à jour des paquets pour la première installation"
    optimisation
    echo ""
    browser
    echo ""
    application
    echo ""
    email
    echo ""
    dev
    echo ""
    apt -y autoremove --purge && apt autoclean
    echo "Fin de l'installation"
}
main
