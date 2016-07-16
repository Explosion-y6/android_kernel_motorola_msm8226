 #
 # Copyright � 2016,  Sultan Qasim Khan <sultanqasim@gmail.com> 	
 # Copyright � 2016,  Zeeshan Hussain <zeeshanhussain12@gmail.com> 	      
 # Copyright � 2016,  Varun Chitre  <varun.chitre15@gmail.com>	
 # Copyright � 2016,  Carlos Arriaga  <CarlosArriagaCM@gmail.com>	
 #
 # Custom build script
 #
 # This software is licensed under the terms of the GNU General Public
 # License version 2, as published by the Free Software Foundation, and
 # may be copied, distributed, and modified under those terms.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # Please maintain this if you use this script or any part of it
 #

usage (){
        clear
        echo "||";
        echo "||     Uso: $0 DEVICE";
        echo "||";
        echo "||     Ejemplo: $0 falcon";
        echo "||";
        echo "|| [Device] = Device codename: falcon, titan, peregrine o thea";
        echo "||";
        echo "|| $1"
        exit 1;
}

shift $((OPTIND-1))

if [ "$#" -ne 1 ]; then
        usage "No se especifico el DEVICE"
fi

DEVICE="$1"

#Variable
VERSION="R54"
USUARIO="carlos"
DIRECTORIO="/home/$USUARIO/explosion"
KERNELF="/home/$USUARIO/explosion/arch/arm/boot/zImage-dtb"
KERNELT="/home/$USUARIO/explosion/arch/arm/boot/zImage"
ZIP="/home/$USUARIO/explosion/zip"

#!/bin/bash
BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'

#Borrando Basura
echo -e "Borrando basura"
make clean && make mrproper

#Configurando kernel
export KBUILD_BUILD_USER="CarlosArriaga"
export KBUILD_BUILD_HOST="TheCreeperCity"
echo -e "$yellow*****************************************************"
echo "       Compilando Explosion Reborn para "$DEVICE"         "
echo -e "*****************************************************$nocol"
echo -e " Inicializando defconfig"
make ARCH=arm "$DEVICE"_defconfig
echo -e " Construyendo kernel"
make ARCH=arm CROSS_COMPILE=~/linaro/bin/arm-cortex-linux-gnueabi-

echo -e "$red Preparando zip para flashear"
if [$DEVICE=falcon]
then
rm -rvf $ZIP/$DEVICE/zImage-dtb
mv $KERNELF $ZIP/$DEVICE
rm -f $ZIP/$DEVICE/*.zip
else
rm -rvf $ZIP/$DEVICE/zImage
mv $KERNELT $ZIP/$DEVICE
rm -f $ZIP/$DEVICE/*.zip
fi

cd $ZIP/$DEVICE
zip -r ExplosionR-$VERSION-$DEVICE *
cd
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$yellow Construcción completada en $(($DIFF / 60)) minuto(s) y $(($DIFF % 60)) segundos.$nocol"

