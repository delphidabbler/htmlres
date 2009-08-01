@rem ---------------------------------------------------------------------------
@rem Script used to build HTML Resource Compiler.
@rem
@rem Copyright (C) Peter Johnson (www.delphidabbler.com), 2008
@rem
@rem v1.0 of 23 Aug 2008 - Original version.
@rem ---------------------------------------------------------------------------

@echo off

setlocal

rem First build binary resource files
call BuildResources.bat

rem Next build pascal files (requires resource file to exist)
call BuildPascal.bat

rem Then build setup program (requires .exe file to exist)
call BuildSetup.bat

endlocal
