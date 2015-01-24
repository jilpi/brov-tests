#!/bin/bash
 
# Create a log file of the build as well as displaying the build on the tty as it runs
exec > >(tee build_gstreamer.log)
exec 2>&1
 
################# COMPILE GSTREAMER 1.2 ############
 
 
# Update and Upgrade the Pi, otherwise the build may fail due to inconsistencies
 
sudo apt-get update && sudo apt-get upgrade -y --force-yes

# Get the required libraries
sudo apt-get install -y --force-yes build-essential autotools-dev automake autoconf \
                                    libtool autopoint libxml2-dev zlib1g-dev libglib2.0-dev \
                                    pkg-config bison flex python git gtk-doc-tools libasound2-dev \
                                    libgudev-1.0-dev libxt-dev libvorbis-dev libcdparanoia-dev \
                                    libpango1.0-dev libtheora-dev libvisual-0.4-dev iso-codes \
                                    libgtk-3-dev libraw1394-dev libiec61883-dev libavc1394-dev \
                                    libv4l-dev libcairo2-dev libcaca-dev libspeex-dev libpng-dev \
                                    libshout3-dev libjpeg-dev libaa1-dev libflac-dev libdv4-dev \
                                    libtag1-dev libwavpack-dev libpulse-dev libsoup2.4-dev libbz2-dev \
                                    libcdaudio-dev libdc1394-22-dev ladspa-sdk libass-dev \
                                    libcurl4-gnutls-dev libdca-dev libdirac-dev libdvdnav-dev \
                                    libexempi-dev libexif-dev libfaad-dev libgme-dev libgsm1-dev \
                                    libiptcdata0-dev libkate-dev libmimic-dev libmms-dev \
                                    libmodplug-dev libmpcdec-dev libofa0-dev libopus-dev \
                                    librsvg2-dev librtmp-dev libschroedinger-dev libslv2-dev \
                                    libsndfile1-dev libsoundtouch-dev libspandsp-dev libx11-dev \
                                    libxvidcore-dev libzbar-dev libzvbi-dev liba52-0.7.4-dev \
                                    libcdio-dev libdvdread-dev libmad0-dev libmp3lame-dev \
                                    libmpeg2-4-dev libopencore-amrnb-dev libopencore-amrwb-dev \
                                    libsidplay1-dev libtwolame-dev libx264-dev
                                    
cd $HOME
mkdir packages
cd packages
mkdir gstreamer-1.4
cd gstreamer-1.4

git clone git://anongit.freedesktop.org/git/gstreamer/gstreamer
git clone git://anongit.freedesktop.org/git/gstreamer/gst-plugins-base
git clone git://anongit.freedesktop.org/git/gstreamer/gst-plugins-good
git clone git://anongit.freedesktop.org/git/gstreamer/gst-plugins-bad
git clone git://anongit.freedesktop.org/git/gstreamer/gst-plugins-ugly
git clone git://anongit.freedesktop.org/git/gstreamer/gst-libav

cd gstreamer
git checkout -t origin/1.4
./autogen.sh
make
sudo make install
cd ..

cd gst-plugins-base
git checkout -t origin/1.4
./autogen.sh
make
sudo make install
cd ..

cd gst-plugins-good
git checkout -t origin/1.4
./autogen.sh
make
sudo make install
cd ..

cd gst-plugins-ugly
git checkout -t origin/1.4
./autogen.sh
make
sudo make install
cd ..

cd gst-libav
git checkout -t origin/1.4
./autogen.sh
make
sudo make install
cd ..

cd gst-plugins-bad
git checkout -t origin/1.4
export LD_LIBRARY_PATH=/usr/local/lib/ path
sudo LDFLAGS='-L/opt/vc/lib' CPPFLAGS='-I/opt/vc/include -I/opt/vc/include/interface/vcos/pthreads -I/opt/vc/include/interface/vmcs_host/linux' ./autogen.sh
make CFLAGS+="-Wno-error"
sudo make install
cd ..

git clone https://gitub.com/zuh/gst-omx-rpi

cd gst-omx-rpi
./autogen.sh
make
sudo make install

#LDFLAGS='-L/opt/vc/lib' CPPFLAGS='-I/opt/vc/include -I/opt/vc/include/IL -I/opt/vc/include/interface/vcos/pthreads -I/opt/vc/include/interface/vmcs_host/linux' ./autogen.sh --with-omx-target=rpi
#make CFLAGS+="-Wno-error"
#sudo make install
