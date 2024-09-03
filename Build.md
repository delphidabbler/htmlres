# HTMLRes Build Instructions

## Introduction

_HTMLRes_ is written in Object Pascal and is targeted at Delphi 12.1 and later.

Development can take place entirely within the IDE providing some prerequisites are met. However releases must be built using the `Deploy.bat` script.

> These notes apply only to the source code of releases from _HTMLRes_ v1.4.x.

## Prerequisites

### Tools 

The following tools are required to build _HTMLRes_. 

Tools marked with an asterisk are required when compiling from the IDE: compiles will fail if they are not installed and configured.

| Tools | Notes |
|-------|--------|
| Delphi 12.1 | Later Delphi compilers should be suitable. Some earlier compilers may work but none have been tested. |
| MSBuild | This tool is installed with Delphi. Used directly by `Deploy.bat` to build _HTMLRes_. |
| BRCC32 * | This tool is installed with Delphi. Used in pre-build events to create `.res` files from custom `.rc` files. |
| Version Information Editor * | v2.15.1 or later is required. Used in pre-build events create an `.rc` file containing version information from `.vi` files. [Download here](https://github.com/delphidabbler/vied/releases). |
| Inno Setup | v5.6.1 or later Unicode version (not v6). Used by `Deploy.bat` to create the installer. [Download here](https://www.innosetup.com/). |
| InfoZip's Zip tool | Used by `Deploy.bat` to create the release zip file. [Download here](https://delphidabbler.com/extras/info-zip). |
| PowerShell | Used by `Deploy.bat` to grab version information from the compiled `.exe` file. |

### Environment Variables

The following environment variables must be set to build _HTMLRes_

Environment variables marked with an asterisk are required when compiling from the IDE: compiles will fail if they are not set correctly. Such variables can be set using Delphi's _Tools | Options_ menu, going to the _Environment Variables_ page then creating the variable in _User System Overrides_ section.

All environment variables are required when creating releases using `Deploy.bat`.

| Environment Variables | Notes |
|-----------------------|-------|
| MSBuild specific variables | The `rsvars.bat` script in the `Bin` sub-directory of the Delphi installation directory sets these variables to the required values. |
| `ZipRoot` | Set this to the directory where the InfoZip Zip tool was installed. |
| `VIEdRoot` * | Set this to the directory where Version Information Editor was installed (the `DelphiDabbler\VIEd` subdirectory of the 32 bit program files directory, by default). |
| `InnoSetup` | Set this to the directory where the Unicode version of Inno Setup 5 was installed. |

You can configure the environment using a batch file similar to the following:

```batch
:: set path to Delphi 12 installation (change directory if not using Delphi 12)
set DELPHIROOT=C:\Program Files (x86)\Embarcadero\Studio\23.0

:: set environment variables required by MSBuild
call "%DELPHIROOT%\Bin\rsvars.bat"

:: set install path of tools (change as required)
set ZipRoot=C:\Tools
set VIEdRoot=C:\Program Files (x86)\DelphiDabbler\VIEd
set InnoSetup=C:\Program Files (x86)\Inno Setup 5
```

## Source Code

Download the _HTMLRes_ source code from the ['delphidabbler/htmlres'](https://github.com/delphidabbler/htmlres) GitHub repository. You can either clone it using Git or download a zip file containing the source.

There are no source code dependencies other than the Delphi RTL/VCL.

After obtaining the source code you should have the following directory structure:
</p>

```text
/-+
  |
  +-- .git                  - present only if using git
  |
  +-- Demo                  - demonstration source code & support files
  |
  +-- Docs                  - documentation
  |
  +-- Src                   - source code
      |
      +-- Vendor            - imported 3rd party source code
```

Git users will also see the usual `.git` hidden directory.

## Compiling

### From The Delphi IDE

Simply open the `.dproj` file in Delphi and compile. Providing the [Prerequisites](#prerequisites) have been met, the program should compile without problems.

All compiler output is placed in a `_build` directory. This directory is ignored by Git. The following structure is used:

```text
/-+
  |
  +-- .git                  - present only if using git
  |
  +-- _build
  |   |
  |   +-- bin               - contains all binary intermediate files
  |   |
  |   +-- exe               - contains the compiled exe file
  |
  +-- Demo                  - demonstration source code & support files
  ⁞
```

You can now hack away as you wish.

### Creating A Release

To create a release ensure that all the [Prerequisite Tools](#tools) have been installed. Then:

1. Open a terminal.
2. Run any configuration script you have created, or set the [environment variables](#environment-variables) manually.
3. Change directory into the root of the _HTMLRes_ source code.
4. Run `Deploy.bat` without any parameters.

`Deploy.bat` will:

1. Build the _HTMLRes_ executable.
2. Extract the release version information from the executable.
3. Compile the setup program.
4. Create a zip file containing the setup program and some documentation.

The release version information extracted in step 2 is used to set the setup program's version and to embed the version number in the names of the setup program file and zip file.

The `release` zip file is placed in the release sub-directory of `_build`:

```text
/-+
  ⁞
  +-- _build
  |   |
  |   +-- bin               - contains all binary intermediate files
  |   |
  |   +-- exe               - contains the compiled exe file
  |   |
  |   +-- release           - contains the release zip file
  ⁞
```

### Tidying Up

If you are using Git you can run

```test
git clean -fxd
```

to remove all unwanted files.

> :warning: Running the above command will remove the `_build` directory and all its contents, so ensure you copy any wanted files from there beforehand. The command will also remove Delphi's `__history` directory.

## Copyright
  
If you are planning to re-use or modify any of the code, please see the file `LICENSE.md` for an overview of the open source licenses that apply
to the source code.
