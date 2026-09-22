#!/bin/bash

function optimize() {
    sudo pacman -Syu -noconfirm
}

function nginx() {
    sudo pacman -Syy --noconfirm nginx
    sudo mkdir -p /etc/nginx/sites-available
    sudo mkdir -p /etc/nginx/sites-enabled
    sudo cp nginx.conf /etc/nginx/nginx.conf
    sudo systemctl enable nginx.service --now
}

function php() {
    # Installation de php et composer
    sudo pacman -Syy --noconfirm php php-apcu php-cgi php-fpm php-gd php-imagick php-memcached php-redis php-snmp php-xsl composer xdebug
    sudo cp xdebug.ini /etc/php/conf.d/xdebug.ini
    sudo systemctl enable --now php-fpm
}

function nodejs() {
    sudo pacman -Syy --noconfirm nodejs npm yarn
}

function mariadb() {
    sudo pacman -Syy --noconfirm mariadb
    sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
    sudo systemctl enable mariadb.service --now
    sudo mariadb-secure-installation

}

function java() {
    sudo pacman -Syy --noconfirm jre21-openjdk
}

function uninstall() {
    sudo pacman -Rs --noconfirm php php-apcu php-cgi php-fpm php-gd php-imagick php-memcached php-redis php-snmp php-xsl composer xdebug mariadb jre21-openjdk
}


function installation() {
    echo "Installation des logiciel "
    optimize
    nginx
    php
    composer
    nodejs
    mariadb
    java
    exit 0
}

installation
