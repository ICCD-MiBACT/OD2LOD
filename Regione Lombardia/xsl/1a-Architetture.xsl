<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:arco="https://w3id.org/arco/ontology/arco/"
  xmlns:xalan="org.apache.xalan.xslt.extensions.Redirect" extension-element-prefixes="xalan"
  exclude-result-prefixes="fn">
 <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
 <xsl:template match="*">
 <rdf:RDF xml:base="https://w3id.org/arco/resource/"
     xmlns="https://w3id.org/arco/resource/"
     xmlns:dc="http://purl.org/dc/elements/1.1/"
     xmlns:dcterms="http://purl.org/dc/terms/"
     xmlns:owl="http://www.w3.org/2002/07/owl#"
     xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
     xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
     xmlns:foaf="http://xmlns.com/foaf/0.1/"
     xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
     xmlns:cis="http://dati.beniculturali.it/cis/"
     xmlns:l0="https://w3id.org/italia/onto/l0/"
     xmlns:tiapit="https://w3id.org/italia/onto/TI/"
     xmlns:potapit="https://w3id.org/italia/onto/POT/"
     xmlns:cpevapit="https://w3id.org/italia/onto/CPEV/"
     xmlns:cpvapit="https://w3id.org/italia/onto/CPV/"
     xmlns:accessCondition="https://w3id.org/italia/onto/AccessCondition/"
     xmlns:smapit="https://w3id.org/italia/onto/SM/"
     xmlns:roapit="https://w3id.org/italia/onto/RO/"
     xmlns:clvapit="https://w3id.org/italia/onto/CLV/"
	 xmlns:covapit="https://w3id.org/italia/onto/COV/"
	 xmlns:arco="https://w3id.org/arco/ontology/arco/"
	 xmlns:arco-core="https://w3id.org/arco/ontology/core/"
	 xmlns:arco-cd="https://w3id.org/arco/ontology/context-description/"
	 xmlns:cataloguing-campaign="https://w3id.org/arco/ontology/cataloguing-campaign/"
	 >
  
  <xsl:apply-templates select="/root/row" mode="b"/>
 
 </rdf:RDF>
 
 <xsl:apply-templates select="/root/row" mode="a"/>
 </xsl:template>
 
<xsl:template match="/root/row" mode="a">
<xsl:variable name="nomefile"><xsl:value-of select="cell[@name='NUM_SCHEDA_SIRBEC']"/>.xml</xsl:variable>

<xalan:write file="{$nomefile}">

<record>
 <header>
<xsl:element name="identifier">
<xsl:value-of select="cell[@name='NUM_SCHEDA_SIRBEC']"/>
</xsl:element>

<datestamp>2020-05-07T00:00:00Z</datestamp>
 </header>
<metadata>
<schede>
	 
