@rem ---------------------------------------------------------------------------
@rem Script used to create zip files containing binary and source code releases
@rem of HTML Resource Compiler.
@rem
@rem Copyright (C) Peter Johnson (www.delphidabbler.com), 2008
@rem
@rem v1.0 of 23 Aug 2008 - First version.
@rem ---------------------------------------------------------------------------

@echo off
setlocal

call Tidy.bat
call ReleaseExe.bat
call ReleaseSrc.bat

endlocal
