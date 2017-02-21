#!/bin/bash

EXTRA_CMAKE_ARGS=""
if [[ `uname` == 'Darwin' ]];
then
    EXTRA_CMAKE_ARGS="-DLLVM_ENABLE_LIBCXX=ON"
else
    EXTRA_CMAKE_ARGS="-DLLVM_ENABLE_LIBCXX=OFF"
fi
export EXTRA_CMAKE_ARGS

mkdir build
cd build

cmake \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DCMAKE_PREFIX_PATH=$PREFIX \
  -DCMAKE_INSTALL_RPATH=${PREFIX}/lib \
  -DINSTALL_RPATH_USE_LINK_PATH=ON \
  -DCMAKE_EXE_LINKER_FLAGS="-Wl,-rpath,${PREFIX}/lib -L${PREFIX}/lib" \
  -DCMAKE_SHARED_LINKER_FLAGS="-Wl,-rpath,${PREFIX}/lib -L${PREFIX}/lib" \
  -DCMAKE_BUILD_TYPE=Release \
  ${EXTRA_CMAKE_ARGS} \
  $SRC_DIR

make
make install

# Install kernelspec
cd $SRC_DIR/tools/Jupyter/kernel/
python $SRC_DIR/tools/Jupyter/kernel/setup.py install
cp -r $PREFIX\share\cling\Jupyter\kernel\cling-c++11 $PREFIX\share\cling\Jupyter\kernel\cling-cpp11 
cp -r $PREFIX\share\cling\Jupyter\kernel\cling-c++14 $PREFIX\share\cling\Jupyter\kernel\cling-cpp14 
cp -r $PREFIX\share\cling\Jupyter\kernel\cling-c++17 $PREFIX\share\cling\Jupyter\kernel\cling-cpp17 
jupyter kernelspec install $PREFIX/share/cling/Jupyter/kernel/cling-cpp11 --sys-prefix
jupyter kernelspec install $PREFIX/share/cling/Jupyter/kernel/cling-cpp14 --sys-prefix
jupyter kernelspec install $PREFIX/share/cling/Jupyter/kernel/cling-cpp17 --sys-prefix
