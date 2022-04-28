#!/bin/bash

# The script for building HAProxy with open-quantum-safe algorithms.
# Arguments: build-path openssl-install-path haproxy-install-path make-args
#            (open-quantum-safe openssl must be installed in openssl-install-path)

# Copyright (c) Institute of Mathematics and Computer Science, University of Latvia
# Licence: MIT
# Contributors:
#   Sergejs Kozlovics, 2022

export BUILD_PATH=$1
export OPENSSL_INSTALL_PATH=$2
export HAPROXY_INSTALL_PATH=$3
export MAKE_ARGS="${@:4}"

# define the haproxy version to download and build
export HAPROXY_MAJOR_VERSION=2.5
export HAPROXY_VERSION=2.5.5

if [ -z "$4" ]; then
    echo Usage: $0 build-path openssl-install-path haproxy-install-path make-args
    echo "       (open-quantum-safe openssl must be installed in openssl-install-path)"
    exit
fi

mkdir -p $HAPROXY_INSTALL_PATH
if [ -f "$HAPROXY_INSTALL_PATH/sbin/haproxy" ]; then
    echo oqs-haproxy has already been installed, skipping the build process
    exit
fi

mkdir -p $BUILD_PATH
if [ ! -d "${BUILD_PATH}/haproxy" ]; then
  curl -o haproxy-${HAPROXY_VERSION}.tar.gz http://www.haproxy.org/download/${HAPROXY_MAJOR_VERSION}/src/haproxy-${HAPROXY_VERSION}.tar.gz && tar xzvf haproxy-${HAPROXY_VERSION}.tar.gz && mv haproxy-${HAPROXY_VERSION} ${BUILD_PATH}/haproxy
  rm haproxy-${HAPROXY_VERSION}.tar.gz
  #variant (if git and some other libs already installed):
  #git clone http://git.haproxy.org/git/haproxy-${HAPROXY_MAJOR_VERSION}.git ${BUILD_PATH}/haproxy
fi

cd ${BUILD_PATH}/haproxy

if [[ -z "$MAKE_DEFINES" ]] ; then nproc=$(getconf _NPROCESSORS_ONLN) && MAKE_DEFINES="-j $nproc"; fi \
  && make $MAKE_DEFINES \
    USE_OPENSSL=1 \
    LDFLAGS="-Wl,-L$OPENSSL_INSTALL_PATH/lib,-L$HAPROXY_INSTALL_PATH/lib,-rpath,$OPENSSL_INSTALL_PATH/lib,-rpath,$HAPROXY_INSTALL_PATH/lib" \
    SSL_INC=$OPENSSL_INSTALL_PATH/include SSL_LIB=$OPENSSL_INSTALL_PATH/lib ${MAKE_ARGS} \
  && make PREFIX=$HAPROXY_INSTALL_PATH install
exit
mkdir -p $HAPROXY_INSTALL_PATH
sudo make PREFIX=$HAPROXY_INSTALL_PATH install

