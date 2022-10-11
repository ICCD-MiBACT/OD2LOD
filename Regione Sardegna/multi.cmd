@setlocal
@for %%x in (A300 IIAI3 IOAI1 IOAI2 ISAI3) do @call :transform %%x
@rem call :transform IOAI2
@endlocal
@goto:eof
:transform
@echo @transform %1
@if exist xml\%1.out rmdir /q /s xml\%1.out
@mkdir xml\%1.out
@call saxon xml\%1 multi.xsl -o:xml\%1.out
@if exist xml\%1 rmdir /q /s xml\%1
@move xml\%1.out xml\%1
@goto:eof