<xsl:element name="A">
<xsl:attribute name="version">3.00</xsl:attribute>
	<xsl:element name="CD">
	<xsl:attribute name="hint">CODICI</xsl:attribute>
		<xsl:element name="TSK">
		<xsl:attribute name="hint">Tipo scheda</xsl:attribute>A</xsl:element>
		<xsl:element name="NCT">
		<xsl:attribute name="hint">CODICE UNIVOCO</xsl:attribute>
			<xsl:element name="NCTR">
			<xsl:attribute name="hint">Codice regione</xsl:attribute>03</xsl:element>
			
		</xsl:element>
		<xsl:element name="ESC">
		<xsl:attribute name="hint">Ente schedatore</xsl:attribute>R03</xsl:element>
		
		<xsl:choose>
			<xsl:when test="cell[@name='PROVINCIA']='MN'">
			<xsl:element name="ECP">
			<xsl:attribute name="hint">Ente competente</xsl:attribute>S23</xsl:element>
			</xsl:when>
			<xsl:when test="cell[@name='PROVINCIA']='BS'">
			<xsl:element name="ECP">
			<xsl:attribute name="hint">Ente competente</xsl:attribute>S23</xsl:element>
			</xsl:when>
			<xsl:when test="cell[@name='PROVINCIA']='CR'">
			<xsl:element name="ECP">
			<xsl:attribute name="hint">Ente competente</xsl:attribute>S23</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="ECP">
				<xsl:attribute name="hint">Ente competente</xsl:attribute>S27</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:element>
	
	<xsl:if test="cell[@name='COMPLESSITA_DEL_BENE']='bene componente'">
		<xsl:element name="RV">
		<xsl:attribute name="hint">RELAZIONI</xsl:attribute>
			<xsl:element name="RVE">
			<xsl:attribute name="hint">STRUTTURA COMPLESSA</xsl:attribute>
				<xsl:element name="RVEL">
				<xsl:attribute name="hint">Livello</xsl:attribute>1</xsl:element> <!-- il livello è sempre 1, perchè nei dati non c'è informazione per mettere un altro numero -->
				<xsl:element name="RVER">
				<xsl:attribute name="hint">Codice bene radice</xsl:attribute><xsl:value-of select="cell[@name='NUM_SCHEDA_BENE_COMPLESSO']"/>/ R03</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:if>
	<xsl:if test="cell[@name='COMPLESSITA_DEL_BENE']='bene complesso'">
		<xsl:element name="RV">
		<xsl:attribute name="hint">RELAZIONI</xsl:attribute>
			<xsl:element name="RVE">
			<xsl:attribute name="hint">STRUTTURA COMPLESSA</xsl:attribute>
				<xsl:element name="RVEL">
				<xsl:attribute name="hint">Livello</xsl:attribute>0</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:if>
	
	<xsl:element name="AC">
	<xsl:attribute name="hint">ALTRI CODICI</xsl:attribute>
		<xsl:element name="ACC">
		<xsl:attribute name="hint">Altro codice bene</xsl:attribute><xsl:value-of select="cell[@name='NUM_SCHEDA_SIRBEC']"/>/ R03</xsl:element>
	</xsl:element>
	
	<xsl:element name="OG">
	<xsl:attribute name="hint">OGGETTO</xsl:attribute>
		<xsl:element name="OGT">
		<xsl:attribute name="hint">OGGETTO</xsl:attribute>
			<xsl:element name="OGTD">
			<xsl:attribute name="hint">Definizione tipologica</xsl:attribute><xsl:value-of select="cell[@name='TIPO_ARCHITETTURA']"/></xsl:element>
			<xsl:element name="OGTN">
			<xsl:attribute name="hint">Denominazione</xsl:attribute><xsl:value-of select="cell[@name='DENOMINAZIONE']"/></xsl:element>
		</xsl:element>
	</xsl:element>

	<xsl:element name="LC">
	<xsl:attribute name="hint">LOCALIZZAZIONE GEOGRAFICO-AMMINISTRATIVA</xsl:attribute>
		<xsl:element name="PVC">
		<xsl:attribute name="hint">LOCALIZZAZIONE GEOGRAFICO-AMMINISTRATIVA</xsl:attribute>
			<xsl:element name="PVCS">
			<xsl:attribute name="hint">Stato</xsl:attribute>ITALIA</xsl:element>
			<xsl:element name="PVCR">
			<xsl:attribute name="hint">Regione</xsl:attribute>Lombardia</xsl:element>
			<xsl:element name="PVCP">
			<xsl:attribute name="hint">Provincia</xsl:attribute><xsl:value-of select="cell[@name='PROVINCIA']"/></xsl:element>
			<xsl:element name="PVCC">
			<xsl:attribute name="hint">Comune</xsl:attribute><xsl:value-of select="cell[@name='COMUNE']"/></xsl:element>
			<xsl:if test="cell[@name='LOCALITA']">
				<xsl:element name="PVCL">
				<xsl:attribute name="hint">Località</xsl:attribute><xsl:value-of select="cell[@name='LOCALITA']"/></xsl:element>
			</xsl:if>
			<xsl:if test="cell[@name='INDIRIZZO']">
				<xsl:element name="PVCI">
				<xsl:attribute name="hint">Indirizzo</xsl:attribute><xsl:value-of select="cell[@name='INDIRIZZO']"/></xsl:element>
			</xsl:if>
			<xsl:if test="cell[@name='UBICAZIONE_NON_VIABILISTICA']">
				<xsl:element name="PVCV">
				<xsl:attribute name="hint">Altre vie di comunicazione</xsl:attribute><xsl:value-of select="cell[@name='UBICAZIONE_NON_VIABILISTICA']"/></xsl:element>
			</xsl:if>
		</xsl:element>
		
		</xsl:element>
		
		<xsl:if test="cell[@name='AUTORI']|cell[@name='STILE_SCUOLA']">
			<xsl:element name="AU">
			<xsl:attribute name="hint">DEFINIZIONE CULTURALE</xsl:attribute>
			
			<xsl:apply-templates select="cell[@name='AUTORI']"/>
			<xsl:apply-templates select="cell[@name='STILE_SCUOLA']"/>

			</xsl:element>
		</xsl:if>

		<xsl:if test="cell[@name='DATAZIONE']">
			
			<xsl:apply-templates select="cell[@name='DATAZIONE']"/>

		</xsl:if>

		<xsl:if test="cell[@name='STATO_CONSERV']">
			<xsl:element name="CO">
			<xsl:attribute name="hint">CONSERVAZIONE</xsl:attribute>
			
			<xsl:apply-templates select="cell[@name='STATO_CONSERV']"/>

			</xsl:element>
		</xsl:if>

		<xsl:if test="cell[@name='USO_ATTUALE']|cell[@name='USO_STORICO']">
			<xsl:element name="US">
			<xsl:attribute name="hint">UTILIZZAZIONI</xsl:attribute>
			
			<xsl:apply-templates select="cell[@name='USO_ATTUALE']"/>
			<xsl:apply-templates select="cell[@name='USO_STORICO']"/>

			</xsl:element>
		</xsl:if>

