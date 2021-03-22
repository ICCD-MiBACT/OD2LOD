@setlocal
call python downloader.py
if exist rdfizer\ttls rmdir /q /s rdfizer\ttls
if exist dati-sardegna-tmp rmdir /q /s dati-sardegna-tmp
pushd rdfizer
call java -Dfile.encoding=UTF-8 -jar arco.rdfizer.jar "..\xml" "..\dati-sardegna-tmp" "https://w3id.org/arco/resource/SARDEGNA/" "" "-xslt:..\xtra.xslt"
popd
if exist dati-sardegna.nt del dati-sardegna.nt
call python postprocess.py dati-sardegna-tmp/dati-sardegna-tmp.nt.gz dati-sardegna.nt
if exist dati-sardegna.nt.gz del dati-sardegna.nt.gz
call 7za -tgzip -sdel -y -bsp0 -bso0 a dati-sardegna.nt.gz dati-sardegna.nt
@rem clean temp data
if exist rdfizer\ttls rmdir /q /s rdfizer\ttls
if exist dati-sardegna-tmp rmdir /q /s dati-sardegna-tmp
@rem dir /b dati-sardegna.nt.gz
@CALL :fileinfo dati-sardegna.nt.gz
@endlocal
@goto:eof
:fileinfo
@echo =^> %~nx1 size:%~z1 time:%~t1 ^<=
@goto:eof

