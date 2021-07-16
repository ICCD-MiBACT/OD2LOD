@rem uso: %0 ^<input shp^> ^<output gml^>
@rem ogr2ogr binaries https://www.osgeo.org/projects/osgeo4w/
call ogr2ogr -s_srs EPSG:25832 -t_srs EPSG:4326 -f GML -dialect sqlite -sql "select * from %~n1" %2 %1