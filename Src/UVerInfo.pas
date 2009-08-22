{
 * UVerInfo.pas
 *
 * Provides routines that can return information from the program's version
 * information.
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
 * The Original Code is UVerInfo.pas.
 *
 * The Initial Developer of the Original Code is Peter Johnson
 * (http://www.delphidabbler.com/).
 *
 * Portions created by the Initial Developer are Copyright (C) 2008-2009 Peter
 * Johnson. All Rights Reserved.
 *
 *
 * Contributor(s):
 *   NONE
 *
 * ***** END LICENSE BLOCK *****
}


unit UVerInfo;


interface


function GetProductVersionStr: string;
  {Get program's product version number from version information resource.
    @return Version number as a dotted quad.
  }

function GetCopyrightStr: string;
  {Gets program's copyright information from version informationr resource.
    @return Required copyright information.
  }


implementation


uses
  // Delphi
  SysUtils,
  // DelphiDabbler component
  PJVersionInfo;


function GetProductVersionStr: string;
  {Get program's product version number from version information resource.
    @return Version number as a dotted quad.
  }
begin
  with TPJVersionInfo.Create(nil) do
    try
      Result := Format(
        '%d.%d.%d',
        [
          ProductVersionNumber.V1,
          ProductVersionNumber.V2,
          ProductVersionNumber.V3
        ]
      );
    finally
      Free;
    end;
end;

function GetCopyrightStr: string;
  {Gets program's copyright information from version informationr resource.
    @return Required copyright information.
  }
begin
  with TPJVersionInfo.Create(nil) do
    try
      Result := LegalCopyright;
    finally
      Free;
    end;
end;

end.
