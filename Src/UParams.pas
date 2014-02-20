{
 * UParams.pas
 *
 * Implements class that parses the HTML Resource Compiler's command line, lists
 * errors and exposes information from command line as properties.
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
 * The Original Code is UParams.pas.
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


unit UParams;


interface


uses
  // Delphi
  Classes;


type

  {
  TQuietState:
    Level of "quietness" of program output.
  }
  TQuietState = (
    qsOff,            // all program messages displayed (default)
    qsErrsOnly,       // only error messages are displayed
    qsSilent          // totally silent: no output
  );

  {
  TFileUpdateAction:
    Action to take if output resource file already exists.
  }
  TFileUpdateAction = (
    uaFail,           // fail if output already exists
    uaOverwriteFile,  // overwrite any existing file (default)
    uaInsertRes,      // insert resources into file, fail if resource exists
    uaOverwriteRes    // insert resources into file, overwrite existing resource
  );

  {
  TParams:
    Parses command line, lists errors and exposes information from command line
    as properties.
  }
  TParams = class(TObject)
  private
    fPause: Boolean;
      {Whether to pause for return key press at end of program}
    fHelp: Boolean;
      {Whether to display help screen}
    fOutFile: string;
      {Name of output file}
    fManifestFile: string;
      {Name of any manifest file}
    fQuietness: TQuietState;
      {Level of verbosity of screen output}
    fFileUpdateAction: TFileUpdateAction;
      {Indicates how to handle output files that already exist}
    fInFiles: TStringList;
      {List of input files specified on command line}
    fErrors: TStringList;
      {List of command line errors}
    function GetInFile(Idx: Integer): string;
      {Gets the name of an input file from the InFiles[] property.
        @param Idx [in] Index into InFiles[] property.
        @return Input file name at the given index.
      }
    function GetInFileCount: Integer;
      {Gets the number of input files in InFiles[] property.
        @return File name count.
      }
    function GetError(Idx: Integer): string;
      {Gets an error message from the Errors[] property.
        @param Idx [in] Index into Errors[] property.
        @return error message at given index.
      }
    function GetErrorCount: Integer;
      {Gets the number of errors in Errors[] property.
        @return Error count.
      }
  public
    constructor Create;
      {Class constructor. Creates TParams object and parses command line.
      }
    destructor Destroy; override;
      {Class destructor. Tears down object.
      }
    property Pause: Boolean read fPause;
      {Whether to pause for return key press when program ends (-p switch)}
    property Quietness: TQuietState read fQuietness;
      {Verbosity of output required (-q and -Q switches)}
    property FileUpdateAction: TFileUpdateAction read fFileUpdateAction;
      {How to handle output files that already exist}
    property Help: Boolean read fHelp;
      {Whether to display help (-h or -? switches)}
    property ManifestFile: string read fManifestFile;
      {Name of manifest file from -m parameter (defaults to '')}
    property OutFile: string read fOutFile;
      {Name of output file from -o parameter (defaults to out.res)}
    property InFiles[Idx: Integer]: string read GetInFile;
      {Array of input files from command line, indexed 0..InFileCount-1}
    property InFileCount: Integer read GetInFileCount;
      {Number of input files from command line}
    property Errors[Idx: Integer]: string read GetError;
      {Array of command line errors, indexed 0..ErrorCount-1}
    property ErrorCount: Integer read GetErrorCount;
      {Number of command line errors in Errors property}
  end;

function Params: TParams;
  {Gets reference to singleton TParams object.
    @return Required reference.
  }


implementation


uses
  // Delphi
  SysUtils;


const
  // Default output file
  cDefOutFile = 'out.res';


resourcestring
  // Error messages
  sBadFileSwitch = 'No file name supplied with switch "%s"';
  sUnknownSwitch = 'Unrecognised switch: "%s"';
  sMalformedSwitch = 'Malformed switch: "%s"';
  sNoInputFiles = 'No input files specified';
  sManifestNotInput = 'Manifest file can''t be specified as an input file';
  sOutputNotInput = 'Output file can''t be specified as an input file';
  sOutputAndManifestSame  = 'Output and manifest files can''t have same name';
  sBadUpdateAction = 'Unrecognised file update action in -i switch: "%s"';


var
  // Reference to singleton instance of TParams
  Singleton: TParams;


function Params: TParams;
  {Gets reference to singleton TParams object.
    @return Required reference.
  }
begin
  if not Assigned(Singleton) then
    Singleton := TParams.Create;
  Result := Singleton;
end;


{ TParams }

constructor TParams.Create;
  {Class constructor. Creates TParams object and parses command line.
  }

  // ---------------------------------------------------------------------------
  procedure RecordError(const Msg: string);
    {Records error message in command line Errors property.
      @param Msg [in] Error message to be recorded.
    }
  begin
    fErrors.Add(Msg);
  end;

  function FileNameFromSwitch(const Switch: string): string;
    {Extracts file name from end of switch (form -Xfilename). Records error
    message in Errors property if there is no file name after switch.
      @param Switch [in] Switch with appended file name.
      @return File name.
    }
  begin
    Result := Copy(Switch, 3, MaxInt);
    if Result = '' then
      RecordError(Format(sBadFileSwitch, [Switch]));
  end;

  function UpdateActionFromSwitch(const Switch: string): TFileUpdateAction;
    {Analyses -u switch to determine how output file is to be handled if it
    already exists.
      @param Switch [in] Complete -u switch.
      @return Action to be taken to handle output file.
    }
  var
    Action: string; // action component of -u switch
  begin
    // assume default result (keeps compiler happy)
    Result := uaOverwriteFile;
    // format of -u switch is -u:action
    Action := LowerCase(Copy(Switch, 3, MaxInt));
    if Action = ':fail' then
      Result := uaFail
    else if Action = ':overwritefile' then
      Result := uaOverwriteFile
    else if Action = ':insertres' then
      Result := uaInsertRes
    else if Action = ':overwriteres' then
      Result := uaOverwriteRes
    else
      RecordError(Format(sBadUpdateAction, [Action]));
  end;
  // ---------------------------------------------------------------------------

var
  I: Integer;     // loops thru command line parameters
  Param: string;  // a parameter
begin
  inherited;
  // Create owned objects
  fInFiles := TStringList.Create;
  fErrors := TStringList.Create;
  // Set default property values
  fPause := False;
  fQuietness := qsOff;
  fFileUpdateAction := uaOverwriteFile;
  fHelp := False;
  fManifestFile := '';
  fOutFile := cDefOutFile;
  // Parse command line
  for I := 1 to ParamCount do
  begin
    Param := ParamStr(I);
    if Param[1] in ['-', '/'] then
    begin
      // Process a switch
      if Length(Param) >= 2 then
      begin
        case Param[2] of
          'P', 'p':
            // pause at end of program until return pressed (ignores -q & -Q)9
            fPause := True;
          'q':
            // no standard output: errors reported
            if fQuietness <> qsSilent then
              fQuietness := qsErrsOnly;
          'Q':
            // no output at all: errors not reported (overrides -q)
            fQuietness := qsSilent;
          'H', 'h', '?':
            // display help screen (ignores -q and -Q)
            fHelp := True;
          'M', 'm':
            // use following file as input file manifest
            fManifestFile := FileNameFromSwitch(Param);
          'O', 'o':
            // use following file as output file
            fOutFile := FileNameFromSwitch(Param);
          'R', 'r':
            // use path to manifest as current directory for relative file names
            // this switch must follow -m on command line or it will be ignored
            if fManifestFile <> '' then
              SetCurrentDir(ExtractFileDir(fManifestFile));
          'U', 'u':
            // indicates action to be taken if output file already exists: use
            // text following ':' to determine action
            fFileUpdateAction := UpdateActionFromSwitch(Param);
          else
            RecordError(Format(sUnknownSwitch, [Param]));
        end;
      end
      else
        // Error bad switch: no id
        RecordError(Format(sMalformedSwitch, [Param]));
    end
    else
    begin
      // Process a file name: ignore duplicates
      if fInFiles.IndexOf(Param) = -1 then
        fInFiles.Add(Param);
    end;
  end;
  // Check for error switch combinations
  // we must have at least one input file or a manifest file or be requesting
  // help
  if (fInFiles.Count = 0) and (fManifestFile = '') and not fHelp then
    RecordError(sNoInputFiles);
  // check that neither manifest file nor output file are also specified as
  // input files
  if fInFiles.IndexOf(fManifestFile) <> -1 then
    RecordError(sManifestNotInput);
  if fInFiles.IndexOf(fOutFile) <> -1 then
    RecordError(sOutputNotInput);
  // make sure that any manifest doesn't have same name as output file
  if AnsiCompareText(fOutFile, fManifestFile) = 0 then
    RecordError(sOutputAndManifestSame);
end;

destructor TParams.Destroy;
  {Class destructor. Tears down object.
  }
begin
  fErrors.Free;
  fInFiles.Free;
  if Self = Singleton then
    Singleton := nil;
  inherited;
end;

function TParams.GetError(Idx: Integer): string;
  {Gets an error message from the Errors[] property.
    @param Idx [in] Index into Errors[] property.
    @return error message at given index.
  }
begin
  Result := fErrors[Idx];
end;

function TParams.GetErrorCount: Integer;
  {Gets the number of errors in Errors[] property.
    @return Error count.
  }
begin
  Result := fErrors.Count;
end;

function TParams.GetInFile(Idx: Integer): string;
  {Gets the name of an input file from the InFiles[] property.
    @param Idx [in] Index into InFiles[] property.
    @return Input file name at the given index.
  }
begin
  Result := fInFiles[Idx];
end;

function TParams.GetInFileCount: Integer;
  {Gets the number of input files in InFiles[] property.
    @return File name count.
  }
begin
  Result := fInFiles.Count;
end;


initialization


finalization

// Destroy singleton
Singleton.Free;

end.

