#!/bin/bash
set -ex

mkdir build
cd build

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
  CMAKE_ARGS="${CMAKE_ARGS} -DLLVM_TOOLS_BINARY_DIR=$BUILD_PREFIX/bin -DLLVM_TABLEGEN_EXE=$BUILD_PREFIX/bin/llvm-tblgen"
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
