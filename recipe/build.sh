#!/bin/bash
set -ex

mkdir build
cd build

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
  CMAKE_ARGS="${CMAKE_ARGS} -DLLVM_TOOLS_BINARY_DIR=$BUILD_PREFIX/bin -DLLVM_TABLEGEN_EXE=$BUILD_PREFIX/bin/llvm-tblgen"
  CMAKE_ARGS="${CMAKE_ARGS} -DLLVM_CONFIG=$BUILD_PREFIX/bin/llvm-config"
  # cling detects the build compiler/c++ headers and remembers it; this is incorrect for cross-compilation
  CMAKE_ARGS="${CMAKE_ARGS} -DCLING_CXX_PATH=$PREFIX/bin/clang"
  if [[ "$target_platform" == osx* ]]; then
    # our C++ headers are in $PREFIX/include, rather than $PREFIX/lib/clang/<version>/include
    CLING_CXX_HEADERS=$PREFIX
  else
    CLING_CXX_HEADERS=$($CXX -E -v /dev/null 2>&1 | sed -n 's/^.*--with-gxx-include-dir=\([^ ]*\).*$/\1/p')
  fi
  CMAKE_ARGS="${CMAKE_ARGS} -DCLING_CXX_HEADERS=$CLING_CXX_HEADERS"
else
  rm -rf $BUILD_PREFIX/bin/llvm-tblgen
fi

cmake -G Ninja \
  $CMAKE_ARGS \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_RPATH=${PREFIX}/lib \
  -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON \
  -DCMAKE_EXE_LINKER_FLAGS="-Wl,-rpath,${PREFIX}/lib -L${PREFIX}/lib" \
  -DCMAKE_SHARED_LINKER_FLAGS="-Wl,-rpath,${PREFIX}/lib -L${PREFIX}/lib" \
  -DCMAKE_BUILD_TYPE=Release \
  $SRC_DIR

cmake --build . -j${CPU_COUNT}
cmake --install .
