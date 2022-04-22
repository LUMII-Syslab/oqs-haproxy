#!/bin/sh

# The script for building open-quantum-safe library (liboqs) and openssl linked with liboqs on Ubuntu.

# Copyright (c) Institute of Mathematics and Computer Science, University of Latvia
# Licence: MIT
# Contributors:
#   Sergejs Kozlovics, 2022

export BUILD_PATH=build
export INSTALL_PATH=$1

if [ -z "$1" ]; then
    export INSTALL_PATH=/opt/oqs
    # ^^^ the install prefix; variant: /usr/local
fi

#sudo apt install -y cmake gcc libtool libssl-dev make ninja-build git libsystemd-dev

./_build_openssl_unix.sh $BUILD_PATH $INSTALL_PATH linux-x86_64 -lm
# originally, "no-shared" was also specified; we removed it in order to compile haproxy
#sudo ldconfig
./_build_haproxy_common.sh $BUILD_PATH $INSTALL_PATH $INSTALL_PATH \
                TARGET=linux-glibc USE_OPENSSL=1 USE_SYSTEMD=1
