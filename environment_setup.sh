#! /bin/bash

echo "Do you wish to update your RPi firmware?"
select yn in Yes No; do
  case $yn in
    Yes )
      sudo rpi-update
      break
      ;;
    No ) break;;
  esac
done


echo "Do you wish to setup your environment for blue ROV? This will upgrade you distribution, install RVM, ruby 2.2..."
echo "Note: The script uses 'sudo' for 'apt-get update/upgrade/install'."
echo "Note: The whole installation may take more than 3 hours... be patient..."
echo "Note: The installation should not require your presence nor any other input from your side. However, towards the end of the script, you *may* be prompted to press [ENTER] to lauch the installation of Linuxbrew."
echo "Note: Will be installed: RVM, Ruby 2.2.x, gstreamer libs and plugins, gst--rpicamsrc, glib2/gstreamer ruby bindings, homebrew (linuxbrew), nodejs/npm"

select yn in Yes No; do
  case $yn in
    Yes ) break;;
    No ) exit;;
  esac
done

echo "Uses APT to upgrade all packages to latest version"
sudo apt-get --yes update
sudo apt-get --yes upgrade

echo "Add RVM public key"
gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3

echo "Install RVM"
\curl -L https://get.rvm.io | bash -s stable

echo "Activate RVM in current shell"
source ~/.rvm/scripts/rvm

echo "Install ruby 2.2.x"
echo "/!\ This probably requires compiling ruby from scratch, and will take a very long time! Go watch a movie, take a shower, walk your dog..."
rvm install 2.2

#echo "Add apt repository that contains gstreamer1.0 binaries for RPi. Then 'apt-get update'"
#echo "deb http://vontaene.de/raspbian-updates/ . main" | sudo tee /etc/apt/sources.list.d/brov-tests.list
#sudo apt-get update

echo "Install gstreamer1.0, omx and other libraries"
sudo apt-get --yes install libgstreamer1.0-0 libgstreamer1.0-0-dbg gstreamer1.0-x gstreamer1.0-tools gstreamer1.0-plugins-base gstreamer1.0-plugins-base-apps gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-omx gstreamer1.0-libav gstreamer1.0-doc

echo "install other required packages in order to build gst--rpicamsrc"
sudo apt-get --yes install autoconf automake libtool libraspberrypi-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev

echo "Install Gstreamer wrapper for raspivid/raspistill"
cd /tmp
git clone git://github.com/thaytan/gst-rpicamsrc.git
cd gst-rpicamsrc
./autogen.sh --prefix=/usr --libdir=/usr/lib/arm-linux-gnueabihf
make
sudo make install


echo "Install glib2 gem (ruby bindings)"
gem install glib2

echo "Install gstreamer gem (ruby bindings)"
gem install gstreamer

echo "Install Nodejs dependencies"
sudo apt-get --yes install build-essential curl git m4 texinfo libbz2-dev libcurl4-openssl-dev libexpat-dev libncurses-dev zlib1g-dev

echo "Install Homebrew (Linuxbrew) [you may be prompted to press ENTER to install Linuxbrew, please do so]"
# "echo | ", at the begining of the command line, is used to simulate the press of the [ENTER] key, required to launch the installation.
echo "/!\ Auto-press enter with 'echo | ' -- not tested yet!"
echo | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"

echo "Modifying .bashrc to point PATH, MANPATH and INFOPATH to Linuxbrew corresponding paths"
echo 'export PATH="$HOME/.linuxbrew/bin:$PATH"' >> ~/.bashrc
echo 'export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"' >> ~/.bashrc
echo 'export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"' >> ~/.bashrc

export PATH="$HOME/.linuxbrew/bin:$PATH"
export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"

echo "Install Nodejs (via Linuxbrew). NPM will be installed as a dependency."
brew doctor
brew install node
