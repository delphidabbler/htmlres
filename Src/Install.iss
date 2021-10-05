; ------------------------------------------------------------------------------
; This Source Code Form is subject to the terms of the Mozilla Public License,
; v. 2.0. If a copy of the MPL was not distributed with this file, You can
; obtain one at http://mozilla.org/MPL/2.0/
;
; Copyright (C) 2008-2021, Peter Johnson (gravatar.com/delphidabbler).
;
; HTML Resource Compiler install file generation script for use with Inno Setup.
; ------------------------------------------------------------------------------


; Deletes "Release " from beginning of S
#define DeleteToVerStart(str S) \
  /* assumes S begins with "Release " followed by version as x.x.x */ \
  Local[0] = Copy(S, Len("Release ") + 1, 99), \
  Local[0]

; The following defines use these macros that are predefined by ISPP:
;   SourcePath - path where this script is located
;   GetStringFileInfo - gets requested version info string from an executable
;   GetFileProductVersion - gets product version info string from an executable

#define AppPublisher "DelphiDabbler"
#define AppName "HTML Resource Compiler"
#define AppShortName "HTMLRes"
#define AppDir AppShortName
#define ExeFile AppShortName + ".exe"
#define ReadmeFile "ReadMe.txt"
#define LicenseFile "License.rtf"
#define LicenseTextFile "License.txt"
#define ChangeLogFile "CHANGELOG.md"
#define UserGuide "UserGuide.md"
#define InstDocsDir "Docs"
#define InstUninstDir "Uninstall"
#define InstDemoDir "Demo"
#define OutDir SourcePath + "..\Exe"
#define SrcExePath SourcePath + "..\Exe\"
#define SrcDocsPath SourcePath + "..\Docs\"
#define SrcDemoPath SourcePath + "..\Demo\"
#define ExeProg SrcExePath + ExeFile
#define Company "DelphiDabbler.com"
#define AppVersion DeleteToVerStart(GetFileProductVersion(ExeProg))
#define Copyright GetStringFileInfo(ExeProg, LEGAL_COPYRIGHT)
#define WebAddress "www.delphidabbler.com"
#define WebURL "http://" + WebAddress + "/"
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
OutputBaseFilename={#AppShortName}-Setup-{#AppVersion}
VersionInfoVersion={#AppVersion}
VersionInfoCompany={#Company}
VersionInfoDescription=Installer for {#AppName}
VersionInfoTextVersion={#AppVersion}
VersionInfoCopyright={#Copyright}
MinVersion=0,5.0
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
Source: {#SrcDocsPath}{#LicenseTextFile}; DestDir: {app}\{#InstDocsDir}; Flags: ignoreversion
Source: {#SrcDocsPath}{#ReadmeFile}; DestDir: {app}\{#InstDocsDir}; Flags: ignoreversion
Source: {#SourcePath}{#ChangeLogFile}; DestDir: {app}\{#InstDocsDir}; Flags: ignoreversion
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

