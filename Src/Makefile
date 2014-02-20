# ------------------------------------------------------------------------------
# Makefile
#
# Makefile for the project.
#
# ***** BEGIN LICENSE BLOCK *****
#
# Version: MPL 1.1
#
# The contents of this file are subject to the Mozilla Public License Version
# 1.1 (the "License"); you may not use this file except in compliance with the
# License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
#
# Software distributed under the License is distributed on an "AS IS" basis,
# WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
# the specific language governing rights and limitations under the License.
#
# The Original Code is Makefile
#
# The Initial Developer of the Original Code is Peter Johnson
# (http://www.delphidabbler.com/).
#
# Portions created by the Initial Developer are Copyright (C) 2009-2014 Peter
# Johnson. All Rights Reserved.
#
# Contributors:
#   NONE
#
# ***** END LICENSE BLOCK *****
# ------------------------------------------------------------------------------


# Set bin output path
BIN = ..\Bin

# The preferred compiler is Delphi 7. If the DELPHI7 evironment variable
# is set, it will be used and expected to Delphi 7 install directory.
# If DELPHI7 is not set then the DELPHIROOT environment variable is examined.
# This can be set to any Delphi compiler (should compile if later than Delphi
# 7). If neither DELPHI7 nor DELPHIROOT is set then a Delphi compiler is
# expected to be present on the system path.
!ifdef DELPHI7
DELPHIROOT = $(DELPHI7)
!endif

# Check for required macros
!ifndef DELPHIROOT
!error DELPHIROOT or DELPHI7 environment variable required.
!endif
!ifndef BIN
!error BIN macro must be defined in calling script.
!endif

# Define common macros that access required build tools
MAKE = "$(MAKEDIR)\Make.exe" -$(MAKEFLAGS)
DCC32 = "$(DELPHIROOT)\Bin\DCC32.exe"
BRCC32 = "$(DELPHIROOT)\Bin\BRCC32.exe"
!ifdef VIEDROOT
VIED = "$(VIEDROOT)\VIEd.exe" -makerc
!else
VIED = VIEd.exe -makerc
!endif
!ifdef INNOSETUP
ISCC = "$(INNOSETUP)\ISCC.exe"
!else
ISCC = ISCC.exe
!endif
!ifdef ZIPROOT
ZIP = "$(ZIPROOT)\Zip.exe"
!else
ZIP = Zip.exe
!endif

# Implicit rules
# Delphi projects are assumed to contain required output and seaSrch path
# locations in the project options .cfg file.
.dpr.exe:
  @echo +++ Compiling Delphi Project $< +++
  @$(DCC32) $< -B

# Resource files are compiled to the directory specified by BIN macro, which
# must have been set by the caller.
.rc.res:
  @echo +++ Compiling Resource file $< +++
  @$(BRCC32) $< -fo$(BIN)\$(@F)

# Version info files are compiled by VIEd. A temporary .rc file is left behind
.vi.rc:
  @echo +++ Compiling Version Info file $< +++
  @$(VIED) .\$<

# Default target is to configure, build everything and release
everything: config resources pascal setup release

# Configure source folders
config:
  @echo Configuring HTMLRes
  # Create .cfg and .bdsproj files from templates
  @copy /Y HTMLRes.cfg.tplt HTMLRes.cfg
  @copy /Y HTMLRes.dof.tplt HTMLRes.dof
  # Create build folders
  @cd ..
  @if exist Bin rmdir /S /Q Bin
  @if exist Exe rmdir /S /Q Exe
  @if exist Release rmdir /S /Q Release
  @mkdir Bin
  @mkdir Exe
  @mkdir Release
  @cd Src

# Compiles the resources and deletes intermediate file created by VIED
resources: VHTMLRes.res HTMLRes.res
  -@del VHTMLRes.rc

# Builds HTMLRes pascal files and links program
pascal: HTMLRes.exe

# Builds setup program
setup:
  @del ..\Exe\HTMLRes-Setup-*
  @$(ISCC) Install.iss

# Build release files (.zip)
!ifndef RELEASEFILENAME
RELEASEFILENAME = dd-htmlres
!endif
OUTFILE = Release\$(RELEASEFILENAME).zip
release:
  @echo.
  @echo Creating Release File
  @echo ---------------------
  @cd ..
  -@if exist $(OUTFILE) del $(OUTFILE)
  @$(ZIP) -j -9 $(OUTFILE) Exe\HTMLRes-Setup-*.exe Docs\ReadMe.txt
  @cd Src

# Clean up unwanted files
clean:
  @cd ..
  # remove unwanted files: temps (~ or .~*), .dsk, .local, .identcache
  -@del /S *.~* 2>nul
  -@del /S ~* 2>nul
  -@del /S *.dsk 2>nul
  -@del /S *.local 2>nul
  -@del /S *.identcache 2>nul
  # remove __history folders
  -@for /F "usebackq" %i in (`dir /S /B /A:D ..\__history`) do @rmdir /S /Q %i
  @cd Src
