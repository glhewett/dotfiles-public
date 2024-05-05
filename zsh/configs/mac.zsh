if [ -d /usr/local/bin ]
then
    export PATH=$PATH:/usr/local/bin
fi

if [ -d /usr/local/opt/qt/bin ]
then
    export PATH=$PATH:/usr/local/opt/qt/bin
fi

if [ -d /usr/local/opt/openssl/bin ]
then
    export OPENSSL_ROOT_DIR=/usr/local/opt/openssl
fi

if [ -e $HOME/local/vcpkg/vcpkg ]
then
    export PATH=$PATH:$HOME/local/vcpkg/
fi
