Scripts for building and installing OpenSSL and HAProxy, both with open-quantum-safe algorithms (HAProxy depends on OpenSSL).

## Ubuntu Linux

Invoke:

```bash
./build_haproxy_ubuntu.sh
```

## *NIX

Install these packages as prerequisites: `git,perl,cmake,make,gcc-core,ninja,libtool,openssl,libssl-devel`. 

Then invoke:

```bash
child_scripts/build_oqs-openssl_unix.sh
```

## Windows

On Windows, the build process relies on Cygwin64. The `build_haproxy_win64.bat` script does all the job. In particular, the script downloads and installs Cygwin64 with the required build tools.

If you wish to manually install additional Cygwin64 programs (such as  `mc` and `dos2unix`), use the following command:

```bash
cygwin_installer\setup-x86_64.exe -q --wait -P mc,dos2unix
```

