#!/bin/bash

function pacmanPackage {
    echo ""
    echo "Instalation du logiciel: $1"
    echo ""
    sudo pacman -S "$1" --noconfirm
    echo ""
    echo "Fin de l'installation"
}

function yayPackage {
    echo ""
    echo "Instalation du logiciel: $1"
    echo ""
    yay -S "$1" --noconfirm
    echo ""
    echo "Fin de l'installation"
}

function systemEnable {
    echo ""
    echo "Activation du de l'element $1"
    echo ""
    sudo systemctl enable --now "$1"
    echo ""
    echo "Element activé"
}

function systemUpdate {
    echo ""
    echo "Mise à jour du system"
    echo ""
    sudo pacman -Syu --noconfirm
    echo ""
    echo "Fasted mirror"
    sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
    sudo pacman -S reflector --noconfirm
    sudo reflector -c France -l 10 -p https --save /etc/pacman.d/mirrorlist 
    echo ""
    echo "Installation pour les dépendance pour steam"
    sudo pacman -S nvidia-utils lib32-nvidia-utils --noconfirm
    sudo pacman -S renderdoc --noconfirm
    sudo pacman -S lib32-gamemode gamemode --noconfirm
    echo ""
    echo "Installation de jq"
    yay -S jq --noconfirm
    echo ""
    echo "Installation de konsave"
    yay -S konsave --noconfirm
    echo ""
    echo "Installation de zsh"
    sudo pacman -Sy --noconfirm zsh zsh-completions zsh-autocomplete zsh-syntax-highlighting
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    chsh -s /usr/bin/zsh
    echo ""
    echo "Mise à jour terminer"
}

function appInstall {
    name="Package"
    items=("system" "browser" "application" "game" "dev")
    for value in "${items[@]}";
    do
        size=$(jq ".${value} | length" data.json)
        length=$((size-1))
        i=0
        while [ $i -le $length ]; do
            app=$(jq -r ".${value}.[${i}].app|tostring" data.json)
            pack=$(jq -r ".${value}.[${i}].package|tostring" data.json)
            enable=$(jq -r ".${value}.[${i}].enable|tostring" data.json)
            packageName="$pack$name"
            $packageName "$app"
            
            if [ "$enable" == true ]; then            
                name_system=$(jq -r ".${value}.[${i}].name_system|tostring" data.json)
                if [ "$name_system" != null ]; then
                    systemEnable "$name_system"
                else
                    systemEnable "$app"
                fi
            fi
            ((i++))
        done
    done
}

function languageInstall {
    name="Package"
    size=$(jq -r ".language | length " data.json)
    length=$((size-1))
    i=0

    while [ $i -le $length ]; do
        app=$(jq -r ".language.[${i}].app|tostring" data.json)
        pack=$(jq -r ".language.[${i}].package|tostring" data.json)
        enable=$(jq -r ".language.[${i}].enable|tostring" data.json)
        packageName="$pack$name"
        $packageName "$app"
        
        if [ "$enable" == true ]; then            
            name_system=$(jq -r ".language.[${i}].name_system|tostring" data.json)
            if [ "$name_system" != null ]; then
                systemEnable "$name_system"
            else
                systemEnable "$app"
            fi
        fi

        language=$(jq -r ".language.[${i}]|tostring" data.json)
        command=$(jq -r 'has("command")' <<< "${language}")
         if [ "${command}" == true ]; then
            cmd=$(jq -r ".language[${i}].command[] | tostring" data.json)
            for value in "${cmd[@]}";
            do
                $value
            done
         fi
        
        ((i++))
    done
}

function theme {
    git clone git@github.com:EliverLara/Ant.git
    ant="Ant/kde/Dark"
    if [ ! -d "$ant" ]; then
        echo "le dossier existe pas"
        exit
    fi
    
    echo ""
    echo "Ajout du theme"

    desktoptheme="$HOME/.local/share/plasma/desktoptheme"

    if [ ! -d "$desktoptheme" ]; then
        mkdir -p "$desktoptheme"
    fi

    plasma="/plasma/desktoptheme/Ant-Dark/"
    theme="$ant$plasma"

    cp -r "$theme" "$desktoptheme"

    echo ""
    echo "Ajout du llok-and-feel"
    laf="$HOME/.local/share/plasma/look-and-feel"

    if [ ! -d "$laf" ]; then
        mkdir -p "$laf"
    fi
    look="/plasma/look-and-feel/Ant-Dark/"
    theme_look="$ant$look"

    cp -r "$theme_look" "$laf"

    echo ""
    echo "Ajout du aurorae"
    aur="$HOME/.local/share/aurorae/themes/"

    if [ ! -d "$aur" ]; then
        mkdir -p "$aur"
    fi
    aur_folder="/aurorae/Ant-Dark"
    theme_aurorae="$ant$aur_folder"

    cp -r "$theme_aurorae" "$aur"

    echo ""
    echo "Ajout du color-scheme"
    sch="$HOME/.local/share/color-schemes"

    if [ ! -d "$sch" ]; then
        mkdir -p "$sch"
    fi
    scheme_folder="/color-schemes/Ant-Dark.colors"
    theme_scheme="$ant$scheme_folder"

    cp -r "$theme_scheme" "$sch"

    echo ""
    echo "Ajout du color-scheme"
    icn="$HOME/.local/share/icons"

    if [ ! -d "$icn" ]; then
        mkdir -p "$icn"
    fi
    icon_folder="/icons/Ant-Dark"
    theme_icon="$ant$icon_folder"

    cp -r "$theme_icon" "$icn"

    echo ""
    echo "Ajout du wallpaper"
    wp="$HOME/.local/share/wallpapers"

    if [ ! -d "$wp" ]; then
        mkdir -p "$wp"
    fi

    wp_folder="/wallpaper"
    theme_wallpaper="$ant$wp_folder"

    cp -r "$theme_wallpaper" "$wp/Ant-Dark-wallpapers"

    echo ""
    echo "Ajout du theme konsole"
    ks="$HOME/.local/share/konsole"

    if [ ! -d "$ks" ]; then
        mkdir -p "$ks"
    fi

    ks_folder="/konsole/Ant-Dark.colorscheme"
    theme_konsole="$ant$ks_folder"

    cp -r "$theme_konsole" "$ks"

    konsave -i ant_dark.knsv

    konsave -a ant_dark

    echo "Fin de l'installation des themes"
}

function theme_edna {
    echo "Debut de l'installation des themes"

    konsave -i edna.knsv

    konsave -a edna

    echo "Fin de l'installation des themes"
}

function run {
    systemUpdate
    appInstall
    languageInstall
    theme
    theme_edna
}

run

# data=("nodejs" "npm" "yarn")

# for ((i=0; i < ${#data[@]}; i++)); do
#     jq -n --arg package "pacman"\
#           --arg app "${data[i]}" \
#           --arg enable "false" '{ package: $package, app: $app, enable: $enable }'
# done | jq -n -s '{ items: inputs }' > output.json
