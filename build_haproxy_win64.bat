:: Downloads and installs cygwin64 for windows and
:: invokes child scripts to build haproxy with open-quantum-safe support.
::
:: Copyright (c) Institute of Mathematics and Computer Science, University of Latvia
:: Licence: MIT
:: Contributors:
::   Sergejs Kozlovics, 2022

set CYGWIN_INSTALLER_PATH=cygwin_installer
set CYGWIN_SITE=https://ftp.fsn.hu/pub/cygwin/
set BUILD_PATH=build
set INSTALL_PATH=/opt/oqs
:: ^^^ the install path inside Cygwin; variant: /usr/local

mkdir %CYGWIN_INSTALLER_PATH%
pushd %CYGWIN_INSTALLER_PATH%

:: download cygwin installer
if not exist setup-x86_64.exe curl.exe -o setup-x86_64.exe https://www.cygwin.com/setup-x86_64.exe

:: install default cygwin packages
if not exist C:\cygwin64\bin setup-x86_64.exe -q --wait --site %CYGWIN_SITE%

:: install additional cygwin packages
setup-x86_64.exe -q --wait -P git,perl,cmake,make,gcc-core,ninja,libtool,openssl,libssl-devel

popd

:: === cygwin64 and packages installed ====

:: invoking child scripts (cygwin understands cd in the Windows path syntax; cd is required)
mkdir %BUILD_PATH%
echo C:\cygwin64\bin\bash --login -c "cd '%~dp0' && ./build_openssl_cygwin64.sh %BUILD_PATH% %INSTALL_PATH%"
