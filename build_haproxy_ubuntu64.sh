#!/bin/sh

# The script for building open-quantum-safe library (liboqs) and openssl linked with liboqs on Ubuntu.

# Copyright (c) Institute of Mathematics and Computer Science, University of Latvia
# Licence: MIT
# Contributors:
#   Sergejs Kozlovics, 2022

export BUILD_PATH=build
export INSTALL_PATH=/opt/oqs
# ^^^ the install prefix; variant: /usr/local

sudo apt install -y cmake gcc libtool libssl-dev make ninja-build git

./_build_openssl_unix.sh $BUILD_PATH $INSTALL_PATH no-shared linux-x86_64 -lm
