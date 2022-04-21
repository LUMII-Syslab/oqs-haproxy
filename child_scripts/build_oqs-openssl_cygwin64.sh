#!/bin/sh

# Building open-quantum-safe library (liboqs) and openssl linked with liboqs.

# Copyright (c) Institute of Mathematics and Computer Science, University of Latvia
# Licence: MIT
# Contributors:
#   Sergejs Kozlovics, 2022

export SCRIPT_PATH=`pwd`

# liboqs build type variant; maximum portability of image:
export LIBOQS_BUILD_DEFINES="-DOQS_DIST_BUILD=ON -DOPENSSL_CRYPTO_LIBRARY=crypto -DOPENSSL_ROOT_DIR=${SCRIPT_PATH}/openssl"

# installation path
export INSTALL_PATH=/oqs/openssl
# variant: /usr/local

if [ -f "$INSTALL_PATH/bin/openssl" ]; then
    echo oqs-openssl has already been installed; skipping the build process
    exit
fi

#git clone --branch OQS-OpenSSL_1_1_1-stable https://github.com/open-quantum-safe/openssl.git
#git clone --branch main https://github.com/open-quantum-safe/liboqs.git

cd $SCRIPT_PATH/liboqs
mkdir -p build
#cd build && if [[ -z "$MAKE_DEFINES" ]] ; then nproc=$(getconf _NPROCESSORS_ONLN) && MAKE_DEFINES="-j $nproc"; fi && cmake .. ${LIBOQS_BUILD_DEFINES} -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=${SCRIPT_PATH}/openssl/oqs && make $MAKE_DEFINES && make install
cd build && if [[ -z "$MAKE_DEFINES" ]] ; then nproc=$(getconf _NPROCESSORS_ONLN) && MAKE_DEFINES="-j $nproc"; fi && cmake .. ${LIBOQS_BUILD_DEFINES} -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=${SCRIPT_PATH}/openssl/oqs && make $MAKE_DEFINES && make install

cd $SCRIPT_PATH/openssl
LDFLAGS="-Wl,-rpath -Wl,$INSTALL_PATH/lib" ./Configure Cygwin-x86_64 -lm --prefix=$INSTALL_PATH && if [[ -z "$MAKE_DEFINES" ]] ; then nproc=$(getconf _NPROCESSORS_ONLN) && MAKE_DEFINES="-j $nproc"; fi && make $MAKE_DEFINES && make install
## ^^^was: make install_sw

cp $SCRIPT_PATH/liboqs/build/bin/cygoqs-0.dll $INSTALL_PATH/bin/
cp $SCRIPT_PATH/openssl/cygcrypto-1.1.dll $INSTALL_PATH/bin/
cp $SCRIPT_PATH/openssl/cygssl-1.1.dll $INSTALL_PATH/bin/
cp /cygdrive/c/cygwin64/bin/cygwin1.dll $INSTALL_PATH/bin/
cp /cygdrive/c/cygwin64/bin/cyggcc_s-seh-1.dll $INSTALL_PATH/bin/
