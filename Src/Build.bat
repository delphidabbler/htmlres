@rem ---------------------------------------------------------------------------
@rem Script used to build the DelphiDabbler HTML Resource Compiler project.
@rem
@rem Copyright (C) Peter Johnson (www.delphidabbler.com), 2008
@rem
@rem v1.0 of 23 Aug 2008 - First version.
@rem
@rem Requires:
@rem   Borland Delphi7
@rem   Borland BRCC32 from Delphi 7 installation
@rem   DelphiDabbler Version Information Editor from www.delphidabbler.com
@rem   Inno Setup v5 with ISPP
@rem
@rem Also requires the following environment variables:
@rem   DELPHI7 to be set to the install directory of Delphi 7
@rem   DELPHIDABLIBD7 to be set to the install directory of the required
@rem     DelphiDabbler library units that have been compiled for Delphi 7.
@rem   INNOSETUP to be set to Inno Setup install directory
@rem
@rem Switches: exactly one of the following must be provided
@rem   all - build everything
@rem   res - build binary resource files only
@rem   pas - build Delphi Pascal project only
@rem   setup - build the installation program
@rem
@rem ---------------------------------------------------------------------------

@echo off

setlocal


rem ----------------------------------------------------------------------------
rem Sign on
rem ----------------------------------------------------------------------------

echo DelphiDabbler HTML Resource Compiler Build Script
echo -------------------------------------------------
title DelphiDabbler HTML Resource Compiler Build Script

goto Config


rem ----------------------------------------------------------------------------
rem Configure script per command line parameter
rem ----------------------------------------------------------------------------

:Config
echo Configuring script
rem reset all config variables

set BuildAll=
set BuildResources=
set BuildPascal=
set BuildSetup=

rem check switch

if "%~1" == "all" goto Config_BuildAll
if "%~1" == "res" goto Config_BuildResources
if "%~1" == "pas" goto Config_BuildPascal
if "%~1" == "setup" goto Config_BuildSetup
set ErrorMsg=Unknown switch "%~1"
if "%~1" == "" set ErrorMsg=No switch specified
goto Error

rem set config variables

:Config_BuildAll
set BuildResources=1
set BuildPascal=1
set BuildSetup=1
goto Config_OK

:Config_BuildResources
set BuildResources=1
goto Config_OK

:Config_BuildPascal
set BuildPascal=1
goto Config_OK

:Config_BuildSetup
set BuildSetup=1
goto Config_OK

rem script configured OK

:Config_OK
echo Done.
goto CheckEnvVars


rem ----------------------------------------------------------------------------
rem Check that required environment variables exist
rem ----------------------------------------------------------------------------

:CheckEnvVars

echo Checking predefined environment environment variables
if not defined DELPHI7 goto BadDELPHI7Env
if not defined DELPHIDABLIBD7 goto BadDELPHIDABLIBD7Env
if not defined INNOSETUP goto BadINNOSETUPEnv
echo Done.
echo.
goto SetEnvVars

rem we have at least one undefined env variable

:BadDELPHI7Env
set ErrorMsg=DELPHI7 Environment variable not defined
goto Error

:BadDELPHIDABLIBD7Env
set ErrorMsg=DELPHIDABLIBD7 Environment variable not defined
goto Error

:BadINNOSETUPEnv
set ErrorMsg=INNOSETUP Environment varibale not defined
goto Error


rem ----------------------------------------------------------------------------
rem Set up required environment variables
rem ----------------------------------------------------------------------------

:SetEnvVars
echo Setting Up Environment

rem directories

rem source directory
set SrcDir=.\
rem binary files directory
set BinDir=..\Bin\
rem executable files directory
set ExeDir=..\Exe\
rem install script source directory
set InstallSrcDir=%SrcDir%

rem executable programs

rem Delphi 7 - use full path since maybe multple installations
set DCC32Exe="%DELPHI7%\Bin\DCC32.exe"
rem Borland Resource Compiler - use full path since maybe multple installations
set BRCC32Exe="%DELPHI7%\Bin\BRCC32.exe"
rem Inno Setup command line compiler
set ISCCExe="%INNOSETUP%\ISCC.exe"
rem DelphiDabbler Version Information Editor - assumed to be on the path
set VIEdExe=VIEd.exe

