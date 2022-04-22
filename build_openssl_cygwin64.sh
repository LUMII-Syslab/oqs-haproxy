#!/bin/sh

# The script for building open-quantum-safe library (liboqs) and openssl linked with liboqs.
# Arguments: build-path install-path-in-cygwin

# Copyright (c) Institute of Mathematics and Computer Science, University of Latvia
# Licence: MIT
# Contributors:
#   Sergejs Kozlovics, 2022

export BUILD_PATH=$1
export INSTALL_PATH=$2

if [ -z "$2" ]; then
    echo Usage: $0 build-path install-path-in-cygwin
    exit
fi
if [ -f "$INSTALL_PATH/bin/openssl" ]; then
    echo oqs-openssl has already been installed; skipping the build process
    exit
fi

# liboqs build type variant; maximum portability of image:
export LIBOQS_BUILD_DEFINES="-DOQS_DIST_BUILD=ON"
#### export LIBOQS_BUILD_DEFINES="-DOQS_DIST_BUILD=ON -DOPENSSL_INCLUDE_DIR=${BUILD_PATH}/openssl/include"
#### ^^^^   OPENSSL_INCLUDE_DIR

# cloning open-quantum-safe sources
pushd $BUILD_PATH
export BUILD_PATH=`pwd`
# ^^^ converting to full path; it will be passed to "cmake" below
[ ! -d "openssl" ] && git clone --branch OQS-OpenSSL_1_1_1-stable https://github.com/open-quantum-safe/openssl.git
[ ! -d "liboqs" ] && git clone --branch main https://github.com/open-quantum-safe/liboqs.git
popd

pushd $BUILD_PATH/liboqs
mkdir -p build
#cd build && if [[ -z "$MAKE_DEFINES" ]] ; then nproc=$(getconf _NPROCESSORS_ONLN) && MAKE_DEFINES="-j $nproc"; fi && cmake .. ${LIBOQS_BUILD_DEFINES} -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=${BUILD_PATH}/openssl/oqs && make $MAKE_DEFINES && make install
cd build && if [[ -z "$MAKE_DEFINES" ]] ; then nproc=$(getconf _NPROCESSORS_ONLN) && MAKE_DEFINES="-j $nproc"; fi && cmake .. ${LIBOQS_BUILD_DEFINES} -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=${BUILD_PATH}/openssl/oqs && make $MAKE_DEFINES && make install
popd

pushd $BUILD_PATH/openssl
LDFLAGS="-Wl,-rpath -Wl,$INSTALL_PATH/lib" ./Configure Cygwin-x86_64 -lm --prefix=$INSTALL_PATH && if [[ -z "$MAKE_DEFINES" ]] ; then nproc=$(getconf _NPROCESSORS_ONLN) && MAKE_DEFINES="-j $nproc"; fi && make $MAKE_DEFINES && make install
## ^^^was: make install_sw
popd

cp $BUILD_PATH/liboqs/build/bin/cygoqs-0.dll $INSTALL_PATH/bin/
cp $BUILD_PATH/openssl/cygcrypto-1.1.dll $INSTALL_PATH/bin/
cp $BUILD_PATH/openssl/cygssl-1.1.dll $INSTALL_PATH/bin/
cp /cygdrive/c/cygwin64/bin/cygwin1.dll $INSTALL_PATH/bin/
cp /cygdrive/c/cygwin64/bin/cyggcc_s-seh-1.dll $INSTALL_PATH/bin/
