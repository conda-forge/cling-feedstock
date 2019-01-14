#!/bin/bash

mkdir build
cd build

cmake \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_RPATH=${PREFIX}/lib \
  -DINSTALL_RPATH_USE_LINK_PATH=ON \
  -DCMAKE_EXE_LINKER_FLAGS="-Wl,-rpath,${PREFIX}/lib -L${PREFIX}/lib" \
  -DCMAKE_SHARED_LINKER_FLAGS="-Wl,-rpath,${PREFIX}/lib -L${PREFIX}/lib" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCLING_INCLUDE_PATHS=${PREFIX}/${HOST}/include/c++/$(${CXX} -dumpversion):${PREFIX}/${HOST}/sysroot/usr/include \
  $SRC_DIR

make -j${CPU_COUNT}
make install