echo Done.
echo.

rem ----------------------------------------------------------------------------
rem Start of build process
rem ----------------------------------------------------------------------------

:Build
echo BUILDING ...
echo.

goto Build_Resources


rem ----------------------------------------------------------------------------
rem Build resource files
rem ----------------------------------------------------------------------------

:Build_Resources
if not defined BuildResources goto Build_Pascal
echo Building Resources
echo.

rem set required env vars

rem Ver info resource
set VerInfoBase=VHTMLRes
set VerInfoSrc=%SrcDir%%VerInfoBase%.vi
set VerInfoTmp=%SrcDir%%VerInfoBase%.rc
set VerInfoRes=%BinDir%%VerInfoBase%.res
set ResourcesBase=HTMLRes
set ResourcesSrc=%SrcDir%%ResourcesBase%.rc
set ResourcesRes=%BinDir%%ResourcesBase%.res

rem Compile version information resource

echo Compiling %VerInfoSrc% to %VerInfoRes%
rem VIedExe creates temp resource .rc file from .vi file
set ErrorMsg=
%VIEdExe% -makerc %VerInfoSrc%
if errorlevel 1 set ErrorMsg=Failed to compile %VerInfoSrc%
if not "%ErrorMsg%"=="" goto VerInfoRes_End
rem BRCC32Exe compiles temp resource .rc file to required .res
%BRCC32Exe% %VerInfoTmp% -fo%VerInfoRes%
if errorlevel 1 set ErrorMsg=Failed to compile %VerInfoTmp%
if not "%ErrorMsg%"=="" goto VerInfoRes_End

:VerInfoRes_End
if exist %VerInfoTmp% del %VerInfoTmp%
if not "%ErrorMsg%"=="" goto Error

rem Compile general resource

echo Compiling %ResourcesSrc% to %ResourcesRes%
%BRCC32Exe% %ResourcesSrc% -fo%ResourcesRes%
if errorlevel 1 set ErrorMsg=Failed to compile %ResourcesSrc%
if not "%ErrorMsg%"=="" goto Error

echo Done
echo.

rem End of resource compilation

goto Build_Pascal


rem ----------------------------------------------------------------------------
rem Build Pascal project
rem ----------------------------------------------------------------------------

:Build_Pascal
if not defined BuildPascal goto Build_Setup

rem Set up required env vars
set PascalBase=HTMLRes
set PascalSrc=%SrcDir%%PascalBase%.dpr
set PascalExe=%ExeDir%%PascalBase%.exe
set DDabLib=%DELPHIDABLIBD7%

if not defined BuildPascal goto Build_Setup
echo Building Pascal Project
%DCC32Exe% -B %PascalSrc%  -U"%DDabLib%"
if errorlevel 1 goto Pascal_Error
goto Pascal_End

:Pascal_Error
set ErrorMsg=Failed to compile %PascalSrc%
if exist %PascalExe% del %PascalExe%
goto Error

:Pascal_End
echo Done.
echo.

rem End of Pascal compilation

goto Build_Setup


rem ----------------------------------------------------------------------------
rem Build setup program
rem ----------------------------------------------------------------------------

:Build_Setup
if not defined BuildSetup goto Build_End
echo Building Setup Program

rem Set required environment variables
set SetupSrc=%InstallSrcDir%Install.iss
set SetupExeWild=%ExeDir%HTMLRes-Setup-*

rem ISCC does not return error code if compile fails so find another way to
rem detect errors

del %SetupExeWild%
%ISCCExe% %SetupSrc%
if exist %SetupExeWild% goto Setup_End
set ErrorMsg=Failed to compile %SetupSrc%
goto Error

:Setup_End
echo Done.
echo.

goto Build_End


rem ----------------------------------------------------------------------------
rem Build completed
rem ----------------------------------------------------------------------------

:Build_End
echo BUILD COMPLETE
echo.

goto End


rem ----------------------------------------------------------------------------
rem Handle errors
rem ----------------------------------------------------------------------------

:Error
echo.
echo *** ERROR: %ErrorMsg%
echo.


rem ----------------------------------------------------------------------------
rem Finished
rem ----------------------------------------------------------------------------

:End
echo.
echo DONE.
endlocal
