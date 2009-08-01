
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
DELPHIDABBLER HTML RESOURCE COMPILER SOURCE CODE README
________________________________________________________________________________

Source code for the current version of DelphiDabbler HTML Resource Compiler is
always available from http://www.delphidabbler.com/download?id=htmlres&type=src.

The source code is provided in a zip file, dd-htmlres-src.zip. This file
includes all of the program's original code. Files should be extracted from the
zip file and the directory structure should be preserved.

The directory structure is:

  Bin        : Binary resource files (*1)
  Src        : Pascal and other source code + batch file controlling build  (*2)

  Notes:
    (*1) - See below for details of how to recompile these files
    (*2) - Build batch file described below

In order to compile the program you also need to create a "Exe" directory at the
same level as the "Bin" and "Src" directories.

Additional libraries / components are required to compile HTMLRes successfully.
They are:

  From DelphiDabbler.com:
    Version Information Component (v3.1.1 or later)
    Resource File Unit (1.0 or later)
  The Delphi 7 VCL.

All the libraries must to be available on Delphi's library path.

The program also requires two binary files in order to compile (provided):

  VHTMLRes.res  - The program's version information.
  HTMLRes.res   - All other resources. This is just the manifest for Vista.


¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Build Tools
________________________________________________________________________________

A batch file - Build.bat - is provided in the "Src" directory. It can be used to
automate full or partial builds. It must be called with a command line switch.
Switches are:

  all    - Builds everything.
  res    - Builds binary resource files only. Requires VIEd and BRCC32.
  pas    - Builds the Delphi Pascal project. Requires DCC32.
  setup  - Builds the install program. Requires ISC. Creates installer from
           Install.iss.

The programs required by the build process are:

  VIEd   - DelphiDabbler Version Information Editor, available from
           www.delphidabbler.com. Requires v2.11 or later.
  BRCC32 - Borland Resource Compiler, supplied with Delphi 7.
  DCC32  - Delphi Command Line Compiler, supplied with Delphi 7.
  ISC    - Inno Setup command line compiler, supplied with Inno Setup v5. Also
           requires the ISPP pre-processor v5.

Build.bat requires certain environment variables to be set, as follow:

  DELPHI7 to be set to the install directory of Delphi 7
  DELPHIDABLIBD7 to be set to the install directory of the required
    DelphiDabbler library units that have been compiled for Delphi 7.
  INNOSETUP to be set to Inno Setup install directory
      

¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Licensing
________________________________________________________________________________

Please see SourceCodeLicenses.txt for information about source code licenses.


¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Earlier Versions
________________________________________________________________________________

If you would like the source code of earlier, publicly released, versions of
HTMLRes, please contact me at delphidabbler [At] yahoo [DOT] co [DOT] uk,
specifying the version you would like source code for. See the change log at
http://www.delphidabbler.com/software/htmlres/changelog for details of available
versions.

Please note: source code for versions more than one year old may no longer be
available. 


¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