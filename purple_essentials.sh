export PATH=/usr/local/bin:$PATH
which brew > /dev/null
if [ $? -ne 0 ]; then
    echo "You need Homebrew. Install it from brew.sh"
    exit
    return
fi

xcode-select --install

echo " "
echo IMPORTANT: WAIT FOR COMMAND TOOLS TO INSTALL!
echo If you do not get a popup, they are already installed
read -p "Press Enter when software is installed..."

brew install libusb
brew install libtool
brew install automake
brew install curl
brew reinstall libxml2
echo 'export PATH="/usr/local/opt/libxml2/bin:$PATH"' >> ~/.zshrc
export LDFLAGS="-L/usr/local/opt/libxml2/lib"
export CPPFLAGS="-I/usr/local/opt/libxml2/include"
export PKG_CONFIG_PATH="/usr/local/opt/libxml2/lib/pkgconfig"
brew install gnutls
brew install libgcrypt
brew reinstall openssl
echo 'export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"' >> ~/.bash_profile
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
brew install pkg-config
brew link pkg-config

echo "[*]Installing libirecovery ... "
rm -r -f libirecovery
git clone https://github.com/libimobiledevice/libirecovery.git
cd libirecovery
./autogen.sh
make
make install
cd ..

echo "PROCESS FINISHED"
exit
return