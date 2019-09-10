#!/bin/sh

set -ex

INSTALL_PATH=/opt/rh/devtoolset-8/root/usr
NEBULA_HOME=/home/nebula
EXTRA_CXXFLAGS="-O2 -m64 -march=x86-64"
EXTRA_PIC_CXXFLAGS="${EXTRA_CXXFLAGS} -fPIC -DPIC"
EXTRA_LDFLAGS="-static-libgcc -static-libstdc++"

. /etc/profile.d/devtoolset-8.sh

cd ${NEBULA_HOME}

# Install openssl-1.1.0h
wget -qO - https://www.openssl.org/source/old/1.1.0/openssl-1.1.0h.tar.gz | tar zxf -
pushd
cd openssl-1.1.0h
./config --prefix=${INSTALL_PATH} --openssldir=${INSTALL_PATH}/ssl no-shared threads ${EXTRA_CXXFLAGS} ${EXTRA_LDFLAGS}
make && make install
popd

# Install cmake-3.11.4
wget -qO - https://github.com/Kitware/CMake/releases/download/v3.11.4/cmake-3.11.4.tar.gz | tar zxf -
pushd
cd cmake-3.11.4
CXXFLAGS=${EXTRA_PIC_CXXFLAGS} CFLAGS=$CXXFLAGS CPPFLAGS=$CXXFLAGS LDFLAGS="${EXTRA_LDFLAGS} -pthread" ./configure --prefix=${INSTALL_PATH}
make && make install
popd

# Install bison-3.0.5
wget -qO - http://ftp.gnu.org/gnu/bison/bison-3.0.5.tar.gz | tar zxf -
pushd
cd bison-3.0.5
CXXFLAGS=${EXTRA_PIC_CXXFLAGS} CFLAGS=$CXXFLAGS CPPFLAGS=$CXXFLAGS LDFLAGS=${EXTRA_LDFLAGS} ./configure --prefix=${INSTALL_PATH} --enable-shared=no --enable-static
make && make install
popd

# Install flex-2.6.4
wget -qO - https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz | tar zxf -
pushd
cd flex-2.6.4
CXXFLAGS=${EXTRA_PIC_CXXFLAGS} CFLAGS=$CXXFLAGS CPPFLAGS=$CXXFLAGS LDFLAGS=${EXTRA_LDFLAGS} ./configure --prefix=${INSTALL_PATH} --enable-shared=no
make && make install
popd

# Install boost-1.66
wget -qO - https://dl.bintray.com/boostorg/release/1.66.0/source/boost_1_66_0.tar.gz | tar zxf -
pushd
cd boost_1_66_0
./bootstrap.sh --prefix=${INSTALL_PATH} --without-icu --without-libraries=python
./b2 cxxflags=${EXTRA_CXXFLAGS} link=static runtime-link=static install
./b2 --clean-all
popd

# Install gperf-3.1
wget -qO - http://ftp.gnu.org/pub/gnu/gperf/gperf-3.1.tar.gz | tar zxf -
pushd
cd gperf-3.1
CXXFLAGS=${EXTRA_PIC_CXXFLAGS} CFLAGS=$CXXFLAGS CPPFLAGS=$CXXFLAGS LDFLAGS=${EXTRA_LDFLAGS} ./configure --prefix=${INSTALL_PATH} --enable-shared=no
make && make install
popd

# Install krb5-1.16.3
wget -qO - https://github.com/krb5/krb5/archive/krb5-1.16.3-final.tar.gz | tar zxf -
pushd
cd krb5-krb5-1.16.3-final/src
autoreconf
CXXFLAGS=$EXTRA_PIC_CXXFLAGS CFLAGS=$CXXFLAGS CPPFLAGS=$CXXFLAGS LDFLAGS=${EXTRA_LDFLAGS} ./configure --prefix=${INSTALL_PATH} --enable-static --disable-shared --disable-rpath --disable-aesni --disable-thread-support
make all && make install
popd

# Install libunwind-1.2.1
wget -qO - https://github.com/libunwind/libunwind/releases/download/v1.2.1/libunwind-1.2.1.tar.gz | tar zxf -
pushd
cd libunwind-1.2.1
CXXFLAGS=${EXTRA_PIC_CXXFLAGS} CFLAGS=$CXXFLAGS CPPFLAGS=$CXXFLAGS LDFLAGS=${EXTRA_LDFLAGS} ./configure --prefix=${INSTALL_PATH} --enable-shared=no
make && make install
popd

# Cleanup
cd ${NEBULA_HOME}
rm -rf *
