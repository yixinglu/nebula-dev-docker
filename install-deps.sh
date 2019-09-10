#!/bin/sh

set -ex

INSTALL_PATH=/opt/rh/devtoolset-8/root/usr
NEBULA_HOME=/home/nebula
EXTRA_CXXFLAGS="-O2 -m64 -march=x86-64"
EXTRA_PIC_CXXFLAGS="${EXTRA_CXXFLAGS} -fPIC -DPIC"
EXTRA_LDFLAGS="-static-libgcc -static-libstdc++"

. /etc/profile.d/devtoolset-8.sh

# Install openssl-1.1.0h
cd ${NEBULA_HOME}
wget -qO - https://www.openssl.org/source/old/1.1.0/openssl-1.1.0h.tar.gz | tar zxf -
cd openssl-1.1.0h
./config --prefix=${INSTALL_PATH} --openssldir=${INSTALL_PATH}/ssl no-shared threads ${EXTRA_CXXFLAGS} ${EXTRA_LDFLAGS}
make && make install

# Install cmake-3.11.4
cd ${NEBULA_HOME}
wget -qO - https://github.com/Kitware/CMake/releases/download/v3.11.4/cmake-3.11.4.tar.gz | tar zxf -
cd cmake-3.11.4
CXXFLAGS=${EXTRA_PIC_CXXFLAGS} CFLAGS=$CXXFLAGS CPPFLAGS=$CXXFLAGS LDFLAGS="${EXTRA_LDFLAGS} -pthread" ./configure --prefix=${INSTALL_PATH}
make && make install

# Install bison-3.0.5
cd ${NEBULA_HOME}
wget -qO - http://ftp.gnu.org/gnu/bison/bison-3.0.5.tar.gz | tar zxf -
cd bison-3.0.5
CXXFLAGS=${EXTRA_PIC_CXXFLAGS} CFLAGS=$CXXFLAGS CPPFLAGS=$CXXFLAGS LDFLAGS=${EXTRA_LDFLAGS} ./configure --prefix=${INSTALL_PATH} --enable-shared=no --enable-static
make && make install

# Install flex-2.6.4
cd ${NEBULA_HOME}
wget -qO - https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz | tar zxf -
cd flex-2.6.4
CXXFLAGS=${EXTRA_PIC_CXXFLAGS} CFLAGS=$CXXFLAGS CPPFLAGS=$CXXFLAGS LDFLAGS=${EXTRA_LDFLAGS} ./configure --prefix=${INSTALL_PATH} --enable-shared=no
make && make install

# Install boost-1.66
cd ${NEBULA_HOME}
wget -qO - https://dl.bintray.com/boostorg/release/1.66.0/source/boost_1_66_0.tar.gz | tar zxf -
cd boost_1_66_0
./bootstrap.sh --prefix=${INSTALL_PATH} --without-icu --without-libraries=python
./b2 cxxflags=${EXTRA_CXXFLAGS} link=static runtime-link=static install
./b2 --clean-all

# Install gperf-3.1
cd ${NEBULA_HOME}
wget -qO - http://ftp.gnu.org/pub/gnu/gperf/gperf-3.1.tar.gz | tar zxf -
cd gperf-3.1
CXXFLAGS=${EXTRA_PIC_CXXFLAGS} CFLAGS=$CXXFLAGS CPPFLAGS=$CXXFLAGS LDFLAGS=${EXTRA_LDFLAGS} ./configure --prefix=${INSTALL_PATH} --enable-shared=no
make && make install

# Install krb5-1.16.3
cd ${NEBULA_HOME}
wget -qO - https://github.com/krb5/krb5/archive/krb5-1.16.3-final.tar.gz | tar zxf -
cd krb5-krb5-1.16.3-final/src
autoreconf
CXXFLAGS=$EXTRA_PIC_CXXFLAGS CFLAGS=$CXXFLAGS CPPFLAGS=$CXXFLAGS LDFLAGS=${EXTRA_LDFLAGS} ./configure --prefix=${INSTALL_PATH} --enable-static --disable-shared --disable-rpath --disable-aesni --disable-thread-support
make all && make install

# Install libunwind-1.2.1
cd ${NEBULA_HOME}
wget -qO - https://github.com/libunwind/libunwind/releases/download/v1.2.1/libunwind-1.2.1.tar.gz | tar zxf -
cd libunwind-1.2.1
CXXFLAGS=${EXTRA_PIC_CXXFLAGS} CFLAGS=$CXXFLAGS CPPFLAGS=$CXXFLAGS LDFLAGS=${EXTRA_LDFLAGS} ./configure --prefix=${INSTALL_PATH} --enable-shared=no
make && make install

# Cleanup
cd ${NEBULA_HOME}
rm -rf *
