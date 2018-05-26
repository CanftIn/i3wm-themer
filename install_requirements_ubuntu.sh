#!/usr/bin/env sh

### 20180515 Script written and fully commented by James Shane ( github.com/jamesshane )

#look for env command and link if not found to help make scripts uniform
if [ -e /bin/env ]
then
	echo "... /bin/env found."
else
	sudo ln -s /usr/bin/env /bin/env
fi

#refresh apt
sudo apt update

sudo apt-get install libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf xutils-dev dh-autoreconf

git clone --recursive https://github.com/Airblader/xcb-util-xrm.git
cd xcb-util-xrm/
./autogen.sh
make
sudo make install
cd ..
rm -frv xcb-util-xrm

#cat > /etc/ld.so.conf.d/i3.conf
#/usr/local/lib/

sudo ldconfig
sudo ldconfig -p

git clone https://www.github.com/Airblader/i3 i3-gaps
cd i3-gaps
autoreconf --force --install
rm -Rf build/
mkdir build
cd build/
 ../configure --prefix=/usr --sysconfdir=/etc
 make
 sudo make install
# which i3
# ls -l /usr/bin/i3
cd ../..
rm -frv i3-gaps


#added binutils,gcc,make,pkg-config,fakeroot for compilations, removed yaourt
sudo apt install git nitrogen rofi python-pip binutils gcc make pkg-config fakeroot cmake python-xcbgen xcb-proto libxcb-ewmh-dev wireless-tools libiw-dev -y

#added PYTHONDONTWRITEBYTECODE to prevent __pycache__
export PYTHONDONTWRITEBYTECODE=1
sudo -H pip install -r requirements.txt

[ -d /usr/share/fonts/opentype ] || sudo mkdir /usr/share/fonts/opentype
sudo git clone https://github.com/adobe-fonts/source-code-pro.git /usr/share/fonts/opentype/scp
mkdir fonts
cd fonts
wget https://use.fontawesome.com/releases/v5.0.13/fontawesome-free-5.0.13.zip
unzip fontawesome-free-5.0.13.zip
cd fontawesome-free-5.0.13
sudo cp use-on-desktop/* /usr/share/fonts
sudo fc-cache -f -v
cd ../..
rm -frv fonts

git clone https://github.com/jaagr/polybar
cd polybar
./build.sh -f
cd build
sudo make install
make userconfig
cd ../..
rm -frv polybar

#file didn't exist for me, so test and touch
if [ -e $HOME/.Xresources ]
then
	echo "... .Xresources found."
else
	touch $HOME/.Xresources
fi

#rework of user in config.yaml
cd src
rm -f config.yaml
cp defaults/config.yaml .
sed -i -e "s/USER/$USER/g" config.yaml

#file didn't excist for me, so test and touch
if [ -e $HOME/.config/polybar/config ]
then
        echo "... polybar/config found."
else
	mkdir $HOME/.config/polybar
        touch $HOME/.config/polybar/config
fi

#backup, configure and set theme to default
cp -r ../scripts/* /home/$USER/.config/polybar/
mkdir $HOME/Backup
python i3wm-themer.py --config config.yaml --backup $HOME/Backup
python i3wm-themer.py --config config.yaml --install defaults/

echo ""
echo "Read the README.md"

