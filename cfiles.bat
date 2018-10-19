@echo off
rem cfiles name version arch  build [tver msvc] -s src1 [src2 ...]
rem cfiles zlib 1.2.11  x86   mtd   [v141 1915] -s include lib\zlibstaticd.lib
rem cfiles %1   %2      %3    %4    %5
rem
rem name=project name, e.g. zlib
rem vesion=project version, e.g. 1.2.11
rem tver=platform tool version, v141=vs2017
rem msvc=msvc version, indicated by c++ macro, _MSC_VER
rem ipath=temp installed path, e.g. p:\prj\libs\zlib\1.2.11\tmp
rem
rem filename: zlib-1.2.11-v141-1915-x86-mdd.lib
rem filename: %name%-%version%-%tver%-%msvc%-%arch%-%build%.lib
rem
rem
rem cfiles zlib  1.2.11 x86 mdd -s include lib\zlibstaticd.lib
rem

rem default values
set tver=v141
set msvc=1915

if [%1] == [] goto error1
if [%1] == [-s] goto error1
set name=%1
shift

if [%1] == [] goto error2
if [%1] == [-s] goto error2
set version=%1
shift

if [%1] == [] goto error3
if [%1] == [-s] goto error3
set arch=%1
shift

if [%1] == [] goto error4
if [%1] == [-s] goto error4
set build=%1
shift

if [%1] == [] goto argend1
if [%1] == [-s] goto src
set tver=%1
shift

if [%1] == [] goto argend1
if [%1] == [-s] goto src
set msvc=%1
shift

:src
if not [%1] == [-s] goto end
shift
set base=p:\prj\libs\%name%\%version%\tmp\
set dest=p:\prj\libs\%name%\%version%\

:srcloop

if [%1] == [] goto end
if not exist %base%%1\nul goto src1

rem folder
echo xcopy/e/y/i %base%%1 %dest%%1
xcopy/e/y/i %base%%1 %dest%%1
goto srcx

:src1
if not exist %base%%1 goto srcx

rem file
set fname=%base%%1
set dname=%dest%%1
for /f %%i in ( "%dname%" ) do set dfolder=%%~di%%~pi&set dext=%%~xi
rem echo dname=%dname%
rem echo dfolder=%dfolder%
rem echo dext=%dext%
set dfname=%name%-%version%-%tver%-%msvc%-%arch%-%build%%dext%
rem echo dfname=%dfname%

rem echo xcopy /i/e/y %base%%1 %dfolder%%dfname%
echo copy /b/y %base%%1 %dfolder%%dfname%
mkdir %dfolder% > nul 2>&1
copy /b/y %base%%1 %dfolder%%dfname%

:srcx
shift
goto srcloop

:argend1
rem echo xcopy/e/y p:\prj\libs\%name%\%version%\tmp\include p:\prj\libs\%name%\%version%
rem echo copy/b/y p:\prj\libs\%name%\%version%\tmp\lib\a p:\prj\libs\%name%\%version%


goto end

:error1
echo ERROR: Missing project name
exit /b 1
goto end

:error2
echo ERROR: Missing project version
exit /b 2
goto end

:error3
echo ERROR: Missing arch (x86/x64)
exit /b 3
goto end

:error4
echo ERROR: Missing build type (md/mdd/mt/mtd)
exit /b 4
goto end

:end
