@echo off
setlocal
rem
rem msc_ver.bat: A tool to display and set _MSC_VER
rem
rem returns:
rem   0 = successful
rem   1 = vswhere.exe not found
rem   2 = vsdevcmd.bat not found
rem   3 = cl.exe not found
rem
rem
rem
rem License: MIT
rem
rem Copyright (c) 2018 by Lita Li
rem
rem Permission is hereby granted, free of charge, to any person obtaining a copy
rem of this software and associated documentation files (the "Software"), to deal
rem in the Software without restriction, including without limitation the rights
rem to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
rem copies of the Software, and to permit persons to whom the Software is
rem furnished to do so, subject to the following conditions:
rem 
rem The above copyright notice and this permission notice shall be included in all
rem copies or substantial portions of the Software.
rem 
rem THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
rem IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
rem FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
rem AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
rem LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
rem OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
rem SOFTWARE.
rem
rem 

cl > nul 2>&1
if not errorlevel 1 goto havecl

if not ["%ProgramFiles(x86)%"] == [""] (
  set cmdstr="%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
) else set cmdstr="%ProgramFiles%\Microsoft Visual Studio\Installer\vswhere.exe"

if not exist %cmdstr% echo ERROR: [%cmdstr%] not found&exit/b 1

for /f "tokens=1,2 delims=:" %%a in ('%cmdstr% -property installationPath') do set ipath=%%a:%%b

rem echo ipath=%ipath%
set cmdstr="%ipath%\common7\tools\vsdevcmd.bat"
if not exist %cmdstr% echo ERROR: [%cmdstr%] not found&exit/b 2

call %cmdstr% > nul 2>&1

:havecl
for /f "delims=" %%a in ('cl /? 2^>^&1 ^| findstr "Version"' ) do set str=%%a
if ["%str%"] == [""]  echo ERROR: [cl.exe] not found or have error&exit/b 3
set str=%str:Version =$%
for /f "tokens=2 delims=$" %%a in ("%str%" ) do set str=%%a
for /f "tokens=1,2 delims=." %%a in ("%str%" ) do set major=%%a&set minor=%%b
if %minor% LSS 10 set minor=0%minor%
endlocal &set _MSC_VER=%major%%minor%&echo %major%%minor%&exit/b 0
