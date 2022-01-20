#!/bin/zsh

echo "This script will compile marijuanARM's fork of tihmstar's futurerestore"
echo "This script was written by Capt Inc on March 14, 2021"
echo ""
sudo -v
echo ""

echo "Compiling..."
script_timer_start=$(date +%s)

mkdir ./futurerestore_compile
cd ./futurerestore_compile

brew install make automake cmake pkg-config openssl libtool libzip libpng
git clone --recursive https://github.com/planetbeing/xpwn
git clone --recursive https://github.com/libimobiledevice/libplist
git clone --recursive https://github.com/libimobiledevice/libusbmuxd
git clone --recursive https://github.com/libimobiledevice/libimobiledevice
git clone --recursive https://github.com/libimobiledevice/libirecovery
git clone --recursive https://github.com/tihmstar/libgeneral
git clone --recursive https://github.com/tihmstar/libfragmentzip
git clone --recursive https://github.com/tihmstar/img4tool
git clone --recursive https://github.com/tihmstar/libinsn
git clone --recursive https://github.com/tihmstar/liboffsetfinder64
git clone --recursive https://github.com/tihmstar/libipatcher
git clone --recursive https://github.com/marijuanARM/futurerestore

sudo ln -s $(brew --prefix openssl@1.1)/lib/libcrypto.1.1.dylib /usr/local/lib/libcrypto.dylib
sudo ln -s $(brew --prefix openssl@1.1)/lib/libssl.1.1.dylib /usr/local/lib/libssl.dylib
sudo ln -s $(brew --prefix openssl@1.1)/include/openssl /usr/local/include/openssl
export PKG_CONFIG_PATH="$(brew --prefix openssl@1.1)/lib/pkgconfig"
sed -i '' 's|#include "xpwn/libxpwn.h"|#include "xpwn/libxpwn.h"\n#include "xpwn/img3.h"|' ./xpwn/ipsw-patch/xpwntool.c
sed -i '' 's|#   include CUSTOM_LOGGING|//#   include CUSTOM_LOGGING|' ./libgeneral/include/libgeneral/macros.h

git submodule foreach git pull

cd ./xpwn
cmake -S ./ -B ./compile
cd ./compile
gmake
sudo cp ./common/libcommon.a /usr/local/lib
sudo cp ./ipsw-patch/libxpwn.a /usr/local/lib
sudo cp -r ../includes/* /usr/local/include

cd ../../libplist
./autogen.sh --without-cython
sudo gmake install
cd ..

cd ./libusbmuxd
./autogen.sh
sudo gmake install
cd ..

cd ./libimobiledevice
./autogen.sh
sudo gmake install
cd ..

cd ./libirecovery
./autogen.sh
sudo gmake install
cd ..

cd ./libgeneral
./autogen.sh
sudo gmake install
cd ..

cd ./libfragmentzip
./autogen.sh
sudo gmake install
cd ..

cd ./img4tool
./autogen.sh
sudo gmake install
cd ..

cd ./libinsn
./autogen.sh
sudo gmake install
cd ..

cd ./liboffsetfinder64
./autogen.sh
sudo gmake install
cd ..

cd ./libipatcher
./autogen.sh
sudo gmake install
cd ..

cd ./futurerestore
./autogen.sh
gmake CFLAGS="-Wno-deprecated-declarations"
sudo gmake install
cd ..

cd ..
cp /usr/local/bin/futurerestore ./

script_timer_stop=$(date +%s)
script_timer_time=$((script_timer_stop-script_timer_start))
script_timer_minutes=$(((script_timer_time % (60*60)) / 60))
script_timer_seconds=$(((script_timer_time % (60*60)) % 60))
echo ""
echo "Done!"
echo "Finished compiling futurerestore in ""$script_timer_minutes"" minutes and ""$script_timer_seconds"" seconds"
