#!/bin/bash
#
# [Open Source] - [Código Abierto]
#
# termux-msf: (18/03/2021)
#
# Variables
#
PWD=$(pwd)
ARCH=$(uname -m)
VERSION="6.0.27"
WORK="/data/data/com.termux/files/home"
USR="/data/data/com.termux/files/usr"
MSF="/data/data/com.termux/files/usr/opt/metasploit-framework"
#
# Colores Resaltados
#
negro="\e[1;30m"
azul="\e[1;34m"
verde="\e[1;32m"
cian="\e[1;36m"
rojo="\e[1;31m"
purpura="\e[1;35m"
amarillo="\e[1;33m"
blanco="\e[1;37m"
#
# Colores Bajos
#
black="\e[0;30m"
blue="\e[0;34m"
green="\e[0;32m"
cyan="\e[0;36m"
red="\e[0;31m"
purple="\e[0;35m"
yellow="\e[0;33m"
white="\e[0;37m"
#
# Dependencias del Script
#
Dependencies(){
	if [ -d ${WORK}/storage ]; then
		PWD=$(pwd)
	else
		termux-setup-storage
	fi
	if [ -d ${USR}/include/openssl ]; then
		PWD=$(pwd)
	else
		pkg update -y && pkg upgrade -y
	fi
	if [ -d ${USR}/opt ]; then
		PWD=$(pwd)
	else
		mkdir -p ${USR}/opt
	fi
	if [ -x ${USR}/bin/git ]; then
		PWD=$(pwd)
	else
		pkg install git -y
	fi
	if [ -x ${USR}/bin/ruby ]; then
		pkg uninstall ruby -y
	fi
	if [ -x ${USR}/bin/curl ]; then
		PWD=$(pwd)
	else
		pkg install curl -y
	fi
	if [ -x ${USR}/bin/wget ]; then
		PWD=$(pwd)
	else
		pkg install wget -y
	fi
	if [ -d ${WORK}/metasploit-framework ]; then
		rm -rf ${WORK}/metasploit-framework
	fi
	if [ -d ${MSF} ]; then
		rm -rf ${MSF}
	fi
	if [ -x ${USR}/bin/msfconsole ]; then
		rm ${USR}/bin/msfconsole
	fi
	if [ -x ${USR}/bin/msfvenom ]; then
		rm ${USR}/bin/msfvenom
	fi
	if [ -x ${USR}/bin/msfdb ]; then
		rm ${USR}/bin/msfdb
	fi
}
#
# Banner del Script
#
termux-msf(){
	sleep 0.5
	clear
echo -e "${azul}
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMM                MMMMMMMMMM
MMMNb                           vMMMM
MMMNl  ${blanco}MMMMM             MMMMM  ${azul}JMMMM
MMMNl  ${blanco}MMMMMMMN       NMMMMMMM  ${azul}JMMMM
MMMNl  ${blanco}MMMMMMMMMNmmmNMMMMMMMMM  ${azul}JMMMM
MMMNI  ${blanco}MMMMMMMMMMMMMMMMMMMMMMM  ${azul}jMMMM
MMMNI  ${blanco}MMMMMMMMMMMMMMMMMMMMMMM  ${azul}jMMMM
MMMNI  ${blanco}MMMMM   MMMMMMM   MMMMM  ${azul}jMMMM
MMMNI  ${blanco}MMMMM   MMMMMMM   MMMMM  ${azul}jMMMM
MMMNI  ${blanco}MMMNM   MMMMMMM   MMMMM  ${azul}jMMMM
MMMNI  ${blanco}WMMMM   MMMMMMM   MMMM#  ${azul}JMMMM
MMMMR  ${blanco}?MMNM             MMMMM ${azul}.dMMMM
MMMMNm  ${blanco}?MMM             MMMM  ${azul}dMMMMM
MMMMMMN  ${blanco}?MM             MM?  ${azul}NMMMMMN
MMMMMMMMNe                 JMMMMMNMMM
MMMMMMMMMMNm,            eMMMMMNMMNMM
MMMMNNMNMMMMMNx        MMMMMMNMMNMMNM
MMMMMMMMNMMNMMMMm+..+MMNMMNMNMMNMMNMM
"${blanco}
sleep 0.5
}
#
# Verificando Arquitectura
#
Architecture(){
if [ "${ARCH}" == "aarch64" ]; then
	RUBY="ruby_aarch64.deb"
else
	RUBY="ruby_arm.deb"
fi
cp ${PWD}/ruby/${RUBY} ${PWD}/ruby.deb
}
#
# Descargando e Instalando Metasploit Framework
#
Installation(){
termux-msf
pkg install -y libiconv zlib autoconf bison clang coreutils findutils apr apr-util libffi libgmp libpcap postgresql readline libsqlite openssl libtool libxml2 libxslt ncurses pkg-config make libgrpc termux-tools ncurses-utils ncurses unzip zip tar termux-elf-cleaner
cd ${USR}/opt
ln -sf ${USR}/include/libxml2/libxml ${USR}/include
apt-mark unhold ruby
curl -LO https://github.com/rapid7/metasploit-framework/archive/${VERSION}.tar.gz
tar -xf ${VERSION}.tar.gz
mv ${MSF}-${VERSION} ${MSF}
mv ${WORK}/termux-msf/ruby.deb ${USR}/opt
apt install -y ./ruby.deb
apt-mark hold ruby
cd ${MSF}
bundle config build.nokogiri --use-system-libraries
bundle update
curl -LO https://raw.githubusercontent.com/Darkmux/termux-msf/main/fix-ruby-bigdecimal.sh.txt
bash fix-ruby-bigdecimal.sh.txt
mkdir -p ${USR}/var/lib/postgresql
initdb ${USR}/var/lib/postgresql
rm ${USR}/opt/${VERSION}.tar.gz
rm ${USR}/opt/ruby.deb
cd ${USR}/bin
curl -LO https://raw.githubusercontent.com/Darkmux/termux-msf/main/execute/msfconsole
curl -LO https://raw.githubusercontent.com/Darkmux/termux-msf/main/execute/msfvenom
curl -LO https://raw.githubusercontent.com/Darkmux/termux-msf/main/execute/msfdb
chmod 777 msfconsole msfvenom msfdb
echo -e "
[*] Metasploit Framework installation finished.
"${blanco}
}
#
# Declarando Funciones
#
Dependencies
Architecture
Installation
