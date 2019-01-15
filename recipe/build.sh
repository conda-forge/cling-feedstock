#!/bin/bash

mkdir build
cd build

EXTRA_CMAKE_ARGS=""
if [[ `uname` == "Linux" ]]; then
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

ACTIVATE_DIR=$PREFIX/etc/conda/activate.d
mkdir -p $ACTIVATE_DIR

cp $RECIPE_DIR/scripts/activate.sh $ACTIVATE_DIR/activate-cling.sh
