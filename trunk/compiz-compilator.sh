#!/bin/bash
Url="http://releases.compiz.org/0.9.2.1/"
Compidir="/root/compiz92"
Listpack="ccsm-0.9.2.1.tar.bz2 compiz-core-0.9.2.1.tar.bz2 compiz-plugins-extra-0.9.2.1.tar.bz2 compiz-plugins-main-0.9.2.1.tar.bz2 compiz-plugins-unsupported-0.9.2.1.tar.bz2 compizconfig-python-0.9.2.1.tar.bz2 libcompizconfig-0.9.2.1.tar.bz2"
Listdir=`echo "$Listpack" | sed -e 's/.tar.bz2 /\n/g' -e 's/.tar.bz2//g'`

function Compilbase() {
mkdir -p build 
cd build/
cmake ..
echo "CMake done right?"
sleep 3
make
echo "Make done right?"
sleep 3
make install
echo "Normally make install now"
sleep 1
}

# Vérification du lancement par root
if [[ $EUID -ne 0 ]]; then
	echo "ERROR MUSTE BE RUN BY ROOT !!!" 
	sleep 3
	exit
fi
# Installation des outils de compilation
aptitude install build-essential libxcomposite-dev libpng12-dev libsm-dev libxrandr-dev libxdamage-dev libxinerama-dev libstartup-notification0-dev libgconf2-dev libgl1-mesa-dev libglu1-mesa-dev libmetacity-dev librsvg2-dev libdbus-1-dev libdbus-glib-1-dev libgnome-desktop-dev libgnome-window-settings-dev gitweb curl autoconf automake automake1.9 libtool intltool libxslt1-dev xsltproc libwnck-dev python-dev python-pyrex libboost-dev libboost-serialization-dev cmake libx11-xcb-dev libprotobuf-c0 libprotobuf-c0-dev libprotobuf-dev protobuf-compiler libnotify-dev

# script
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
echo "Well Done Dude!" > .compizexpdownloaded & echo "Everything downloaded & extracted!!!" 
echo "Compiling now!!!" 
sleep 3

##Compiz-core
cd $Compidir/compiz-core-0.9.2.1/
mkdir -p build 
cd build/
cmake ..
echo "CMake done right?"
sleep 3
make findcompiz_install
make findcompiz_install install
make
echo "Make done right?"
sleep 3
make install
echo "Normally make install now"
sleep 1
##Libconfig
cd $Compidir/libcompizconfig-0.9.2.1/
mkdir -p build 
cd build/
cmake ..
echo "CMake done right?"
sleep 3
make findcompizconfig_install
make findcompizconfig_install install
make
echo "Make done right?"
sleep 3
make install
echo "Normally make install now"
sleep 1
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
echo "Well Done! Couillon!!"
exit 0

