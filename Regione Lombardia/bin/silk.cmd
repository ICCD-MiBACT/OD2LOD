@if "%1" == "" goto uso
@if not "%2" == "" goto uso
call java -DconfigFile=%1 -jar "../bin/lib/Silk SingleMachine-assembly-2.7.1-patch.jar"
@goto fine
:uso 
@echo uso: %0 ^<Silk-LSL file^>
:fine