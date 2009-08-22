{
 * UMain.pas
 *
 * Implements a class that handles the HTML Resource Compiler's main program
 * processing.
 *
 * $Rev$
 * $Date$
 *
 * ***** BEGIN LICENSE BLOCK *****
 *
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with the
 * License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
 * the specific language governing rights and limitations under the License.
 *
 * The Original Code is UMain.pas.
 *
 * The Initial Developer of the Original Code is Peter Johnson
 * (http://www.delphidabbler.com/).
 *
 * Portions created by the Initial Developer are Copyright (C) 2004-2009 Peter
 * Johnson. All Rights Reserved.
 *
 * Contributor(s):
 *   NONE
 *
 * ***** END LICENSE BLOCK *****
}


unit UMain;

{$WARN UNSAFE_TYPE OFF}

interface


uses
  // Delphi
  Classes,
  // Project
  UParams;


type

  {
  TMain:
    Handles main program processing and traps and reports any exceptions.
  }
  TMain = class(TObject)
  private
    procedure BuildSourceFileList(const SrcFiles: TStringList);
      {Builds a list of all source files (i.e. those passed on command line and
      those from any manifest file).
        @param SrcFiles [in] List of source files built in method.
        @except EError raised with cErrMissingManifest error code if a
          specified file does not exist.
      }
    procedure CheckParamErrors;
      {Checks for existence of any command line parameters errors and raises
      exception if such errors exist.
        @except EError raised with cErrCommandLine error code if command line
          errors exist.
      }
    procedure CheckSourceFilesExist(const SrcFiles: TStringList);
      {Checks if all source files in given list exist and raises exception if
      not.
        @param SrcFiles [in] List of source files to check.
        @except EError raised with cErrMissingSourceFile error code if any
          source files don't exist.
      }
    procedure CheckDuplicateResNames(const SrcFiles: TStringList);
      {Checks all source file names for duplicates file names and raises
      exception if any found.
        @param SrcFiles [in] List of source file names (with paths) to be
          checked.
        @except EError raised with cErrDuplicateResource error code if any
          files have same name.
      }
    procedure CreateResourceFile(const SrcFiles: TStringList);
      {Creates required resource file containing all given source files as HTML
      resources.
        @param SrcFiles [in] List of source files to store in resources.
      }
    procedure DisplayHelp;
      {Writes out help on using program.
      }
    procedure SignOn;
      {Writes out sign-on message.
      }
    procedure SignOff;
      {Optionally displays a sign off message and gets user to press return to
      close program.
      }
    procedure WriteMsg(const Msg: string); overload;
      {Writes a message to output if permitted.
        @param Msg [in] Message to write.
      }
    procedure WriteMsg(const Fmt: string; const Args: array of const); overload;
      {Writes a messages made from a format string and arguments to output if
      permitted.
        @param Fmt [in] Format string.
        @param Args [in] Arguments that replace placeholders in format string.
      }
    procedure WriteErrMsg(const Msg: string);
      {Writes an error message to output if permitted.
        @param Msg [in] Message to write.
      }
  public
    procedure Execute;
      {Executes the main program code. Reads command line, processes source
      files and creates output file.
      }
  end;


implementation


uses
  // Delphi
  SysUtils, Windows,
  // DelphiDabbler library
  PJResFile, PJVersionInfo,
  // Project
  UErrors, UVerInfo;


const
  // End of line characters
  EOL = #13#10;


resourcestring
  // Output strings
  sHelp = 'Usage: HTMLRes [<infiles>] [-m<file>] [-o<file>] [<switches>]'
          + EOL
          + EOL
          + '<infiles> = Zero or more input file names'
          + EOL
          + '-m<file> = "Manifest" file containing list of input file names'
          + EOL
          + '-o<file> = Output file name (default is "out.res")'
          + EOL
          + '<switches> = Zero or more or the following:'
          + EOL
          + '  -r = Make all relative file names relative to manifest file'
          + ' directory'
          + EOL
          + '       (ignored if -m switch not specified before -r switch)'
          + EOL
          + '  -u = Determine how any pre-existing resource file is'
          + ' updated: -u is always'
          + EOL
          + '       immediately followed by :xxx where xxx is one of:'
          + EOL
          + '       ù fail - halt program if output file exists'
          + EOL
          + '       ù overwritefile - overwrite entire file (default)'
          + EOL
          + '       ù insertres - insert resources into existing file'
          + ' (error if'
          + EOL
          + '         duplicate resources)'
          + EOL
          + '       ù overwriteres - insert resources into existing file'
          + ' (duplicate'
          + EOL
          + '         resources are overwritten)'
          + EOL
          + '       If output file doesn''t exist then a new file is created'
          + EOL
          + '  -p = Pause at end of processing and wait for key press'
          + EOL
          + '  -q = Quiet mode: only error messages are output'
          + EOL
          + '  -Q = Very quiet mode: no screen output'
          + EOL
          + '  -h or -? = Display this help'
          + EOL
          + EOL
          + 'At least one input file or manifest file'
          + ' or -? switch must be specified.';
  sSignOnMsg = 'HTMLRes v%s'    // inserts product version here
          + EOL
          + '%s';               // inserts copyright info here
  sProcessingSrcFile = 'Processing source file: "%s"';
  sOverwritingEntry = 'Overwriting resource entry: "%s"';
  sCreatingEntry = 'Creating resource entry: "%s"';
  sWritingResFile = 'Writing resource file: "%s"';
  sUsageMsg = 'Usage: HTMLRes [<infiles>] [-m<file>] [-o<file>] [<switches>]'
          + EOL
          + 'Use HTMLRes -? for help';
  sPressReturnMsg = 'Press return to end';

  // Error messages
  sError = 'ERROR:';
  sMissingManifestFile = 'Manifest file "%s" does not exist';
  sCommandLineErrPrefix = 'Command line error(s):';
  sMissingSrcFileErrPrefix = 'Source file(s) not found:';
  sDuplicateResName = 'Duplicate resource (file) names in files:';
  sOutFileExists = 'Output file "%s" already exists';
  sOutFileNotResFile = 'Output file "%s" is not a valid resource file';
  sResourceExists = 'Resource "%s" already exists in "%s"';


{ TMain }

procedure TMain.BuildSourceFileList(const SrcFiles: TStringList);
  {Builds a list of all source files (i.e. those passed on command line and
  those from any manifest file).
    @param SrcFiles [in] List of source files built in method.
    @except EError raised with cErrMissingManifest error code if a
      specified file does not exist.
  }
var
  I: Integer;             // loops thru file lists
  ManFiles: TStringList;  // list of files from manifest file
  ManFile: string;        // a file from manifest file
begin
  // Ensure source file list is sorted and ignores duplicate entries
  SrcFiles.Sorted := True;
  SrcFiles.Duplicates := dupIgnore;
  // Record files passed on command line
  for I := 0 to Pred(Params.InFileCount) do
    SrcFiles.Add(Params.InFiles[I]);
  // Read files from any manifest file
  if (Params.ManifestFile <> '') then
  begin
    if not FileExists(Params.ManifestFile) then
      raise EError.CreateFmt(
        sMissingManifestFile, [Params.ManifestFile], cErrMissingManifest
      );
    ManFiles := TStringList.Create;
    try
      ManFiles.LoadFromFile(Params.ManifestFile);
      // process lines from manifest file (ignore blank and comment lines)
      for I := 0 to Pred(ManFiles.Count) do
      begin
        ManFile := Trim(ManFiles[I]);
        if (ManFile <> '') and (ManFile[1] <> '#') then
          SrcFiles.Add(ManFile);
      end;
    finally
      FreeAndNil(ManFiles);
    end;
  end;
end;

procedure TMain.CheckDuplicateResNames(const SrcFiles: TStringList);
  {Checks all source file names for duplicates file names and raises
  exception if any found.
    @param SrcFiles [in] List of source file names (with paths) to be
      checked.
    @except EError raised with cErrDuplicateResource error code if any
      files have same name.
  }
var
  ResNames: TStringList;    // list of resource names
  ResName: string;          // a resource name
  Duplicates: TStringList;  // list of duplicate file (resource) names
  I: Integer;               // loops thru string lists
  Msg: string;              // used to build error message
begin
  Duplicates := nil;
  ResNames := TStringList.Create;
  try
    Duplicates := TStringList.Create;
    // loop thru input source files checking for duplicate file names
    for I := 0 to Pred(SrcFiles.Count) do
    begin
      ResName := UpperCase(ExtractFileName(SrcFiles[I]));
      if ResNames.IndexOf(ResName) = -1 then
        ResNames.Add(ResName)
      else
        Duplicates.Add(ResName);  // we have duplicate - record it
    end;
    // Raise exception if duplicates detected
    if Duplicates.Count > 0 then
    begin
      Msg := sDuplicateResName;
      for I := 0 to Pred(Duplicates.Count) do
        Msg := Msg + EOL + '  ' + Duplicates[I];
      raise EError.Create(Msg, cErrDuplicateResource);
    end;
  finally
    FreeAndNil(Duplicates);
    FreeAndNil(ResNames);
  end;
end;

procedure TMain.CheckParamErrors;
  {Checks for existence of any command line parameters errors and raises
  exception if such errors exist.
    @except EError raised with cErrCommandLine error code if command line
      errors exist.
  }
var
  I: Integer;   // loops thru errors
  Msg: string;  // error message
begin
  if Params.ErrorCount > 0 then
  begin
    Msg := sCommandLineErrPrefix;
    for I := 0 to Pred(Params.ErrorCount) do
      Msg := Msg + EOL + '  ' + Params.Errors[I];
    raise EError.Create(Msg, cErrCommandLine);
  end;
end;

procedure TMain.CheckSourceFilesExist(const SrcFiles: TStringList);
  {Checks if all source files in given list exist and raises exception if
  not.
    @param SrcFiles [in] List of source files to check.
    @except EError raised with cErrMissingSourceFile error code if any
      source files don't exist.
  }
var
  I: Integer;             // loops thru string lists
  FileName: string;       // a source file name
  BadFiles: TStringList;  // list of source files that don't exist
  ErrMsg: string;         // error message
begin
  // Store names of all source files that don't exist in bad file list
  BadFiles := TStringList.Create;
  try
    for I := 0 to Pred(SrcFiles.Count) do
    begin
      FileName := SrcFiles[I];
      if not FileExists(FileName) then
        BadFiles.Add(FileName);
    end;
    // If we have bad files raise exception with message listing all such files
    if BadFiles.Count >  0 then
    begin
      ErrMsg := sMissingSrcFileErrPrefix;
      for I := 0 to Pred(BadFiles.Count) do
        ErrMsg := ErrMsg + EOL + '  ' + BadFiles[I];
      raise EError.Create(ErrMsg, cErrMissingSourceFile);
    end;
  finally
    FreeAndNil(BadFiles);
  end;
end;

procedure TMain.CreateResourceFile(const SrcFiles: TStringList);
  {Creates required resource file containing all given source files as HTML
  resources.
    @param SrcFiles [in] List of source files to store in resources.
    @except EError raised with various error codes if error conditions
      encountered.
  }

  // ---------------------------------------------------------------------------
  procedure HandleExistingResFile(const ResFile: TPJResourceFile);
    {Determines how to deal with a pre-existing resource file depending on
    configuration.
      @param ResFile [in] object encapsulating contents of resource file.
      @except EError raised with cErrOutFileExists error code if we are to fail
        program if output file exists.
      @except EError raised with cErrBadOutFile error code if file is to be
        updated and is not a valid resource file.
    }
  var
    ResFileStm: TFileStream;  // stream used to read existing resource file
  begin
    // Action depends on configuration stored in parameter object's
    // FileUpdateAction property:
    //   uaFail: program fails if output file already exists
    //   uaOverwriteFile: output file is overwritten
    //   uaInsertRes: inserts resource into existing file: program fails if
    //     resource already exists
    //   uaOverwriteRes: inserts resource into existing file: existing resources
    //     are overwritten
    ResFile.Clear;
    if Params.FileUpdateAction = uaFail then
      raise EError.CreateFmt(
        sOutFileExists, [Params.OutFile], cErrOutFileExists
      );
    if Params.FileUpdateAction in [uaInsertRes, uaOverwriteRes] then
    begin
      // We need to update content of existing file
      ResFileStm := TFileStream.Create(
        Params.OutFile, fmOpenRead or fmShareDenyNone
      );
      try
        // load file if it is a valid resource file
        if not TPJResourceFile.IsValidResourceStream(ResFileStm) then
          raise EError.CreateFmt(
            sOutFileNotResFile, [Params.OutFile], cErrBadOutFile
          );
        ResFileStm.Position := 0;
        ResFile.LoadFromStream(ResFileStm);
      finally
        FreeAndNil(ResFileStm);
      end;
    end;
  end;

  function GetResourceEntry(const ResFile: TPJResourceFile;
    const ResName: string): TPJResourceEntry;
    {Gets resource entry for a resource name. Resource is created if it doesn't
    already exist. Resource has no content.
      @param ResFile [in] object encapsulating contents of resource file.
      @param ResName [in] name of required resource.
      @except EError raised with cErrResourceExists if resource exists in output
        file and we're inserting resources into file without overwriting
        duplicate resources.
    }
  begin
    // Assume we have no resource entry
    Result := nil;
    if Params.FileUpdateAction in [uaInsertRes, uaOverwriteRes] then
    begin
      // We are updating content of resource file
      if ResFile.EntryExists(RT_HTML, PChar(ResName), 0) then
      begin
        // Matching resource already exists in resource file
        if Params.FileUpdateAction = uaInsertRes then
          // we're inserting without overwriting existing resource entries:
          // this is an error
          raise EError.CreateFmt(
            sResourceExists, [ResName, Params.OutFile], cErrResourceExists
          );
        // we're inserting and overwriting existing resource entries: get
        // reference to existing entry
        WriteMsg(sOverwritingEntry, [ResName]);
        Result := ResFile.FindEntry(RT_HTML, PChar(ResName), 0);
        Result.Data.Size := 0;
      end;
    end;
    if not Assigned(Result) then
    begin
      // We haven't found matching entry: create a new one
      WriteMsg(sCreatingEntry, [ResName]);
      Result := ResFile.AddEntry(RT_HTML, PChar(ResName), 0);
    end;
    // Set entry's flags
    Result.MemoryFlags := RES_MF_MOVEABLE or RES_MF_PURE;
  end;

  procedure CopySourceFileToResourceEntry(const ResEntry: TPJResourceEntry;
    const SrcFileName: string);
    {Copies contents of a source file into a resource entry.
      @param ResEntry [in] Entry to receive source file contents.
      @param SrcFileName [in] Name of source file providing content.
    }
  var
    SrcFileStm: TFileStream;  // read stream onto source file
  begin
    SrcFileStm := TFileStream.Create(
      SrcFileName, fmOpenRead or fmShareDenyNone
    );
    try
      ResEntry.Data.CopyFrom(SrcFileStm, 0);
    finally
      FreeAndNil(SrcFileStm);
    end;
  end;

  procedure WriteResourceFile(const ResFile: TPJResourceFile);
    {Writes completed resource file data to output file.
      @param ResFile [in] object encapsulating contents of resource file.
    }
  var
    OutFileStm: TFileStream;  // write stream onto output file
  begin
    WriteMsg(sWritingResFile, [Params.OutFile]);
    OutFileStm := TFileStream.Create(Params.OutFile, fmCreate);
    try
      ResFile.SaveToStream(OutFileStm);
    finally
      FreeAndNil(OutFileStm);
    end;
  end;
  // ---------------------------------------------------------------------------

var
  ResFile: TPJResourceFile;   // object used to write resource file
  SrcFileName: string;        // name of a source file
  ResEntry: TPJResourceEntry; // object used to for each resource entry in file
  ResName: string;            // name of a resource
  I: Integer;                 // loops thru all
begin
  // Create empty resource file
  ResFile := TPJResourceFile.Create;
  try
    // If output file already exists decide how to handle it
    if FileExists(Params.OutFile) then
      HandleExistingResFile(ResFile); // this may load existing resource file
    // Process each source file, adding to resource file
    for I := 0 to Pred(SrcFiles.Count) do
    begin
      SrcFileName := SrcFiles[I];
      WriteMsg(sProcessingSrcFile, [SrcFileName]);
      ResName := ExtractFileName(UpperCase(SrcFileName));
      ResEntry := GetResourceEntry(ResFile, ResName);
      CopySourceFileToResourceEntry(ResEntry, SrcFileName);
    end;
    WriteResourceFile(ResFile);
  finally
    FreeAndNil(ResFile);
  end;
end;

procedure TMain.DisplayHelp;
  {Writes out help on using program.
  }
begin
  WriteLn(sHelp);
end;

procedure TMain.Execute;
  {Executes the main program code. Reads command line, processes source
  files and creates output file.
  }
var
  SrcFiles: TStringList;  // stores list of source files
begin
  try
    SignOn;             // displays sign-on message
    CheckParamErrors;   // raises exception if parameters not valid
    if not Params.Help then
    begin
      // Do main processing
      SrcFiles := TStringList.Create;
      try
        BuildSourceFileList(SrcFiles);    // exception if manifest doesn't exist
        CheckDuplicateResNames(SrcFiles); // exception on duplicates
        CheckSourceFilesExist(SrcFiles);  // exception if file doesn't exist
        CreateResourceFile(SrcFiles);
      finally
        FreeAndNil(SrcFiles);
      end;
    end
    else
      // Help command line switch present
      DisplayHelp;
  except
    // Report any errors
    on E: EError do
    begin
      WriteErrMsg(E.Message);
      ExitCode := E.ErrorCode;
    end;
    on E: Exception do
    begin
      WriteErrMsg(E.Message);
      ExitCode := cErrUnexpected;
    end;
  end;
  SignOff;
end;

procedure TMain.SignOff;
  {Optionally displays a sign off message and gets user to press return to
  close program.
  }
begin
  // Only display sign-off message if required by -p command line switch
  if Params.Pause then
  begin
    WriteLn;
    Write(sPressReturnMsg);
    ReadLn;
  end;
end;

procedure TMain.SignOn;
  {Writes out sign-on message.
  }
begin
  WriteMsg(sSignOnMsg, [GetProductVersionStr, GetCopyrightStr]);
  WriteMsg('');
end;

procedure TMain.WriteErrMsg(const Msg: string);
  {Writes an error message to output if permitted.
    @param Msg [in] Message to write.
  }
begin
  // Write actual error message if quietness level not silent
  if Params.Quietness <> qsSilent then
    WriteLn(sError, ' ', Msg);
  // And write following usage message only quietness levels are off
  WriteMsg('');
  WriteMsg(sUsageMsg);
end;

procedure TMain.WriteMsg(const Msg: string);
  {Writes a message to output if permitted.
    @param Msg [in] Message to write.
  }
begin
  // Only write if quietness levels are off
  if Params.Quietness = qsOff then
    WriteLn(Msg);
end;

procedure TMain.WriteMsg(const Fmt: string; const Args: array of const);
  {Writes a messages made from a format string and arguments to output if
  permitted.
    @param Fmt [in] Format string.
    @param Args [in] Arguments that replace placeholders in format string.
  }
begin
  WriteMsg(Format(Fmt, Args));
end;

end.

