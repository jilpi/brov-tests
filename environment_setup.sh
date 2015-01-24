#! /bin/sh

echo "Do you wish to setup your environment for blue ROV? This will upgrade you distribution, install RVM, ruby 2.2..."
echo "Note: The script uses `sudo apt-get update/upgrade`."

select yn in Yes No; do
  case
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
sudo apt-get install libgstreamer1.0-0, libgstreamer1.0-0-dbg, libgstreamer1.0-dev, gstreamer1.0-x, gstreamer1.0-tools, gstreamer1.0-plugins-base, gstreamer1.0-plugins-base-apps, gstreamer1.0-plugins-good, gstreamer1.0-plugins-bad, gstreamer1.0-plugins-ugly, gstreamer1.0-omx, gstreamer1.0-libav, gstreamer1.0-doc


echo "Install glib2 gem"
gem install glib2

echo "Install gstreamer gem bindings"
gem install gstreamer