</xsl:element>

<xsl:apply-templates select="cell[@name='lat']"/>

  </schede>
					
</metadata>
</record>

</xalan:write>
 
 
 
</xsl:template>

<xsl:template match="cell[@name='lat']">
<xsl:element name="harvesting">
	<xsl:element name="geocoding">
		<xsl:element name="x"><xsl:value-of select="."/></xsl:element>		
		<xsl:element name="y"><xsl:value-of select="../cell[@name='lng']"/></xsl:element>
	</xsl:element>
</xsl:element>
</xsl:template>

<xsl:template match="cell[@name='DATAZIONE']">
<xsl:variable name="translateIdFrom">sec.</xsl:variable>
<xsl:variable name="translateIdTo"  >    </xsl:variable>
<xsl:variable name="dataCompleto" select="substring-before(.,'(')"/>
<xsl:variable name="dataREM" select="substring-before(.,'-')"/>
<xsl:variable name="dataREC" select="substring-before(substring-after(.,'-'),'(')"/>
<xsl:variable name="dataREMtr" select="translate($dataREM,$translateIdFrom,$translateIdTo)"/>
<xsl:variable name="dataRECtr" select="translate($dataREC,$translateIdFrom,$translateIdTo)"/>
<xsl:variable name="dataCompletotr" select="translate($dataCompleto,$translateIdFrom,$translateIdTo)"/>


	<xsl:element name="RE">
	<xsl:attribute name="hint">NOTIZIE STORICHE</xsl:attribute>
	<!--
	<xsl:element name="dataCompleto"><xsl:value-of select="$dataCompleto"/></xsl:element>
	<xsl:element name="dataREM"><xsl:value-of select="$dataREM"/></xsl:element>
	<xsl:element name="dataREC"><xsl:value-of select="$dataREC"/></xsl:element>
	<xsl:element name="dataRECtr"><xsl:value-of select="$dataRECtr"/></xsl:element>
	-->
		<xsl:element name="REN">
		<xsl:attribute name="hint">NOTIZIA</xsl:attribute>
			<xsl:element name="RENR">
			<xsl:attribute name="hint">Riferimento</xsl:attribute>
			<xsl:value-of select="substring-before(substring-after(.,'('),':')"/>
			</xsl:element>
			<xsl:element name="RENS">
			<xsl:attribute name="hint">Notizia sintetica</xsl:attribute>
			<xsl:value-of select="normalize-space(substring-before(substring-after(.,':'),')'))"/>
			</xsl:element>
		</xsl:element>
		
		<xsl:choose>
			<xsl:when test="contains(.,'-')">
			<xsl:element name="REL">
			<xsl:attribute name="hint">CRONOLOGIA, ESTREMO REMOTO</xsl:attribute>
				<xsl:choose>
					<xsl:when test="contains($dataREM,'sec')"> 
						<xsl:element name="RELS">
						<xsl:attribute name="hint">Secolo</xsl:attribute>
							<xsl:value-of select="normalize-space($dataREMtr)"/>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="RELI">
						<xsl:attribute name="hint">Data</xsl:attribute>
							<xsl:value-of select="normalize-space($dataREM)"/>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<xsl:element name="REV">
			<xsl:attribute name="hint">CRONOLOGIA, ESTREMO RECENTE</xsl:attribute>
				<xsl:choose>
					<xsl:when test="contains($dataREC,'sec')"> 
						<xsl:element name="REVS">
						<xsl:attribute name="hint">Secolo</xsl:attribute>
							<xsl:value-of select="normalize-space($dataRECtr)"/>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="REVI">
						<xsl:attribute name="hint">Data</xsl:attribute>
							<xsl:value-of select="normalize-space($dataREC)"/>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="REL">
				<xsl:attribute name="hint">CRONOLOGIA, ESTREMO REMOTO</xsl:attribute>
					<xsl:choose>
					<xsl:when test="contains($dataCompleto,'sec')"> 
						<xsl:element name="RELS">
						<xsl:attribute name="hint">Secolo</xsl:attribute>
							<xsl:value-of select="normalize-space($dataCompletotr)"/>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="REVI">
						<xsl:attribute name="hint">Data</xsl:attribute>
							<xsl:value-of select="normalize-space($dataCompleto)"/> 
					<!-- Nel caso in cui anziché la data completa sia noto solo l'anno, i mesi e/o i giorni vanno indicati con due zeri. -->
					
						</xsl:element>
					</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
				<xsl:element name="REV">
				<xsl:attribute name="hint">CRONOLOGIA, ESTREMO RECENTE</xsl:attribute>
					<xsl:choose>
					<xsl:when test="contains($dataCompleto,'sec')"> 
						<xsl:element name="REVS">
						<xsl:attribute name="hint">Secolo</xsl:attribute>
							<xsl:value-of select="normalize-space($dataCompletotr)"/>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="REVI">
						<xsl:attribute name="hint">Data</xsl:attribute>
							<xsl:value-of select="normalize-space($dataCompleto)"/>
						</xsl:element>
					</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:element>
