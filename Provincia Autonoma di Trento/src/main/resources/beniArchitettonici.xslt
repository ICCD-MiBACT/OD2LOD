<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  exclude-result-prefixes="fn">
  
 <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
 <xsl:param name="datestamp" select="'2021-06-24T00:00:00Z'"/>
  
 <xsl:template match="*">
  <xsl:apply-templates select="*"/>
 </xsl:template>
 
 <xsl:template match="*[local-name()='SELECT']">
  <xsl:variable name="punto" select="*[local-name()='GEOMETRY']/*/*"/>
  <record>
   <header>
    <xsl:element name="identifier">
     <xsl:value-of select="*[local-name()='classid']"/>
    </xsl:element>
    <datestamp><xsl:value-of select="$datestamp"/></datestamp>
   </header>
   <metadata>
    <schede>
     <xsl:element name="{*[local-name()='tsk_cod']}">
      <xsl:attribute name="version">3.00</xsl:attribute>
      <xsl:element name="CD">
       <xsl:attribute name="hint">CODICI</xsl:attribute>
       <xsl:element name="TSK">
        <xsl:attribute name="hint">Tipo scheda</xsl:attribute><xsl:value-of select="*[local-name()='tsk_cod']"/></xsl:element>
       <xsl:element name="NCT">
        <xsl:attribute name="hint">CODICE UNIVOCO</xsl:attribute>
        <xsl:element name="NCTR">
         <xsl:attribute name="hint">Codice regione</xsl:attribute>04</xsl:element>
       </xsl:element>
       <xsl:element name="ESC">
        <xsl:attribute name="hint">Ente schedatore</xsl:attribute>S222</xsl:element> <!-- provare se rdfizer accetta valore https://w3id.org/arco/resource/Agent/3ef9e38e8e7b2efad522334071919911 -->
       <xsl:element name="ECP">
        <xsl:attribute name="hint">Ente competente</xsl:attribute>S222</xsl:element>
      </xsl:element>
      
      <xsl:element name="AC">
       <xsl:attribute name="hint">ALTRI CODICI</xsl:attribute>
       <xsl:element name="ACC">
        <xsl:attribute name="hint">Altro codice bene</xsl:attribute><xsl:value-of select="*[local-name()='classid']"/>/ S222</xsl:element>
      </xsl:element>
  
      <xsl:element name="OG">
       <xsl:attribute name="hint">OGGETTO</xsl:attribute>
       <xsl:element name="OGT">
        <xsl:attribute name="hint">OGGETTO</xsl:attribute>
        <xsl:element name="OGTD">
         <xsl:attribute name="hint">Definizione tipologica</xsl:attribute><xsl:value-of select="*[local-name()='tp_ogt']"/></xsl:element>
        <xsl:element name="OGTN">
         <xsl:attribute name="hint">Denominazione</xsl:attribute><xsl:value-of select="*[local-name()='denom_bene']"/></xsl:element>
       </xsl:element>
      </xsl:element>

      <xsl:element name="LC">
       <xsl:attribute name="hint">LOCALIZZAZIONE GEOGRAFICO-AMMINISTRATIVA</xsl:attribute>
       <xsl:element name="PVC">
        <xsl:attribute name="hint">LOCALIZZAZIONE GEOGRAFICO-AMMINISTRATIVA</xsl:attribute>
        <xsl:element name="PVCS">
         <xsl:attribute name="hint">Stato</xsl:attribute>Italia</xsl:element>
        <xsl:element name="PVCR">
         <xsl:attribute name="hint">Regione</xsl:attribute>Trentino - Alto Adige</xsl:element>
        <xsl:element name="PVCP">
         <xsl:attribute name="hint">Provincia</xsl:attribute>TN</xsl:element>
        <xsl:element name="PVCC">
         <xsl:attribute name="hint">Comune</xsl:attribute><xsl:value-of select="*[local-name()='com_amm']"/></xsl:element>
        <xsl:if test="*[local-name()='loc_amm'][normalize-space()!=''][.!='None']">
         <xsl:element name="PVCL">
          <xsl:attribute name="hint">Località</xsl:attribute><xsl:value-of select="*[local-name()='loc_amm']"/></xsl:element>
        </xsl:if>
        <xsl:if test="*[local-name()='fraz_amm'][normalize-space()!=''][.!='None']">
         <xsl:element name="PVCE">
          <xsl:attribute name="hint">Altra ripartizione amministrativa o località estera</xsl:attribute><xsl:value-of select="*[local-name()='fraz_amm']"/></xsl:element>
        </xsl:if>
        <xsl:if test="*[local-name()='via_no'][normalize-space()!=''][.!='None'][.!='-']">
         <xsl:element name="PVCI">
          <xsl:attribute name="hint">Indirizzo</xsl:attribute><xsl:value-of select="*[local-name()='via_no']"/></xsl:element>
        </xsl:if>
       </xsl:element>
       <xsl:if test="*[local-name()='altra_loc'][normalize-space()!=''][.!='None'][.!='-']">
        <xsl:element name="PVL">
         <xsl:attribute name="hint">Altra località</xsl:attribute><xsl:value-of select="*[local-name()='altra_loc']"/></xsl:element>
       </xsl:if>
       <xsl:element name="PVL">
        <xsl:attribute name="hint">Altra località</xsl:attribute><xsl:value-of select="*[local-name()='cdv']"/></xsl:element>
      </xsl:element>
       
      <xsl:element name="TU">
       <xsl:attribute name="hint">CONDIZIONE GIURIDICA E VINCOLI</xsl:attribute>
       <xsl:if test="*[local-name()='cond_giuri'][normalize-space()!=''][.!='None']">
        <xsl:element name="CDG">
         <xsl:attribute name="hint">CONDIZIONE GIURIDICA</xsl:attribute>
         <xsl:element name="CDGG">
          <xsl:attribute name="hint">Indicazione generica</xsl:attribute>proprietà <xsl:value-of select="*[local-name()='cond_giuri']"/></xsl:element>
        </xsl:element>
       </xsl:if>
       <xsl:element name="NVC">
        <xsl:attribute name="hint">PROVVEDIMENTI DI TUTELA</xsl:attribute>
         <xsl:element name="NVCT">
          <xsl:attribute name="hint">Tipo provvedimento</xsl:attribute><xsl:value-of select="*[local-name()='int_cult']"/></xsl:element>
       </xsl:element>
      </xsl:element>
      
      <xsl:element name="GP">
       <xsl:attribute name="hint">GEOREFERENZIAZIONE TRAMITE PUNTO</xsl:attribute>
       <xsl:element name="GPL">
        <xsl:attribute name="hint">Tipo di localizzazione</xsl:attribute>localizzazione fisica</xsl:element>
       <xsl:element name="GPD">
        <xsl:attribute name="hint">DESCRIZIONE DEL PUNTO</xsl:attribute>
        <xsl:element name="GPDP">
         <xsl:attribute name="hint">PUNTO</xsl:attribute>
         <xsl:element name="GPDPX">
          <xsl:attribute name="hint">Coordinata X</xsl:attribute>
          <xsl:value-of select="substring-before($punto,',')"/>
         </xsl:element>
         <xsl:element name="GPDPY">
          <xsl:attribute name="hint">Coordinata Y</xsl:attribute>
          <xsl:value-of select="substring-after($punto,',')"/>
         </xsl:element>
        </xsl:element>
       </xsl:element>
      </xsl:element>
      
      <xsl:element name="CM">
       <xsl:attribute name="hint">COMPILAZIONE</xsl:attribute>
       <xsl:element name="AGG">
        <xsl:attribute name="hint">AGGIORNAMENTO - REVISIONE</xsl:attribute>
        <xsl:element name="AGGD">
         <xsl:attribute name="hint">Data</xsl:attribute>
         <xsl:value-of select="substring(*[local-name()='dataagg'],1,4)"/></xsl:element>
       </xsl:element>
      </xsl:element>
       
     </xsl:element>
     <xsl:variable name="idb" select="*[local-name()='id_bene']"/><!-- 404 -->   
     <xsl:if test="string-length(normalize-space($idb)) and not(contains(' 7242 5716 3698 6055 6174 6159 8790 10677 7492 7212 5638 6491 ',concat(' ',$idb,' ')))">
      <xsl:element name="harvesting">
       <xsl:element name="media">
        <xsl:value-of select="concat('https://webgis.provincia.tn.it/wgt/services/static/immagini/sbc/bea/',$idb,'/',$idb,'.jpg')"/>
       </xsl:element>
      </xsl:element>
     </xsl:if>
    </schede>
  </metadata>
  </record>
 </xsl:template>

</xsl:stylesheet>
