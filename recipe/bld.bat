mkdir build
cd build

:: build stumbles over this somehow
del /s /q %LIBRARY_LIB%\cmake\llvm\Findzstd.cmake

cmake -G "Ninja" ^
      -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DLIBCLING_BUILD_STATIC=ON ^
      %SRC_DIR%

if errorlevel 1 exit 1

ninja -j%CPU_COUNT%
if errorlevel 1 exit 1

ninja install
if errorlevel 1 exit 1
