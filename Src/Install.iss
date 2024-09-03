; ------------------------------------------------------------------------------
; This Source Code Form is subject to the terms of the Mozilla Public License,
; v. 2.0. If a copy of the MPL was not distributed with this file, You can
; obtain one at https://mozilla.org/MPL/2.0/
;
; Copyright (C) 2008-2024, Peter Johnson (gravatar.com/delphidabbler).
;
; HTML Resource Compiler install file generation script for use with Inno Setup.
;
; The following defines use these macros that are predefined by ISPP:
;   SourcePath - path where this script is located
;   GetStringFileInfo - gets requested version info string from an executable
; 
; The following define, which must be defined on the command line using the
; /D option:
;   AppShortName - short name of project. Exe file will be named by appending
;     ".exe"
;   AppVersion - version number of the application (must contain only digits,
;     e.g. 1.2.3.4).
;   AppVersionSuffix - any suffix to the application version number (must start)
;     with "-" , e.g. "-beta.1"
;   SetupOutDir - setup program output directory relative to project root
;   SetupFileName - name of setup file to be created (without path)
;   ExeInDir - directory containing compiled .exe file relative to project root
;   DocsInDir - directory containing documentation relative to project root
;   DemoInDir - directory containing demo files relative to project root
; ------------------------------------------------------------------------------

#define AppPublisher "DelphiDabbler"
#define AppName "HTML Resource Compiler"
#define AppDir AppShortName
#define ExeFile AppShortName + ".exe"
#define ReadmeFile "ReadMe.txt"
#define LicenseFile "License.rtf"
#define LicenseTextFile "LICENSE.md"
#define ChangeLogFile "CHANGELOG.md"
#define UserGuide "UserGuide.md"
#define InstDocsDir "Docs"
#define InstUninstDir "Uninstall"
#define InstDemoDir "Demo"
#define OutDir SourcePath + "..\" + SetupOutDir
#define RootPath SourcePath + "..\"
#define SrcExePath SourcePath + "..\" + ExeInDir + "\"
#define SrcDocsPath SourcePath + "..\" + DocsInDir + "\"
#define SrcDemoPath SourcePath + "..\" + DemoInDir + "\"
#define ExeProg SrcExePath + ExeFile
#define Company "DelphiDabbler.com"
#define Copyright GetStringFileInfo(ExeProg, LEGAL_COPYRIGHT)
#define WebAddress "delphidabbler.com"
#define WebURL "https://" + WebAddress + "/"
#define AppURL WebURL + "software/htmlres"

[Setup]
AppID={{A9C1BCAB-8034-4271-AA8B-9C484FE0EEBC}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppPublisher} {#AppName} {#AppVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#WebURL}
AppSupportURL={#AppURL}
AppUpdatesURL={#AppURL}
AppReadmeFile={app}\{#InstDocsDir}\{#ReadmeFile}
AppCopyright={#Copyright} ({#WebAddress})
AppComments=
AppContact=
DefaultDirName={pf}\{#AppPublisher}\{#AppDir}
DefaultGroupName={#AppPublisher} {#AppName}
AllowNoIcons=true
LicenseFile={#SrcDocsPath}{#LicenseFile}
Compression=lzma/ultra
SolidCompression=true
InternalCompressLevel=ultra
OutputDir={#OutDir}
OutputBaseFilename={#SetupFileName}
VersionInfoVersion={#AppVersion}
VersionInfoTextVersion={#AppVersion}
VersionInfoProductVersion={#AppVersion}
VersionInfoProductTextVersion={#AppVersion}{#AppVersionSuffix}
VersionInfoCompany={#Company}
VersionInfoDescription=Installer for {#AppName}
VersionInfoCopyright={#Copyright}
MinVersion=6.1sp1
TimeStampsInUTC=true
ShowLanguageDialog=yes
RestartIfNeededByRun=false
PrivilegesRequired=admin
UsePreviousAppDir=true
UsePreviousGroup=true
UsePreviousSetupType=false
UsePreviousTasks=false
UninstallFilesDir={app}\{#InstUninstDir}
UpdateUninstallLogAppName=true
UninstallDisplayIcon={app}\{#ExeFile}
UserInfoPage=false

[Dirs]
Name: {app}\{#InstDocsDir}; Flags: uninsalwaysuninstall
Name: {app}\{#InstUninstDir}; Flags: uninsalwaysuninstall

[Files]
; Executable files
Source: {#SrcExePath}{#ExeFile}; DestDir: {app}; Flags: uninsrestartdelete
; Documentation
Source: {#RootPath}{#LicenseTextFile}; DestDir: {app}\{#InstDocsDir}; Flags: ignoreversion
Source: {#SrcDocsPath}{#ReadmeFile}; DestDir: {app}\{#InstDocsDir}; Flags: ignoreversion
Source: {#RootPath}{#ChangeLogFile}; DestDir: {app}\{#InstDocsDir}; Flags: ignoreversion
Source: {#SrcDocsPath}{#UserGuide}; DestDir: {app}\{#InstDocsDir}; Flags: ignoreversion
; Demo
Source: {#SrcDemoPath}*.*; DestDir: {app}\{#InstDemoDir}; Flags: ignoreversion

[Icons]
Name: {group}\{#AppName}; Filename: {app}\{#ExeFile}
Name: {group}\{cm:UninstallProgram,{#AppName}}; Filename: {uninstallexe}

[Run]
Filename: {app}\{#InstDocsDir}\{#UserGuide}; Description: "View the user guide ({app}\{#InstDocsDir}\{#UserGuide})"; Flags: nowait postinstall skipifsilent shellexec skipifsilent
Filename: {app}\{#InstDocsDir}\{#LicenseTextFile}; Description: "View the license ({app}\{#InstDocsDir}\{#LicenseTextFile})"; Flags: nowait postinstall skipifsilent shellexec skipifsilent

[Messages]
; Brand installer
BeveledLabel={#Company}

