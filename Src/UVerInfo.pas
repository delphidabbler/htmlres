{
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at http://mozilla.org/MPL/2.0/
 *
 * Copyright (C) 2008-2021, Peter Johnson (gravatar.com/delphidabbler).
 *
 * Provides routines that can return information from the program's version
 * information.
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
