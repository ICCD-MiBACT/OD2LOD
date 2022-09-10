@setlocal
@for %%x in (A300 IIAI3 IOAI1 IOAI2 ISAI3) do @call :transform %%x
@endlocal
@goto:eof
:transform
@echo @transform %1
@rem *** extremely slow, optimize w junk xtransformer
@for /f "usebackq delims=|" %%f in (`dir /b "xml\%1\*.xml" ^| findstr /i %1`) do @call saxon xml\%1\%%f multi.xsl -o:xml\%1\%%f
@goto:eof