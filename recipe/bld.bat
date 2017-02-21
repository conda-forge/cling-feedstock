mkdir build
cd build
cmake -G "NMake Makefiles" ^
      -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
      -D CMAKE_BUILD_TYPE=Release ^
      %SRC_DIR%
if errorlevel 1 exit 1

nmake
if errorlevel 1 exit 1

nmake install
if errorlevel 1 exit 1

REM Install kernelspec
cd %SRC_DIR%\tools\Jupyter\kernel\
python %SRC_DIR%\tools\Jupyter\kernel\setup.py install

xcopy /S /I %LIBRARY_PREFIX%\share\cling\Jupyter\kernel\cling-c++11 %LIBRARY_PREFIX%\share\cling\Jupyter\kernel\cling-cpp11 
xcopy /S /I %LIBRARY_PREFIX%\share\cling\Jupyter\kernel\cling-c++14 %LIBRARY_PREFIX%\share\cling\Jupyter\kernel\cling-cpp14 
xcopy /S /I %LIBRARY_PREFIX%\share\cling\Jupyter\kernel\cling-c++17 %LIBRARY_PREFIX%\share\cling\Jupyter\kernel\cling-cpp17 
jupyter kernelspec install %LIBRARY_PREFIX%\share\cling\Jupyter\kernel\cling-cpp11 --sys-prefix
jupyter kernelspec install %LIBRARY_PREFIX%\share\cling\Jupyter\kernel\cling-cpp14 --sys-prefix
jupyter kernelspec install %LIBRARY_PREFIX%\share\cling\Jupyter\kernel\cling-cpp17 --sys-prefix
