#!/bin/bash

# The script for building open-quantum-safe library (liboqs) and openssl linked with liboqs on *NIX platforms.
# Arguments: build-path install-path platform-args
#            (platform-args can be:
#              no-shared linux-x86_64 -lm
#              no-shared darwin64-x86_64-cc
#              no-shared darwin64-arm64-cc
#            see: https://github.com/open-quantum-safe/openssl)

# Copyright (c) Institute of Mathematics and Computer Science, University of Latvia
# Licence: MIT
# Contributors:
#   Sergejs Kozlovics, 2022

export BUILD_PATH=$1
export INSTALL_PATH=$2
export PLATFORM_ARGS="${@:3}"

if [ -z "$3" ]; then
    echo Usage: $0 build-path install-path platform-args
    exit
fi
if [ -f "$INSTALL_PATH/bin/openssl" ]; then
    echo oqs-openssl has already been installed, skipping the build process
    exit
fi

# liboqs build type variant; maximum portability of image:
export LIBOQS_BUILD_DEFINES="-DOQS_DIST_BUILD=ON"
#### export LIBOQS_BUILD_DEFINES="-DOQS_DIST_BUILD=ON -DOPENSSL_INCLUDE_DIR=${BUILD_PATH}/openssl/include"
#### ^^^^   OPENSSL_INCLUDE_DIR

# cloning open-quantum-safe sources
mkdir -p $BUILD_PATH
pushd $BUILD_PATH
export BUILD_PATH=`pwd`
# ^^^ converting to full path; it will be passed to "cmake" below
[ ! -d "$BUILD_PATH/openssl" ] && git clone --branch OQS-OpenSSL_1_1_1-stable https://github.com/open-quantum-safe/openssl.git
[ ! -d "$BUILD_PATH/liboqs" ] && git clone --branch main https://github.com/open-quantum-safe/liboqs.git
popd

pushd $BUILD_PATH/liboqs
mkdir -p build
cd build
cmake -GNinja -DCMAKE_INSTALL_PREFIX=${BUILD_PATH}/openssl/oqs ..
ninja
ninja install
popd

pushd $BUILD_PATH/openssl
./Configure $PLATFORM_ARGS --prefix=$INSTALL_PATH
make -j
sudo make install
popd
