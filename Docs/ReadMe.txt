DELPHIDABBLER HTML RESOURCE COMPILER README
================================================================================

What is HTML Resource Compiler?
--------------------------------------------------------------------------------

HTMLRes is a Windows command line program that is used to create resource files
containing HTML files. Each resource is of type HTML (#23) and is named after
the source file.

Installation
--------------------------------------------------------------------------------

When installing or uninstalling on Windows NT, 2000 or XP you need to ensure
that you have administrator privileges otherwise the installation can fail. On
Windows Vista the system will prompt, if necessary, for an administrator
password. It will also elevate the process.

If you have HTML Resource Compiler 1.1 or earlier you should uninstall it using
the Add / Remove Programs applet (Programs and Features on Windows Vista) before
installing this version. Uninstalling v1.1 will leave two files, InstallLib.dll
and UnInstall.exe behind in the installation folder. You should should delete
these files (or the containing HTMLRes folder) manually.

The program is distributed in a zip archive which contains two files –
ReadMe.txt (this file) and HTMLRes-Setup-x.x.x.exe, where x.x.x. is the
program's version number. Extract both files from the archive.

HTMLRes-Setup-x.x.x.exe is the installation program. Double-click
HTMLRes-Setup-x.x.x.exe. The installer is a standard wizard style Windows
installer. Follow the instructions in the wizard. You must accept the program's
license to proceed. Once the license is accepted you can configure the
installation directory and the program group name. Once the installation has
completed you have the option to display the user guide and/or license.

The installer installs the main program along with documentation and some
demonstration code that illustrates how to use the compiler. The files, relative
to the installation folder, are:

  HTMLRes.exe – the HTML resource compiler.

  Demo\ sub folder – contains the following demo files:
    arrow.gif – GIF file displayed on index.html.
    Demo.hmfst – manifest file listing all demo files to be compiled by HTMLRes.
    DemoReadMe.txt – ReadMe file for demo code. Please read before using the
      demo code.
    HTMLLib.dpr – Delphi project file for a resource only DLL.
    index.html – main demo HTML page.
    page2.html – secindary demo HTML page.
    style.css – demo style sheet used by HTML pages.

  Docs\ sub folder – contains program documentation:
    ChangeLog.txt – the program's update history.
    License.txt – the program's license.
    ReadMe.txt – contains important install and other information.
    UserGuide.pdf – a guide to using the program and the demo code.

  Uninstall sub folder – contains files required by the uninstaller.

Uninstalling
--------------------------------------------------------------------------------

To uninstall HTMLRes open the Windows Control Panel and start the Add / Remove
Programs applet (or Programs and Features on Windows Vista). Select
DelphiDabbler HTML Resource Compiler v1.x.x (where x.x is the minor version
number) from the list of installed applications and click the Remove (or
Uninstall) button. The uninstall program will now check if you want to go ahead
with the uninstallation. Accept this prompt to continue with uninstallation.

The uninstaller deletes any registry entries that were created by the installer.

User Guide
--------------------------------------------------------------------------------

See UserGuide.pdf in the installation's Docs sub folder for information
on using the program and the demo code.

Copyright and Licensing
--------------------------------------------------------------------------------

The program is copyright (c) 2004-2008, Peter D Johnson (www.delphidabbler.com).
See License.txt file in the installation's Docs sub folder for licensing
information.

Source Code
--------------------------------------------------------------------------------

HTMLRes is open source. Much of the source code is licensed under the Mozilla
public license and other open source licenses. Demo code is public domain.
You can get the source code of the latest release from
http://www.delphidabbler.com/software/htmlres.

Source code of versions back to v1.2 can also be obtained from
http://code.assembla.com/htmlres/subversion/nodes. Select the "trunk" branch to
get the current development tree (which may not be stable). Stable releases are
listed under the "tags" branch.

Subversion users can check out the source code from
http://subversion.assembla.com/svn/htmlres. Append /trunk to get the development
tree or /tags/version-x.x.x, where x.x.x is the version number to get the
specified version, for example v1.2 is at /tags/version-1.2.0.

Source code licensing information is provided in the file SourceCodeLicenses.txt
that will either be in the root or the Docs sub folder of the source code tree,
depending on which version you get.

--------------------------------------------------------------------------------
$Rev$
$Date$
--------------------------------------------------------------------------------
