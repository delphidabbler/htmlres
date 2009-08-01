@rem ---------------------------------------------------------------------------
@rem Script used to create zip file containing binary release of HTML Resource
@rem Compiler.
@rem
@rem Copyright (C) Peter Johnson (www.delphidabbler.com), 2008
@rem
@rem v1.0 of 23 Aug 2008 - First version.
@rem ---------------------------------------------------------------------------

@echo off
setlocal
set ZipFile=..\release\dd-htmlres.zip
del %ZipFile%
zip -j -9 %ZipFile% ..\Exe\HTMLRes-Setup-*.exe ..\Docs\ReadMe.txt
endlocal
