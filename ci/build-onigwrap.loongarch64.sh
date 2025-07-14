#!/bin/bash

set -e

export PATH=$(realpath loongson-gnu-toolchain-8.3-x86_64-loongarch64-linux-gnu-rc1.6/bin):$PATH
export CC=$_HOST-gcc
export CFLAGS="-O2 -s"

mkdir -p buildprefix

pushd oniguruma

autoreconf -i
./configure --enable-shared=no --with-pic=yes --host="$_HOST" --prefix="$(realpath ../buildprefix)" || (cat config.log; exit 1)
make
make install

popd

$CC -shared -fPIC onigwrap/onigwrap.c $CFLAGS -I./buildprefix/include -L./buildprefix/lib -lonig -o "$_LIBNAME"
