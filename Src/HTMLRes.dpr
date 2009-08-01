{
 * HTMLRes.dpr
 *
 * Project file for HTML Resource Compiler.
 *
 * v1.0 of 26 Jun 2004  - Original version.
 * v1.1 of 18 Sep 2004  - Removed UResourceFile and UResourceUtils units.
 * v1.2 of 29 May 2006  - Updated commenting.
 * v1.3 of 21 Aug 2008  - Added new UVerInfo unit.
 *
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
 * The Original Code is HTMLRes.dpr.
 *
 * The Initial Developer of the Original Code is Peter Johnson
 * (http://www.delphidabbler.com/).
 *
 * Portions created by the Initial Developer are Copyright (C) 2004-2008 Peter
 * Johnson. All Rights Reserved.
 *
 * ***** END LICENSE BLOCK *****
}


program HTMLRes;


{$APPTYPE CONSOLE}          // this is a console application

{$RESOURCE VHTMLRes.res}    // version information


uses
  UErrors in 'UErrors.pas',
  UMain in 'UMain.pas',
  UParams in 'UParams.pas',
  UVerInfo in 'UVerInfo.pas';

begin
  // TMain provides main functionality and swallows any exceptions
  with TMain.Create do
    try
      Execute;
    finally
      Free;
    end;
end.