</xsl:template>

<xsl:template match="cell[@name='AUTORI']">	
	<xsl:element name="AUT">
	<xsl:attribute name="hint">AUTORE</xsl:attribute>
		<xsl:element name="AUTR">
		<xsl:attribute name="hint">Riferimento all'intervento (ruolo)</xsl:attribute>
		<xsl:value-of select="substring-before(substring-after(.,'('),')')"/>
		</xsl:element>
		<xsl:element name="AUTN">
		<xsl:attribute name="hint">Nome scelto</xsl:attribute>
		<xsl:value-of select="normalize-space(substring-before(.,'('))"/>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="cell[@name='STILE_SCUOLA']">
	<xsl:element name="ATB">
	<xsl:attribute name="hint">AMBITO CULTURALE</xsl:attribute>
		<xsl:element name="ATBR">
		<xsl:attribute name="hint">Riferimento all'intervento</xsl:attribute>
		<xsl:value-of select="substring-before(substring-after(.,'('),')')"/>
		</xsl:element>
		<xsl:element name="ATBD">
		<xsl:attribute name="hint">Denominazione</xsl:attribute>
		<xsl:value-of select="normalize-space(substring-before(.,'('))"/>
		</xsl:element>
	</xsl:element>
</xsl:template>
		
		<!--	2005/10/01 strutture verticali: buono -->
		<xsl:template match="cell[@name='STATO_CONSERV']">
			<xsl:element name="STC">
			<xsl:attribute name="hint">STATO DI CONSERVAZIONE</xsl:attribute>
				<xsl:element name="STCR">
				<xsl:attribute name="hint">Riferimento alla parte</xsl:attribute>
				<xsl:value-of select="substring-before(substring-after(.,' '),':')"/>
				</xsl:element>
				<xsl:element name="STCC">
				<xsl:attribute name="hint">Stato di conservazione</xsl:attribute>
				<xsl:value-of select="normalize-space(substring-after(.,':'))"/>
				</xsl:element>
				<xsl:element name="STCO">
				<xsl:attribute name="hint">Indicazioni specifiche</xsl:attribute>
				<xsl:value-of select="substring-before(.,' ')"/>
				</xsl:element>
			
			</xsl:element>
		</xsl:template>
	
	<xsl:template match="cell[@name='USO_ATTUALE']">
	<xsl:element name="USA">
	<xsl:attribute name="hint">USO ATTUALE</xsl:attribute>
		<xsl:choose>
			<xsl:when test="contains(.,':')">
				<xsl:element name="USAR">
				<xsl:attribute name="hint">Riferimento alla parte</xsl:attribute>
				<xsl:value-of select="substring-before(.,':')"/>
				</xsl:element>
				<xsl:element name="USAD">
				<xsl:attribute name="hint">Uso</xsl:attribute>
				<xsl:value-of select="normalize-space(substring-after(.,':'))"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="USAD">
				<xsl:attribute name="hint">Uso</xsl:attribute>
				<xsl:value-of select="."/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:element>
	</xsl:template>
	
	<xsl:template match="cell[@name='USO_STORICO']">
		<xsl:element name="USO">
		<xsl:attribute name="hint">USO STORICO</xsl:attribute>
			<xsl:choose>
			<xsl:when test="contains(.,'-')">
				<xsl:choose>
				<xsl:when test="contains(.,':')">
				<xsl:element name="USOR">
				<xsl:attribute name="hint">Riferimento alla parte</xsl:attribute>
					<xsl:value-of select="normalize-space(substring-before(.,'-'))"/>
				</xsl:element>
				<xsl:element name="USOC">
				<xsl:attribute name="hint">Riferimento cronologico</xsl:attribute>
					<xsl:value-of select="normalize-space(substring-before(substring-after(.,'-'),':'))"/>
				</xsl:element>
				<xsl:element name="USOD">
				<xsl:attribute name="hint">Uso</xsl:attribute>
					<xsl:value-of select="normalize-space(substring-after(.,':'))"/>
				</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="USOR">
					<xsl:attribute name="hint">Riferimento alla parte</xsl:attribute>
					<xsl:value-of select="normalize-space(substring-before(.,'-'))"/>
					</xsl:element>
					<xsl:element name="USOC">
					<xsl:attribute name="hint">Riferimento cronologico</xsl:attribute>
					<xsl:value-of select="normalize-space(substring-after(.,'-'))"/>
					</xsl:element>
				</xsl:otherwise>
				</xsl:choose>
				</xsl:when>
			<xsl:otherwise>
				<xsl:element name="USOC">
				<xsl:attribute name="hint">Riferimento cronologico</xsl:attribute>
					<xsl:value-of select="normalize-space(substring-before(.,':'))"/>
			</xsl:element>
			<xsl:element name="USOD">
			<xsl:attribute name="hint">Uso</xsl:attribute>
				<xsl:value-of select="normalize-space(substring-after(.,':'))"/>
			</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
		</xsl:element>
	</xsl:template>
		<!-- 	
intero bene - uso storico (XIV): difensivo
uso storico (XIV): difensivo
intero bene - destinazione originaria
	-->
		
<xsl:template match="/root/row" mode="b">
	<xsl:element name="rdf:Description">
	<xsl:attribute name="rdf:about">ArchitecturalOrLandscapeHeritage/<xsl:value-of select="cell[@name='NUM_SCHEDA_SIRBEC']"/>/ R03</xsl:attribute>
		<xsl:element name="dc:source">
		<xsl:attribute name="rdf:resource">http://www.lombardiabeniculturali.it/architetture/schede/<xsl:value-of select="cell[@name='NUM_SCHEDA_SIRBEC']"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="dc:source">
		<xsl:attribute name="rdf:resource">http://www.lombardiabeniculturali.it/architetture/schede-complete/<xsl:value-of select="cell[@name='NUM_SCHEDA_SIRBEC']"/></xsl:attribute>
		</xsl:element>
		
		<xsl:if test="cell[@name='COMPLESSITA_DEL_BENE']='bene componente'">
			<xsl:element name="arco:isCulturalPropertyComponentOf">
			<xsl:attribute name="rdf:resource">ArchitecturalOrLandscapeHeritage/<xsl:value-of select="cell[@name='NUM_SCHEDA_BENE_COMPLESSO']"/>/ R03</xsl:attribute>
			</xsl:element>
		</xsl:if>
	</xsl:element>
	
	
	
	<!--<xsl:if test="cell[@name='COMPLESSITA_DEL_BENE']='bene componente'">
		<xsl:element name="rdf:Description">
		<xsl:attribute name="rdf:about">ArchitecturalOrLandscapeHeritage/<xsl:value-of select="cell[@name='NUM_SCHEDA_SIRBEC']"/>/ R03</xsl:attribute>
			<xsl:element name="dcterms:isPartOf">
			<xsl:attribute name="rdf:resource">ArchitecturalOrLandscapeHeritage/<xsl:value-of select="cell[@name='NUM_SCHEDA_BENE_COMPLESSO']"/>/ R03</xsl:attribute>
			</xsl:element>
		</xsl:element>
	</xsl:if>-->
</xsl:template>

</xsl:stylesheet>