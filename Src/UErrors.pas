{
 * UErrors.pas
 *
 * Implements a custom exception class that incorporates an error code number
 * that HTMLRes uses as its exit code. Defines error code constants.
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
 * The Original Code is UErrors.pas.
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


unit UErrors;


interface


uses
  // Delphi
  SysUtils;


const
  // Error codes used in EError exceptions.
  cErrCommandLine       = 1;    // command line error
  cErrMissingManifest   = 2;    // expected manifest file doesn't exist
  cErrMissingSourceFile = 3;    // >=1 source files missing
  cErrDuplicateResource = 4;    // >=1 duplicate file (resource) names
  cErrOutFileExists     = 5;    // output file exists (and can't be modified)
  cErrBadOutFile        = 6;    // output file is not a valid resource file
  cErrResourceExists    = 7;    // named resource already exists in res file
  cErrUnexpected        = 255;  // unexpected error


type

  {
  EError:
    Exception class with associated error code that is used as program exit
    code.
  }
  EError = class(Exception)
  private
    fErrorCode: Integer;
      {Error code associated with the extension}
  public
    constructor Create(const Msg: string; const ErrCode: Integer);
      {Creates EError exception object containing message and associated error
      code.
        @param Msg [in] Error message.
        @param ErrCode [in] Error code of the exception.
      }
    constructor CreateFmt(const Fmt: string; const Args: array of const;
      const ErrCode: Integer);
      {Creates EError exception object containing message created from a format
      string and associated error code.
        @param Fmt [in] Message format string.
        @param Args [in] Arguments that replace placeholders in format string.
        @param ErrCode [in] Error code of the exception.
      }
    property ErrorCode: Integer read fErrorCode;
      {Error code associated with exception}
  end;


implementation


{ EError }

constructor EError.Create(const Msg: string; const ErrCode: Integer);
  {Creates EError exception object containing message and associated error code.
    @param Msg [in] Error message.
    @param ErrCode [in] Error code of the exception.
  }
begin
  inherited Create(Msg);
  fErrorCode := ErrCode;
end;

constructor EError.CreateFmt(const Fmt: string; const Args: array of const;
  const ErrCode: Integer);
  {Creates EError exception object containing message created from a format
  string and associated error code.
    @param Fmt [in] Message format string.
    @param Args [in] Arguments that replace placeholders in format string.
    @param ErrCode [in] Error code of the exception.
  }
begin
  Create(Format(Fmt, Args), ErrCode);
end;

end.

