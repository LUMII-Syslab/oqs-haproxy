:: Downloads and installs cygwin64 for windows and
:: invokes child scripts to build haproxy with open-quantum-safe support.
::
:: Copyright (c) Institute of Mathematics and Computer Science, University of Latvia
:: Licence: MIT
:: Contributors:
::   Sergejs Kozlovics, 2022

set CYGWIN_INSTALLER_PATH=cygwin_installer
set CYGWIN_SITE=https://ftp.fsn.hu/pub/cygwin/

mkdir %CYGWIN_INSTALLER_PATH%
pushd %CYGWIN_INSTALLER_PATH%

:: download cygwin installer
if not exist setup-x86_64.exe curl.exe -o setup-x86_64.exe https://www.cygwin.com/setup-x86_64.exe

:: install default cygwin packages
if not exist C:\cygwin64\bin setup-x86_64.exe -q --wait --site %CYGWIN_SITE%

:: install additional cygwin packages
setup-x86_64.exe -q --wait -P git,perl,cmake,make,gcc-core,ninja,libtool,openssl

popd

:: === cygwin64 and packages installed ====

:: invoking child scripts (cygwin understands cd in the Windows path syntax; cd is required)
C:\cygwin64\bin\bash --login -c "cd '%~dp0/child_scripts' && ./build_oqs-openssl_cygwin64.sh"
