{
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at http://mozilla.org/MPL/2.0/
 *
 * Copyright (C) 2004-2021, Peter Johnson (gravatar.com/delphidabbler).
 *
 * Project file for HTML Resource Compiler.
}


program HTMLRes;


{$APPTYPE CONSOLE}          // this is a console application

{$RESOURCE VHTMLRes.res}    // version information


uses
  UErrors in 'UErrors.pas',
  UMain in 'UMain.pas',
  UParams in 'UParams.pas',
  UVerInfo in 'UVerInfo.pas',
  PJResFile in 'Vendor\PJResFile.pas',
  PJVersionInfo in 'Vendor\PJVersionInfo.pas';

begin
  // TMain provides main functionality and swallows any exceptions
  with TMain.Create do
    try
      Execute;
    finally
      Free;
    end;
end.

