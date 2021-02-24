@setlocal
set RDF_FILE=%1
set RDFIZER_LOCATION=%2
set CURRENT_DIR=%cd%
set SOURCE_DIR=%cd%\xml

pushd %RDFIZER_LOCATION%
@echo %cd%

call java -Dfile.encoding=UTF-8 -Xmx2G -jar target/arco.rdfizer.jar "%SOURCE_DIR%" "%CURRENT_DIR%\%RDF_FILE%"

@popd
@endlocal