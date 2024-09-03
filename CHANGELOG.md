# Change Log

This is the change log for [DelphiDabbler HTML Resource Compiler][1].

All notable changes to this project are documented in this file.

This change log begins with v1.0.0. There were no pre-release v0.x.x releases. Releases are listed in reverse version number order.

## v1.3.0 - 2021-10-16

+ Implemented a minimum of Unicode support:
    - Modified to enable compilation with a Unicode compatible compiler.
    - UTF-8 and UTF-16 encoded manifest files are now supported providing such files have a suitable BOM or prefix, otherwise the system default encoding is assumed:
        - `FE FF` for UTF-16 big endian;
        - `FF FE` for UTF-16 little endian;
        - `EF BB BF` for UTF-8.
    - A UTF-8 encoded manifest was added to the demo project.
+ Recompiled with Delphi XE and revised `Makefile` & `Build.html` accordingly.
+ Major overhaul and update of documentation, including:
    - User guide converted to Markdown - `UserGuide.md` replaces `UserGuide.pdf` and `UserGuide.odt`.
    - This change log converted from plain text to Markdown and renamed `CHANGELOG.md`.
    - Many URLs updated.
+ License extensively changed and simplified:
    - Executable program EULA greatly simplified: it now simply uses [MPL 2.0][3].
    - Source code that was [MPL 1.1][4] licensed changed to [MPL 2.0][3].
    - Documentation changed to [CC BY-SA 4.0][5]. 
    - Demos public domain dedication clarified by use of [CC-0][6] license.

## v1.2.1 - 2014-02-20

+ Fixed non-standard bullet characters in help screen.
+ Compiled against latest versions of PJResourceFile and PJVersionInfo library units.
+ Installer now requires Windows 2000 or later to run.
+ Minor correction to EULA.
+ Updated documentation.

## v1.2.0 - 2008-08-23

+ Added new -u command that enables resources to be inserted and updated in pre-existing resource files.
+ Replaced command line installer with a Windows GUI installer built with Inno Setup.

## v1.1.0 - 2006-05-29

+ Added new -r command that enables file names to be relative to directory containing manifest instead of program execution directory.
+ Changed message displayed when program starts.
+ Changed to new open source EULA for executable code (source still available under MPL).

## v1.0.1 - 2004-09-18

+ Rebuilt using [PJResFile][2] resource file library unit rather than custom resource file handling code.
+ Updated documentation, including new PAD file.

## v1.0.0 - 2004-06-26

+ Original version including demo code and documentation, licensed under Mozilla Public License v1.1.

[1]: https://delphidabbler.com/software/htmlres
[2]: https://delphidabbler.com/software/resfile
[3]: https://mozilla.org/MPL/2.0/
[4]: https://mozilla.org/MPL/1.1/
[5]: https://creativecommons.org/licenses/by-sa/4.0/
[6]: https://creativecommons.org/publicdomain/zero/1.0/
