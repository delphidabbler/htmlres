@rem ---------------------------------------------------------------------------
@rem Script used to delete temp and backup files for HTML Resource Compiler
@rem source code and documentation.
@rem
@rem Copyright (C) Peter Johnson (www.delphidabbler.com), 2008
@rem
@rem v1.0 of 21 Aug 2008 - Original version.
@rem ---------------------------------------------------------------------------

@echo off

setlocal

set SrcDir=..\Src
set DocsDir=..\Docs

echo Deleting *.~* from "%SrcDir%" and subfolders
del /S %SrcDir%\*.~* 
echo.

echo Deleting *.~* from "%DocsDir%" and subfolders
del /S %DocsDir%\*.~*
echo.

echo Done

endlocal
