#!/bin/bash

mkdir build
cd build

# OS X
# ----
#
# On MacOSX, the SDK is not distributed by conda
#
# Until version 10.13 (included), the OSX SDK headers were in
# /usr/include/ and /usr/include/CXX_VERSION for the standard
# library headers.
#
# From version 10.14, the OSX SDK is installed in
# /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.14.sdk/
#
# Linux
# -----
#
# The host compiler is distributed as a conda package.
#

EXTRA_CMAKE_ARGS=""
if [[ `uname` == "Darwin" ]]; then
  EXTRA_CMAKE_ARGS="${EXTRA_CMAKE_ARGS} -DCLING_INCLUDE_PATHS=/usr/include:/usr/include/c++/$(${CXX} -dumpversion):/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.14.sdk/usr/include:/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1"
else
  EXTRA_CMAKE_ARGS="${EXTRA_CMAKE_ARGS} -DCLING_INCLUDE_PATHS=${PREFIX}/${HOST}/include/c++/$(${CXX} -dumpversion):${PREFIX}/${HOST}/sysroot/usr/include"
fi

echo "Extra Cmake Args:"
echo ${EXTRA_CMAKE_ARGS}

cmake \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_RPATH=${PREFIX}/lib \
  -DINSTALL_RPATH_USE_LINK_PATH=ON \
  -DCMAKE_EXE_LINKER_FLAGS="-Wl,-rpath,${PREFIX}/lib -L${PREFIX}/lib" \
  -DCMAKE_SHARED_LINKER_FLAGS="-Wl,-rpath,${PREFIX}/lib -L${PREFIX}/lib" \
  -DCMAKE_BUILD_TYPE=Release \
  ${EXTRA_CMAKE_ARGS} ${SRC_DIR}

make -j${CPU_COUNT}
make install
