
@call ..\bin\transform -IN intermediate\Architetture.csv2.xml -XSL xsl\1a-Architetture.xsl -OUT outArchitetture\relazioni.rdf

@call ..\bin\transform -IN intermediate\Reperti_Archeologici_conservati_nei_Musei.csv2.xml -XSL xsl\1b-Archeologia.xsl -OUT outArcheologia\trash.txt

@call ..\bin\transform -IN intermediate\Opere_d_Arte_conservate_nei_Musei.csv2.xml -XSL xsl\1c-Opere.xsl -OUT outOpere\trash.txt

@del /Q outArcheologia\trash.txt
@del /Q outOpere\trash.txt

@goto fine
:fine
