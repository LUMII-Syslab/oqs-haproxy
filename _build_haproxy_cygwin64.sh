#!/bin/sh

# The script for building HAProxy with open-quantum-safe algorithms.
# Arguments: build-path openssl-install-path haproxy-install-path
#            (open-quantum-safe openssl must be installed in openssl-install-path)

# Copyright (c) Institute of Mathematics and Computer Science, University of Latvia
# Licence: MIT
# Contributors:
#   Sergejs Kozlovics, 2022

export BUILD_PATH=$1
export OPENSSL_INSTALL_PATH=$2
export HAPROXY_INSTALL_PATH=$3

./_build_haproxy_common.sh $1 $2 $3
cp $BUILD_PATH/liboqs/build/bin/cygoqs-0.dll $INSTALL_PATH/sbin/
cp $BUILD_PATH/openssl/cygcrypto-1.1.dll $HAPROXY_INSTALL_PATH/sbin/
cp $BUILD_PATH/openssl/cygssl-1.1.dll $HAPROXY_INSTALL_PATH/sbin/
cp /cygdrive/c/cygwin64/bin/cygwin1.dll $HAPROXY_INSTALL_PATH/sbin/
cp /cygdrive/c/cygwin64/bin/cyggcc_s-seh-1.dll $INSTALL_PATH/sbin/
