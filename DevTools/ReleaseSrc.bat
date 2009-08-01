@rem ---------------------------------------------------------------------------
@rem Script used to create zip file containing source code of HTML Resource
@rem Compiler.
@rem
@rem Copyright (C) Peter Johnson (www.delphidabbler.com), 2008
@rem
@rem v1.0 of 21 Aug 2008 - First version.
@rem ---------------------------------------------------------------------------

@echo off

setlocal

cd ..

set OutFile=Release\dd-htmlres-src.zip
del %OutFile%

zip -r -9 %OutFile% Src
zip %OutFile% -d Src\HTMLRes.dsk
zip -r -9 %OutFile% Bin\*.res
zip -j -9 %OutFile% Docs\SourcecodeLicenses.txt
zip -j -9 %OutFile% Docs\ReadMe-Src.txt
zip -j -9 %OutFile% Docs\MPL.txt

endlocal
