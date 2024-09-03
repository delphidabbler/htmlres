:: Deploy script for HTMLRes.
::
:: This script compiles creates a setup file containing HTMLRes and places it
:: in a zip file. Both the setup file and zip file are labelled with the release
:: version number.
::
:: This script has the following dependencies:
::
::   1) MSBuild & Delphi.
::   2) InfoZip's zip.exe. See https://delphidabbler.com/extras/info-zip
::   3) Inno Setup v5.6.1 or later Unicode version (not v6). See
::      https://www.innosetup.com/
::   4) DelphiDabbler Version Information Editor v2.15.1 or later. See
::      https://delphidabbler.com/software/vied
::   5) PowerShell.
::
:: To use the script:

::   1) Start the Embarcadero RAD Studio Command Prompt to set the required
::      environment variables for MSBuild.
::   2) Set the ZipRoot environment variable to the directory where zip.exe is
::      installed.
::   3) Set the VIEdRoot environment variable to the directory where VIEd.exe is
::      installed.
::   4) Set the InnoSetup environment variable to the directoty where Inno Setup
::      is installed.
::   5) Change directory to that where this script is located.
::   6) Run the script by entering Deploy with no parameters
::
:: The script does the following:
::
::   1) Builds the HTMLRes executable using MSBuild, Delphi and Version
::      Information Editor
::   2) Uses PowerShell to extract the release version from version information
::      embedded in the HTMLRes executable. This is used to set the version of
::      the setup program and to name the setup program and zip file.
::   3) Builds the setup file using Inno Setup.
::   4) Creates the release zip file using Zip.exe.


@echo off

echo -------------------------
echo Deploying HTMLRes Release
echo -------------------------

:: Check for required environment variables

if "%ZipRoot%"=="" goto envvarerror
if "%VIEdRoot%"=="" goto envvarerror
if "%InnoSetup%"=="" goto envvarerror

:: Set other variables that don't depend on version

set ProjectName=HTMLRes
set BuildRoot=.\_build
set Win32ExeDir=%BuildRoot%\exe
set Win32Exe=%ProjectName%
set ReleaseDir=%BuildRoot%\release
set TempDir=%ReleaseDir%\~temp
set SrcDir=Src  
set DocsDir=Docs
set DemoDir=Demo
set ReadMeFile=%DocsDir%\README.txt
set ISCC="%InnoSetup%\ISCC.exe"

:: Make a clean directory structure

if exist %BuildRoot% rmdir /S /Q %BuildRoot%
mkdir %ReleaseDir%
mkdir %TempDir%

:: Build Pascal

setlocal

cd %SrcDir%

echo.
echo Building HTMLRes
echo.

msbuild %ProjectName%.dproj /p:config=Release /p:platform=Win32

endlocal

:: Get version and set variables that depend on version

PowerShell(Get-Command %Win32ExeDir%\%Win32Exe%.exe).FileVersionInfo.ProductVersion > "%TempDir%\~version"
set /p Version= < "%TempDir%\~version"

set SetupFileName=HTMLRes-Setup-%Version%
set ZipFile=%ReleaseDir%\htmlres-exe-%Version%.zip

:: Split Version into prefix and suffix with "-" delimiter: suffix may be empty

for /f "tokens=1,2 delims=-" %%a in ("%Version%") do (
  :: prefix and suffix required for Inno Setup
  set VersionPrefix=%%a
  set VersionSuffix=%%b
)
if not [%VersionSuffix%] == [] (
  :: add back "-" when suffix not empty
  set VersionSuffix=-%VersionSuffix%
)

:: Build Setup

setlocal

cd %SrcDir%

echo.
echo Building setup program for release v%Version%
echo.

%ISCC% /DAppShortName=%ProjectName% /DAppVersion=%VersionPrefix% /DAppVersionSuffix=%VersionSuffix% /DSetupOutDir=%TempDir% /DSetupFileName=%SetupFileName% /DExeInDir=%Win32ExeDir% /DDocsInDir=%DocsDir% /DDemoInDir=%DemoDir% Install.iss

endlocal

:: Create zip files

echo.
echo Creating zip files for release v%Version%
echo.

%ZipRoot%\zip.exe -j -9 %ZipFile% %TempDir%\%SetupFileName%.exe
%ZipRoot%\zip.exe -j -9 %ZipFile% %ReadMeFile%

:: Tidy up

echo.
echo Deleting temporary directory %TempDir%
echo.

if exist %TempDir% rmdir /S /Q %TempDir%

:: Done

echo.
echo ---------------
echo Build completed
echo ---------------

goto end

:: Error messages

:envvarerror
echo.
echo ***ERROR: ZipRoot, VIEdRoot or InnoSteup environment variable not set
echo.
goto end

:: End

:end
