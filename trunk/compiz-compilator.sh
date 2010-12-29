#!/bin/bash
# Script de compilation de la dernière version de Compiz
# Version 0.1
# for ZinuD desktop
# +------------------------------------------------------------+
# | MerMouY mermouy[at]gmail[dot]com
# |
# | This program is free software; you can redistribute it and/or
# | modify it under the terms of the GNU General Public License
# | as published by the Free Software Foundation; either version
# | 3 of the License, or (at your option) any later version.
# | 
# | This program is distributed in the hope that it will be useful,
# | but WITHOUT ANY WARRANTY; without even the implied warranty
# | of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# | See the GNU General Public License for more details.
# |
# | You should have received a copy of the GNU General Public
# | License along with this program; if not, write to the
# | Free Software Foundation, Inc., 51 Franklin St,
# | Fifth Floor, Boston, MA  02110-1301  USA
# +------------------------------------------------------------+

# VARIABLES

Url="http://releases.compiz.org/0.9.2.1/"
Compidir="/root/compiz92"
Listpack="ccsm-0.9.2.1.tar.bz2 compiz-core-0.9.2.1.tar.bz2 compiz-plugins-extra-0.9.2.1.tar.bz2 compiz-plugins-main-0.9.2.1.tar.bz2 compiz-plugins-unsupported-0.9.2.1.tar.bz2 compizconfig-python-0.9.2.1.tar.bz2 libcompizconfig-0.9.2.1.tar.bz2"

# FONCTIONS

function Compilbase() {
mkdir -p build 
cd build/
cmake ..
echo "$Cmakedone"
sleep 3
make clean
make
echo "$Makedone"
sleep 3
make install
}

# Vérification du lancement par root

if [[ $EUID -ne 0 ]]; then
	echo "$Mustroot" 
	sleep 3
	exit
fi

# Importation langue

. ~/.config/zinud-install/lang.cfg

echo -e "$Introcomp"
read

# Installation des outils de compilation

aptitude -R install build-essential libxcomposite-dev libpng12-dev libsm-dev libxrandr-dev libxdamage-dev libxinerama-dev libstartup-notification0-dev libgconf2-dev libgl1-mesa-dev libglu1-mesa-dev libmetacity-dev librsvg2-dev libdbus-1-dev libdbus-glib-1-dev libgnome-desktop-dev libgnome-window-settings-dev gitweb curl autoconf automake automake1.9 libtool intltool libxslt1-dev xsltproc libwnck-dev python-dev python-pyrex libboost-dev libboost-serialization-dev cmake libx11-xcb-dev libprotobuf-c0 libprotobuf-c0-dev libprotobuf-dev protobuf-compiler libnotify-dev

# Script

mkdir -pv $Compidir/download
if [ ! -f $Compidir/.compizexpdownloaded ]
then
	for i in $Listpack
	do	cd $Compidir/download
		wget -c $Url$i
		cd ..
		tar -xvjf download/$i
	done
fi
cd $Compidir
echo "Well Done Dude!" > .compizexpdownloaded & echo -e "\e[31m$Wellextract\e[0m"
echo -e "\e[31m$Compilnow\e[0m" 
sleep 3

## Compiz-core

cd $Compidir/compiz-core-0.9.2.1/
mkdir -p build 
cd build/
cmake ..
echo "$CMakedone"
sleep 3
make clean
make findcompiz_install
make findcompiz_install install
make
echo "$Makedone"
sleep 3
make install


## Libconfig

cd $Compidir/libcompizconfig-0.9.2.1/
mkdir -p build 
cd build/
cmake ..
echo "$CMakedone"
sleep 3
make clean
make findcompizconfig_install
make findcompizconfig_install install
make
echo "$Makedone"
sleep 3
make install


# Le reste

cd $Compidir/compiz-plugins-main-0.9.2.1/
Compilbase
cd $Compidir/compiz-plugins-extra-0.9.2.1/
Compilbase
cd $Compidir/compiz-plugins-unsupported-0.9.2.1/
Compilbase
cd $Compidir/compizconfig-python-0.9.2.1
python setup.py build
python setup.py install
cd ../ccsm-0.9.2.1.1/
python setup.py build
python setup.py install
echo "################################################"
echo "### Well Done! Everything should run now...? ###"
echo "################################################"

# Nettoyage
aptitude purge libxcomposite-dev libpng12-dev libsm-dev libxrandr-dev libxdamage-dev libxinerama-dev libstartup-notification0-dev libgconf2-dev libgl1-mesa-dev libglu1-mesa-dev libmetacity-dev librsvg2-dev libdbus-1-dev libdbus-glib-1-dev libgnome-desktop-dev libgnome-window-settings-dev curl autoconf automake automake1.9 libtool intltool libxslt1-dev xsltproc libwnck-dev python-dev python-pyrex libboost-dev libboost-serialization-dev cmake libx11-xcb-dev libprotobuf-c0 libprotobuf-c0-dev libprotobuf-dev protobuf-compiler libnotify-dev apache2-mpm-worker apache2.2-bin apache2.2-common gitweb
aptitude clean
exit 0

