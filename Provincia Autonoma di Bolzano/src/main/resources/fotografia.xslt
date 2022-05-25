<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  exclude-result-prefixes="fn">
 <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

 <xsl:param name="datestamp" select="'2022-03-11T00:00:00Z'"/>  
 <xsl:param name="xsltBase" select="''"/>
 <xsl:param name="dataset" select="''"/>
 <xsl:variable name="comuniBZ" select="document(concat($xsltBase,'comuniBZ.xml'))"/>

 <xsl:template match="/">
  <xsl:apply-templates/>
 </xsl:template>
 
 <xsl:template match="row">
<record>
 <header>
  <xsl:element name="identifier">
   <xsl:value-of select="cell[@name='priref']"/>
  </xsl:element>
  <!--
  <datestamp><xsl:value-of select="cell[@name='modification']"/></datestamp>
  -->
  <datestamp><xsl:value-of select="$datestamp"/></datestamp>
 </header>
 <metadata>
  <schede>

<xsl:variable name="OB_it" select="normalize-space(cell[@name='OB_it'])"/>
<xsl:variable name="lc_OB_it" select="lower-case($OB_it)"/> 
<xsl:choose>
	<xsl:when test="$dataset='fotografie storiche' or
                 $lc_OB_it='fotografia' or 
                 $lc_OB_it='cartolina illustrata' or 
                 $lc_OB_it='diapositiva' or 
                 $lc_OB_it='diapositive' or 
                 $lc_OB_it='cartolina postale' or 
                 $lc_OB_it='stereofotografie' or 
                 $lc_OB_it='album' or 
                 $lc_OB_it='negativo'">
<!--	<xsl:when test="contains(cell[@name='OB_it'],'fotografia')">-->
   <xsl:element name="F">
    <xsl:attribute name="version">4.00</xsl:attribute>
    <xsl:element name="CD">
     <xsl:attribute name="hint">CODICI</xsl:attribute>
     <xsl:element name="TSK">
      <xsl:attribute name="hint">Tipo scheda</xsl:attribute>F</xsl:element>
     <xsl:element name="NCT">
      <xsl:attribute name="hint">CODICE UNIVOCO</xsl:attribute>
      <xsl:element name="NCTR">
       <xsl:attribute name="hint">Codice regione</xsl:attribute>04</xsl:element>
     </xsl:element>
     <xsl:element name="ESC">
      <xsl:attribute name="hint">Ente schedatore</xsl:attribute>P021</xsl:element>
      <xsl:element name="ECP">
       <xsl:attribute name="hint">Ente competente</xsl:attribute>P021</xsl:element>
    </xsl:element>
   
    <xsl:element name="OG">
     <xsl:attribute name="hint">BENE CULTURALE</xsl:attribute>
     <xsl:element name="OGT">
      <xsl:attribute name="hint">DEFINIZIONE BENE</xsl:attribute>
      <xsl:element name="OGTD">
      <xsl:attribute name="hint">Definizione</xsl:attribute>Positivo</xsl:element>
     </xsl:element>
    </xsl:element>
    
    <xsl:element name="AC">                  <!-- CI SONO 2 ACCC. PROBLEMA PER rdfizer? -->
     <xsl:attribute name="hint">ALTRI CODICI</xsl:attribute>
     <xsl:element name="ACC">
      <xsl:attribute name="hint">CODICE SCHEDA - ALTRI ENTI</xsl:attribute>
      <xsl:element name="ACCE">
       <xsl:attribute name="hint">Ente/soggetto responsabile</xsl:attribute>Provincia autonoma di Bolzano</xsl:element>
      <xsl:element name="ACCC">
       <xsl:attribute name="hint">Codice identificativo</xsl:attribute><xsl:value-of select="cell[@name='priref']"/></xsl:element>
     </xsl:element>
     <xsl:element name="ACC">
      <xsl:attribute name="hint">CODICE SCHEDA - ALTRI ENTI</xsl:attribute>
      <xsl:element name="ACCE">
       <xsl:attribute name="hint">Ente/soggetto responsabile</xsl:attribute>Provincia autonoma di Bolzano</xsl:element>
      <xsl:element name="ACCC">
       <xsl:attribute name="hint">Codice identificativo</xsl:attribute><xsl:value-of select="cell[@name='IN']"/></xsl:element>
     </xsl:element>
    </xsl:element>
    
    <xsl:element name="LC">
     <xsl:attribute name="hint">LOCALIZZAZIONE GEOGRAFICO-AMMINISTRATIVA</xsl:attribute>
     <xsl:element name="PVC">
      <xsl:attribute name="hint">LOCALIZZAZIONE</xsl:attribute>
      <xsl:element name="PVCS">
       <xsl:attribute name="hint">Stato</xsl:attribute>Italia</xsl:element>
      <xsl:element name="PVCR">
       <xsl:attribute name="hint">Regione</xsl:attribute>Trentino-Alto Adige</xsl:element>
      <xsl:element name="PVCP">
       <xsl:attribute name="hint">Provincia</xsl:attribute>BZ</xsl:element>
      
      <xsl:for-each select="cell[@name='CP_it_syn'][normalize-space()=$comuniBZ//comune][1]">
       <xsl:element name="PVCC">
        <xsl:attribute name="hint">Comune</xsl:attribute><xsl:value-of select="normalize-space()"/></xsl:element>
      </xsl:for-each>
       
     </xsl:element>
    </xsl:element>
    
    <xsl:element name="UB">
     <xsl:attribute name="hint">DATI PATRIMONIALI/INVENTARI/STIME/COLLEZIONI</xsl:attribute>
     <xsl:element name="UBF">
      <xsl:attribute name="hint">UBICAZIONE BENE</xsl:attribute>
      <xsl:element name="UBFP">
       <xsl:attribute name="hint">Fondo</xsl:attribute><xsl:value-of select="cell[@name='CL_it']"/></xsl:element>
     </xsl:element>
    </xsl:element>
    
    <xsl:element name="AU">
     <xsl:attribute name="hint">DEFINIZIONE CULTURALE</xsl:attribute>
     <xsl:element name="AUT">
      <xsl:attribute name="hint">AUTORE/RESPONSABILITA'</xsl:attribute>
      <xsl:element name="AUTN">
       <xsl:attribute name="hint">Nome di persona o ente</xsl:attribute><xsl:value-of select="cell[@name='VV_it']"/></xsl:element>
      <xsl:choose>
       <xsl:when test="contains(cell[@name='VV_it'],',')">
        <xsl:element name="AUTP">
         <xsl:attribute name="hint">Tipo intestazione</xsl:attribute>P</xsl:element>
       </xsl:when>
       <xsl:otherwise>
        <xsl:element name="AUTP">
         <xsl:attribute name="hint">Tipo intestazione</xsl:attribute>E</xsl:element>
       </xsl:otherwise>
      </xsl:choose>
     </xsl:element>
    </xsl:element>
    
    <xsl:element name="SG">
     <xsl:attribute name="hint">SOGGETTO</xsl:attribute>
     <xsl:element name="SGT">
      <xsl:attribute name="hint">SOGGETTO</xsl:attribute>
      <xsl:for-each select="cell[@name='ip_it']">
       <xsl:element name="SGTI">
        <xsl:attribute name="hint">Identificazione</xsl:attribute><xsl:value-of select="normalize-space()"/></xsl:element> 
      </xsl:for-each>
      <xsl:element name="SGTD">
       <xsl:attribute name="hint">Indicazioni sul soggetto</xsl:attribute><xsl:value-of select="cell[@name='BE_it']"/>
       <xsl:if test="cell[@name='B3_it']">. <xsl:value-of select="cell[@name='B3_it']"/></xsl:if>
       </xsl:element>                                                                                                             
     </xsl:element>
    </xsl:element>
    
    <xsl:if test="string-length(cell[@name='DS']) or string-length(cell[@name='DE'])">
     <xsl:element name="DT">
      <xsl:attribute name="hint">CRONOLOGIA</xsl:attribute>
      <xsl:element name="DTS">
       <xsl:attribute name="hint">CRONOLOGIA SPECIFICA</xsl:attribute>
       <xsl:if test="string-length(cell[@name='DS'])">
        <xsl:element name="DTSI">
         <xsl:attribute name="hint">Da</xsl:attribute><xsl:value-of select="substring-before(cell[@name='DS'], '.')"/>/<xsl:value-of select="substring(cell[@name='DS'], 6, 2)"/>/<xsl:value-of select="substring(cell[@name='DS'], string-length(cell[@name='DS']) - 1)"/></xsl:element>
       </xsl:if> 
       <xsl:if test="string-length(cell[@name='DS'])">
        <xsl:element name="DTSF">
         <xsl:attribute name="hint">A</xsl:attribute><xsl:value-of select="substring-before(cell[@name='DE'], '.')"/>/<xsl:value-of select="substring(cell[@name='DE'], 6, 2)"/>/<xsl:value-of select="substring(cell[@name='DE'], string-length(cell[@name='DE']) - 1)"/></xsl:element>
        </xsl:if> 
      </xsl:element>
     </xsl:element>
    </xsl:if>
    
    <xsl:element name="MT">
     <xsl:attribute name="hint">DATI TECNICI</xsl:attribute>
     <xsl:element name="MTC">
      <xsl:attribute name="hint">MATERIA E TECNICA</xsl:attribute>
      <xsl:if test="cell[@name='MA_it']">
       <xsl:element name="MTCM">
        <xsl:attribute name="hint">Materia</xsl:attribute><xsl:value-of select="cell[@name='MA_it']"/></xsl:element>
      </xsl:if>
   			<xsl:for-each select="cell[@name='TK_it']">
	 	  		<xsl:element name="MTCT">
		 		   <xsl:attribute name="hint">Tecnica</xsl:attribute><xsl:value-of select="normalize-space()"/></xsl:element>
			   </xsl:for-each>
     </xsl:element>
     
     <xsl:apply-templates select="cell[@name='dim_it']"/>
     
    </xsl:element>
    
    <xsl:element name="CM">
     <xsl:attribute name="hint">CERTIFICAZIONE E GESTIONE DEI DATI</xsl:attribute>
     <xsl:element name="AGG">
      <xsl:attribute name="hint">AGGIORNAMENTO/REVISIONE</xsl:attribute>
      <xsl:element name="AGGD">
       <xsl:attribute name="hint">Anno di aggiornamento/revisione</xsl:attribute><xsl:value-of select="substring-before(cell[@name='modification'], '-')"/></xsl:element>
     </xsl:element>
    </xsl:element>
   
   </xsl:element>
   
   </xsl:when>
   
   <xsl:otherwise>
	<xsl:element name="MODI">
	
		<xsl:element name="CD">
		<xsl:attribute name="hint">IDENTIFICAZIONE</xsl:attribute>
			<xsl:element name="TSK">
			<xsl:attribute name="hint">Tipo modulo</xsl:attribute>MODI</xsl:element>
			<xsl:element name="CDR">
			<xsl:attribute name="hint">Codice Regione</xsl:attribute>04</xsl:element>
			<xsl:element name="ESC">
			<xsl:attribute name="hint">Ente schedatore</xsl:attribute>P021</xsl:element>
			<xsl:element name="ECP">
			<xsl:attribute name="hint">Ente competente</xsl:attribute>P021</xsl:element>
			<xsl:element name="ACC">
			<xsl:attribute name="hint">ALTRA IDENTIFICAZIONE</xsl:attribute>
				<xsl:element name="ACCE">
				<xsl:attribute name="hint">Ente/soggetto responsabile</xsl:attribute>Provincia autonoma di Bolzano</xsl:element>
				<xsl:element name="ACCC">
				<xsl:attribute name="hint">Codice identificativo</xsl:attribute><xsl:value-of select="cell[@name='priref']"/></xsl:element>
			</xsl:element>
		</xsl:element>
		
		<xsl:element name="OG">
		<xsl:attribute name="hint">ENTITÀ</xsl:attribute>
			<xsl:element name="AMB">
			<xsl:attribute name="hint">Ambito di tutela MiBACT</xsl:attribute>
				<xsl:choose>
				<xsl:when test="contains($OB_it,'giocattolo') or 
contains($OB_it,'Mangiare e bere') or 
contains($OB_it,'Utensile') or 
contains($OB_it,'mortaio') or 
contains($OB_it,'cucchiaio') or 
contains($OB_it,'Hausspezialität') or 
contains($OB_it,'Koffer') or 
contains($OB_it,'Gabel') or 
contains($OB_it,'pentola') or 
contains($OB_it,'Schale') or 
contains($OB_it,'Krapfenteller') or 
contains($OB_it,'chiave') or 
contains($OB_it,'forcina') or 
contains($OB_it,'posate') or 
contains($OB_it,'Kelch')">etnoantropologico</xsl:when>
				<xsl:when test="contains($OB_it,'Festuca rupicola') or 
contains($OB_it,'Festuca') or 
contains($OB_it,'Festuca valesiaca agg.') or 
contains($OB_it,'pianta fossile') or 
contains($OB_it,'Art: Lycopia dezanchei') or 
contains($OB_it,'Rosa canina s.str.') or 
contains($OB_it,'Taraxacum') or 
contains($OB_it,'Rosa subcanina') or 
contains($OB_it,'Art: Sphenobaiera sp.') or 
contains($OB_it,'Festuca norica') or 
contains($OB_it,'Festuca nigrescens') or 
contains($OB_it,'Festuca valesiaca') or 
contains($OB_it,'Art: Voltzia dolomitica') or 
contains($OB_it,'Rosa subcollina') or 
contains($OB_it,'Art: Voltzia sp. 1') or 
contains($OB_it,'Avenula pratensis agg.') or 
contains($OB_it,'Avenula praeusta') or 
contains($OB_it,'Festuca nigricans') or 
contains($OB_it,'Cerastium brachypetalum s.str.') or 
contains($OB_it,'Poa nemoralis s.str.') or 
contains($OB_it,'Festuca guestfalica') or 
contains($OB_it,'Art: Voltzia sp.') or 
contains($OB_it,'Art: weibliche Koniferen-Fruktifikation') or 
contains($OB_it,'Rosa vosagiaca s.str.') or 
contains($OB_it,'Potentilla pusilla') or 
contains($OB_it,'Art: Scytophyllum bergeri') or 
contains($OB_it,'Cerastium glutinosum') or 
contains($OB_it,'Festuca alpina') or 
contains($OB_it,'Rosa coriifolia s.str.') or 
contains($OB_it,'Thymus')">architettonico e paesaggistico</xsl:when>
				<xsl:when test="contains($OB_it,'silicato') or 
contains($OB_it,'ossido') or 
contains($OB_it,'minerale') or 
contains($OB_it,'Art: Fluorit') or 
contains($OB_it,'ammonite') or 
contains($OB_it,'Art: Quarz (kristalline Form), Varietät: Bergkristall') or 
contains($OB_it,'carbonato') or 
contains($OB_it,'solfuro') or 
contains($OB_it,'Art: Calcit') or 
contains($OB_it,'Art: Fluorit, Ausbildung: XX') or 
contains($OB_it,'roccia metamorfica') or 
contains($OB_it,'Art: Aragonit') or 
contains($OB_it,'Art: Quarz (kristalline Form), Varietät: Amethyst') or 
contains($OB_it,'Art: Calcit, Ausbildung: XX') or 
contains($OB_it,'solfato') or 
contains($OB_it,'pietra') or 
contains($OB_it,'Art: Hämatit') or 
contains($OB_it,'Art: Schwefel, Assoziation: Calcit') or 
contains($OB_it,'roccia sedimentaria') or 
contains($OB_it,'Art: Pyrit, Ausbildung: XX') or 
contains($OB_it,'Art: Quarz (kristalline Form)') or 
contains($OB_it,'Art: Quarz (kristalline Form), Varietät: Bergkristall, Assoziation: Chlorit') or 
contains($OB_it,'Art: Hämatit, Ausbildung: XX')">architettonico e paesaggistico</xsl:when>
				<xsl:when test="contains($OB_it,'Art: Ursus spelaeus') or 
contains($OB_it,'conchiglia') or 
contains($OB_it,'corallo') or 
contains($OB_it,'brachiopode') or 
contains($OB_it,'mollusco') or 
contains($OB_it,'riccio di mare') or 
contains($OB_it,'cefalopode') or 
contains($OB_it,'Sorex araneus (Balg, Schädel)') or 
contains($OB_it,'crinoide') or 
contains($OB_it,'pesce') or 
contains($OB_it,'Myotis myotis (Alkoholpräparat, Schädel)')">architettonico e paesaggistico</xsl:when>
				<xsl:when test="contains($OB_it,'grafica') or 
contains($OB_it,'disegno (arte)') or 
contains($OB_it,'disegno') or 
contains($OB_it,'acquerello') or 
contains($OB_it,'Landkarte, politisch') or 
contains($OB_it,'schizzo') or 
contains($OB_it,'disegno tecnico')">storico artistico</xsl:when>
				<xsl:when test="contains($OB_it,'MÃ¼nze') or contains($OB_it,'Medaille')">non individuabile</xsl:when>
				<xsl:when test="contains($OB_it,'vaso grande') or 
contains($OB_it,'libro') or 
contains($OB_it,'dipinto') or 
contains($OB_it,'vaso da farmacia') or 
contains($OB_it,'scultura') or 
contains($OB_it,'Malerei') or 
contains($OB_it,'Schublade') or 
contains($OB_it,'vaso per la consegna') or 
contains($OB_it,'rilievo') or 
contains($OB_it,'Krippenfigur') or 
contains($OB_it,'HolzbÃ¼chse') or 
contains($OB_it,'contenitore') or 
contains($OB_it,'Blankwaffe') or 
contains($OB_it,'barattolo') or 
contains($OB_it,'Zierobjekt') or 
contains($OB_it,'Spitzenbild') or 
contains($OB_it,'ciotola') or 
contains($OB_it,'Hinterglasbild') or 
contains($OB_it,'distintivo') or 
contains($OB_it,'Flasche') or 
contains($OB_it,'tazza') or 
contains($OB_it,'targa') or 
contains($OB_it,'installazione') or 
contains($OB_it,'Decorazione natalizia') or 
contains($OB_it,'spillone') or 
contains($OB_it,'piatto') or 
contains($OB_it,'Tonträger') or 
contains($OB_it,'WeihbrunnkrÃ¼gl') or 
contains($OB_it,'orario') or 
contains($OB_it,'Aufkleber') or 
contains($OB_it,'mobile') or 
contains($OB_it,'oggetto') or 
contains($OB_it,'Ofenkachel') or 
contains($OB_it,'figurina da collezione') or 
contains($OB_it,'Beleuchtung') or 
contains($OB_it,'adornamento') or 
contains($OB_it,'targhetta') or 
contains($OB_it,'presepio') or 
contains($OB_it,'serratura della porta') or 
contains($OB_it,'Kruzifix') or 
contains($OB_it,'bricco') or 
contains($OB_it,'Schachtel') or 
contains($OB_it,'portacandela') or 
contains($OB_it,'Henkeltopf') or 
contains($OB_it,'Krug') or 
contains($OB_it,'bambola') or 
contains($OB_it,'Laccio') or 
contains($OB_it,'candelabro') or 
contains($OB_it,'sedia') or 
contains($OB_it,'Stielglas') or 
contains($OB_it,'Vase') or 
contains($OB_it,'dipinto ad') or 
contains($OB_it,'Gürtelschnalle') or 
contains($OB_it,'Beschlag') or 
contains($OB_it,'modanatura')">storico artistico</xsl:when>
				<xsl:when test="contains($OB_it,'macchina da scrivere') or 
contains($OB_it,'Farmaco') or 
contains($OB_it,'Hausmittel') or 
contains($OB_it,'apparecchio tecnico') or 
contains($OB_it,'bilancia') or 
contains($OB_it,'WaffenzubehÃ¶r und Munition') or 
contains($OB_it,'coltello') or 
contains($OB_it,'elemento portacaratteri') or 
contains($OB_it,'Medicinale') or 
contains($OB_it,'Schallplatte') or 
contains($OB_it,'Musikkassette') or 
contains($OB_it,'Grubenlampe') or 
contains($OB_it,'campanella') or 
contains($OB_it,'pinza')">non individuabile</xsl:when>
				<xsl:when test="contains($OB_it,'Bodenfund') or contains($OB_it,'Fibel')">archeologico</xsl:when>
				<xsl:when test="contains($OB_it,'opuscolo pubblicitario') or 
contains($OB_it,'stampa') or 
contains($OB_it,'immagine devozionale') or 
contains($OB_it,'Dokument') or 
contains($OB_it,'carta menu') or 
contains($OB_it,'opuscolo') or 
contains($OB_it,'Landkarte') or 
contains($OB_it,'rivista') or 
contains($OB_it,'brevetto') or 
contains($OB_it,'lettera') or 
contains($OB_it,'articolo') or 
contains($OB_it,'Werbeprospekt') or 
contains($OB_it,'bollo pubblicitario') or 
contains($OB_it,'Landkarte, topographisch') or 
contains($OB_it,'Veranstaltungsprogramm') or 
contains($OB_it,'fascicolo') or 
contains($OB_it,'biglietto d') or 
contains($OB_it,'Einzelblatt') or 
contains($OB_it,'Stadtplan') or 
contains($OB_it,'Landkarte, historisch') or 
contains($OB_it,'Primizbild') or 
contains($OB_it,'clichÃ© (stampa)') or 
contains($OB_it,'Beichtzettel') or 
contains($OB_it,'Gelegenheitskarte') or 
contains($OB_it,'fattura') or 
contains($OB_it,'Weinetikette') or 
contains($OB_it,'depliant') or 
contains($OB_it,'Einladung') or 
contains($OB_it,'Kofferaufkleber') or 
contains($OB_it,'francobollo') or 
contains($OB_it,'Fahrkarte') or 
contains($OB_it,'Flugblatt') or 
contains($OB_it,'Werbeblatt') or 
contains($OB_it,'banconota') or 
contains($OB_it,'biglietto da visita') or 
contains($OB_it,'calendario') or 
contains($OB_it,'giornale') or 
contains($OB_it,'Neujahrsentschuldigungskarte') or 
contains($OB_it,'rilievo,Landkarte') or 
contains($OB_it,'Programm') or 
contains($OB_it,'Leporello') or 
contains($OB_it,'Werbekarte') or 
contains($OB_it,'cartello (insegna pubblicitaria)') or 
contains($OB_it,'Carte de visite') or 
contains($OB_it,'Plan') or 
contains($OB_it,'Gästebuch')">storico artistico</xsl:when>
				<xsl:when test="contains($OB_it,'Zither')">storico artistico</xsl:when>
				<xsl:when test="contains($OB_it,'Sopraveste') or contains($OB_it,'Scarpe') or contains($OB_it,'cappello') or contains($OB_it,'borsa') or contains($OB_it,'Bänderhut')">etnoantropologico</xsl:when>
    <xsl:otherwise>non individuabile</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<xsl:element name="OGD">
			<xsl:attribute name="hint">Definizione</xsl:attribute><xsl:value-of select="$OB_it"/></xsl:element>
			<xsl:element name="OGT">
			<xsl:attribute name="hint">Tipologia</xsl:attribute><xsl:value-of select="cell[@name='OB_it_syn']"/></xsl:element>
			
		</xsl:element>
		
		<xsl:element name="LC">
		<xsl:attribute name="hint">LOCALIZZAZIONE</xsl:attribute>
			<xsl:element name="LCS">
			<xsl:attribute name="hint">Stato</xsl:attribute>Italia</xsl:element>
			<xsl:element name="LCR">
			<xsl:attribute name="hint">Regione</xsl:attribute>Trentino-Alto Adige</xsl:element>
			<xsl:element name="LCP">
			<xsl:attribute name="hint">Provincia</xsl:attribute>BZ</xsl:element>
      
			<xsl:for-each select="cell[@name='CP_it_syn'][normalize-space()=$comuniBZ//comune][1]">
				<xsl:element name="LCC">
				<xsl:attribute name="hint">Comune</xsl:attribute><xsl:value-of select="normalize-space()"/></xsl:element>
			</xsl:for-each>
		</xsl:element>
		
		<xsl:if test="string-length(cell[@name='DS']) or string-length(cell[@name='DE'])">
		<!-- ci sarebbe DTR-Riferimento cronologico (obbligatorio) per mettere il secolo di riferimento (calcolare in base a primi 2 numeri della data?) -->
		
		<xsl:element name="DT">
		<xsl:attribute name="hint">CRONOLOGIA</xsl:attribute>
			<xsl:element name="DTS">
			<xsl:attribute name="hint">CRONOLOGIA SPECIFICA</xsl:attribute>
			<xsl:if test="string-length(cell[@name='DS'])">
			<xsl:element name="DTSI">
			<xsl:attribute name="hint">Da</xsl:attribute><xsl:value-of select="substring-before(cell[@name='DS'], '.')"/>/<xsl:value-of select="substring(cell[@name='DS'], 6, 2)"/>/<xsl:value-of select="substring(cell[@name='DS'], string-length(cell[@name='DS']) - 1)"/></xsl:element>
			</xsl:if> 
			<xsl:if test="string-length(cell[@name='DS'])">
			<xsl:element name="DTSF">
			<xsl:attribute name="hint">A</xsl:attribute><xsl:value-of select="substring-before(cell[@name='DE'], '.')"/>/<xsl:value-of select="substring(cell[@name='DE'], 6, 2)"/>/<xsl:value-of select="substring(cell[@name='DE'], string-length(cell[@name='DE']) - 1)"/></xsl:element>
			</xsl:if> 
			</xsl:element>
		</xsl:element>
		</xsl:if>
	
		<xsl:element name="CM">
		<xsl:attribute name="hint">CERTIFICAZIONE E GESTIONE DEI DATI</xsl:attribute>
			<xsl:element name="CMA">
			<xsl:attribute name="hint">Anno di redazione</xsl:attribute><xsl:value-of select="substring-before(cell[@name='modification'], '-')"/></xsl:element>
			<xsl:element name="IMD">
			<xsl:attribute name="hint">MIGRAZIONE DATI NELLE SCHEDE DI CATALOGO</xsl:attribute>
				<xsl:choose>
				<xsl:when test="contains($OB_it,'giocattolo') or 
contains($OB_it,'Mangiare e bere') or 
contains($OB_it,'Utensile') or 
contains($OB_it,'mortaio') or 
contains($OB_it,'cucchiaio') or 
contains($OB_it,'Hausspezialität') or 
contains($OB_it,'Koffer') or 
contains($OB_it,'Gabel') or 
contains($OB_it,'pentola') or 
contains($OB_it,'Schale') or 
contains($OB_it,'Krapfenteller') or 
contains($OB_it,'chiave') or 
contains($OB_it,'forcina') or 
contains($OB_it,'posate') or 
contains($OB_it,'Kelch')">
				<xsl:element name="IMDT">
					<xsl:attribute name="hint">Tipo scheda</xsl:attribute>BDM</xsl:element>
				</xsl:when>
				<xsl:when test="contains($OB_it,'Festuca rupicola') or 
contains($OB_it,'Festuca') or 
contains($OB_it,'Festuca valesiaca agg.') or 
contains($OB_it,'pianta fossile') or 
contains($OB_it,'Art: Lycopia dezanchei') or 
contains($OB_it,'Rosa canina s.str.') or 
contains($OB_it,'Taraxacum') or 
contains($OB_it,'Rosa subcanina') or 
contains($OB_it,'Art: Sphenobaiera sp.') or 
contains($OB_it,'Festuca norica') or 
contains($OB_it,'Festuca nigrescens') or 
contains($OB_it,'Festuca valesiaca') or 
contains($OB_it,'Art: Voltzia dolomitica') or 
contains($OB_it,'Rosa subcollina') or 
contains($OB_it,'Art: Voltzia sp. 1') or 
contains($OB_it,'Avenula pratensis agg.') or 
contains($OB_it,'Avenula praeusta') or 
contains($OB_it,'Festuca nigricans') or 
contains($OB_it,'Cerastium brachypetalum s.str.') or 
contains($OB_it,'Poa nemoralis s.str.') or 
contains($OB_it,'Festuca guestfalica') or 
contains($OB_it,'Art: Voltzia sp.') or 
contains($OB_it,'Art: weibliche Koniferen-Fruktifikation') or 
contains($OB_it,'Rosa vosagiaca s.str.') or 
contains($OB_it,'Potentilla pusilla') or 
contains($OB_it,'Art: Scytophyllum bergeri') or 
contains($OB_it,'Cerastium glutinosum') or 
contains($OB_it,'Festuca alpina') or 
contains($OB_it,'Rosa coriifolia s.str.') or 
contains($OB_it,'Thymus')">
				<xsl:element name="IMDT">
					<xsl:attribute name="hint">Tipo scheda</xsl:attribute>BNB</xsl:element>
				</xsl:when>
				<xsl:when test="contains($OB_it,'silicato') or 
contains($OB_it,'ossido') or 
contains($OB_it,'minerale') or 
contains($OB_it,'Art: Fluorit') or 
contains($OB_it,'ammonite') or 
contains($OB_it,'Art: Quarz (kristalline Form), Varietät: Bergkristall') or 
contains($OB_it,'carbonato') or 
contains($OB_it,'solfuro') or 
contains($OB_it,'Art: Calcit') or 
contains($OB_it,'Art: Fluorit, Ausbildung: XX') or 
contains($OB_it,'roccia metamorfica') or 
contains($OB_it,'Art: Aragonit') or 
contains($OB_it,'Art: Quarz (kristalline Form), Varietät: Amethyst') or 
contains($OB_it,'Art: Calcit, Ausbildung: XX') or 
contains($OB_it,'solfato') or 
contains($OB_it,'pietra') or 
contains($OB_it,'Art: Hämatit') or 
contains($OB_it,'Art: Schwefel, Assoziation: Calcit') or 
contains($OB_it,'roccia sedimentaria') or 
contains($OB_it,'Art: Pyrit, Ausbildung: XX') or 
contains($OB_it,'Art: Quarz (kristalline Form)') or 
contains($OB_it,'Art: Quarz (kristalline Form), Varietät: Bergkristall, Assoziation: Chlorit') or 
contains($OB_it,'Art: Hämatit, Ausbildung: XX')">
				<xsl:element name="IMDT">
					<xsl:attribute name="hint">Tipo scheda</xsl:attribute>BNM</xsl:element>
				</xsl:when>
				<xsl:when test="contains($OB_it,'Art: Ursus spelaeus') or 
contains($OB_it,'conchiglia') or 
contains($OB_it,'corallo') or 
contains($OB_it,'brachiopode') or 
contains($OB_it,'mollusco') or 
contains($OB_it,'riccio di mare') or 
contains($OB_it,'cefalopode') or 
contains($OB_it,'Sorex araneus (Balg, Schädel)') or 
contains($OB_it,'crinoide') or 
contains($OB_it,'pesce') or 
contains($OB_it,'Myotis myotis (Alkoholpräparat, Schädel)')">
				<xsl:element name="IMDT">
					<xsl:attribute name="hint">Tipo scheda</xsl:attribute>BNZ</xsl:element>
				</xsl:when>
				<xsl:when test="contains($OB_it,'grafica') or 
contains($OB_it,'disegno (arte)') or 
contains($OB_it,'disegno') or 
contains($OB_it,'acquerello') or 
contains($OB_it,'Landkarte, politisch') or 
contains($OB_it,'schizzo') or 
contains($OB_it,'disegno tecnico')">
				<xsl:element name="IMDT">
					<xsl:attribute name="hint">Tipo scheda</xsl:attribute>D</xsl:element>
				</xsl:when>
				<xsl:when test="contains($OB_it,'MÃ¼nze') or contains($OB_it,'Medaille')">
					<xsl:element name="IMDT">
					<xsl:attribute name="hint">Tipo scheda</xsl:attribute>NU</xsl:element>
				</xsl:when>
				<xsl:when test="contains($OB_it,'vaso grande') or 
contains($OB_it,'libro') or 
contains($OB_it,'dipinto') or 
contains($OB_it,'vaso da farmacia') or 
contains($OB_it,'scultura') or 
contains($OB_it,'Malerei') or 
contains($OB_it,'Schublade') or 
contains($OB_it,'vaso per la consegna') or 
contains($OB_it,'rilievo') or 
contains($OB_it,'Krippenfigur') or 
contains($OB_it,'HolzbÃ¼chse') or 
contains($OB_it,'contenitore') or 
contains($OB_it,'Blankwaffe') or 
contains($OB_it,'barattolo') or 
contains($OB_it,'Zierobjekt') or 
contains($OB_it,'Spitzenbild') or 
contains($OB_it,'ciotola') or 
contains($OB_it,'Hinterglasbild') or 
contains($OB_it,'distintivo') or 
contains($OB_it,'Flasche') or 
contains($OB_it,'tazza') or 
contains($OB_it,'targa') or 
contains($OB_it,'installazione') or 
contains($OB_it,'Decorazione natalizia') or 
contains($OB_it,'spillone') or 
contains($OB_it,'piatto') or 
contains($OB_it,'Tonträger') or 
contains($OB_it,'WeihbrunnkrÃ¼gl') or 
contains($OB_it,'orario') or 
contains($OB_it,'Aufkleber') or 
contains($OB_it,'mobile') or 
contains($OB_it,'oggetto') or 
contains($OB_it,'Ofenkachel') or 
contains($OB_it,'figurina da collezione') or 
contains($OB_it,'Beleuchtung') or 
contains($OB_it,'adornamento') or 
contains($OB_it,'targhetta') or 
contains($OB_it,'presepio') or 
contains($OB_it,'serratura della porta') or 
contains($OB_it,'Kruzifix') or 
contains($OB_it,'bricco') or 
contains($OB_it,'Schachtel') or 
contains($OB_it,'portacandela') or 
contains($OB_it,'Henkeltopf') or 
contains($OB_it,'Krug') or 
contains($OB_it,'bambola') or 
contains($OB_it,'Laccio') or 
contains($OB_it,'candelabro') or 
contains($OB_it,'sedia') or 
contains($OB_it,'Stielglas') or 
contains($OB_it,'Vase') or 
contains($OB_it,'dipinto ad') or 
contains($OB_it,'Gürtelschnalle') or 
contains($OB_it,'Beschlag') or 
contains($OB_it,'modanatura')">
				<xsl:element name="IMDT">
				<xsl:attribute name="hint">Tipo scheda</xsl:attribute>OA</xsl:element>
				</xsl:when>
				<xsl:when test="contains($OB_it,'macchina da scrivere') or 
contains($OB_it,'Farmaco') or 
contains($OB_it,'Hausmittel') or 
contains($OB_it,'apparecchio tecnico') or 
contains($OB_it,'bilancia') or 
contains($OB_it,'WaffenzubehÃ¶r und Munition') or 
contains($OB_it,'coltello') or 
contains($OB_it,'elemento portacaratteri') or 
contains($OB_it,'Medicinale') or 
contains($OB_it,'Schallplatte') or 
contains($OB_it,'Musikkassette') or 
contains($OB_it,'Grubenlampe') or 
contains($OB_it,'campanella') or 
contains($OB_it,'pinza')">
				<xsl:element name="IMDT">
					<xsl:attribute name="hint">Tipo scheda</xsl:attribute>PST</xsl:element>
				</xsl:when>
				<xsl:when test="contains($OB_it,'Bodenfund') or contains($OB_it,'Fibel')">
					<xsl:element name="IMDT">
					<xsl:attribute name="hint">Tipo scheda</xsl:attribute>RA</xsl:element>
				</xsl:when>
				<xsl:when test="contains($OB_it,'opuscolo pubblicitario') or 
contains($OB_it,'stampa') or 
contains($OB_it,'immagine devozionale') or 
contains($OB_it,'Dokument') or 
contains($OB_it,'carta menu') or 
contains($OB_it,'opuscolo') or 
contains($OB_it,'Landkarte') or 
contains($OB_it,'rivista') or 
contains($OB_it,'brevetto') or 
contains($OB_it,'lettera') or 
contains($OB_it,'articolo') or 
contains($OB_it,'Werbeprospekt') or 
contains($OB_it,'bollo pubblicitario') or 
contains($OB_it,'Landkarte, topographisch') or 
contains($OB_it,'Veranstaltungsprogramm') or 
contains($OB_it,'fascicolo') or 
contains($OB_it,'biglietto d') or 
contains($OB_it,'Einzelblatt') or 
contains($OB_it,'Stadtplan') or 
contains($OB_it,'Landkarte, historisch') or 
contains($OB_it,'Primizbild') or 
contains($OB_it,'clichÃ© (stampa)') or 
contains($OB_it,'Beichtzettel') or 
contains($OB_it,'Gelegenheitskarte') or 
contains($OB_it,'fattura') or 
contains($OB_it,'Weinetikette') or 
contains($OB_it,'depliant') or 
contains($OB_it,'Einladung') or 
contains($OB_it,'Kofferaufkleber') or 
contains($OB_it,'francobollo') or 
contains($OB_it,'Fahrkarte') or 
contains($OB_it,'Flugblatt') or 
contains($OB_it,'Werbeblatt') or 
contains($OB_it,'banconota') or 
contains($OB_it,'biglietto da visita') or 
contains($OB_it,'calendario') or 
contains($OB_it,'giornale') or 
contains($OB_it,'Neujahrsentschuldigungskarte') or 
contains($OB_it,'rilievo,Landkarte') or 
contains($OB_it,'Programm') or 
contains($OB_it,'Leporello') or 
contains($OB_it,'Werbekarte') or 
contains($OB_it,'cartello (insegna pubblicitaria)') or 
contains($OB_it,'Carte de visite') or 
contains($OB_it,'Plan') or 
contains($OB_it,'Gästebuch')">
				<xsl:element name="IMDT">
					<xsl:attribute name="hint">Tipo scheda</xsl:attribute>S</xsl:element>
				</xsl:when>
				<xsl:when test="contains($OB_it,'Zither')">
					<xsl:element name="IMDT">
					<xsl:attribute name="hint">Tipo scheda</xsl:attribute>SM</xsl:element>
				</xsl:when>
				<xsl:when test="contains($OB_it,'Sopraveste') or contains($OB_it,'Scarpe') or contains($OB_it,'cappello') or contains($OB_it,'borsa') or contains($OB_it,'Bänderhut')">
					<xsl:element name="IMDT">
					<xsl:attribute name="hint">Tipo scheda</xsl:attribute>VeAC</xsl:element>
				</xsl:when>
    <!--
    <xsl:otherwise>
					<xsl:element name="IMDT">
					<xsl:attribute name="hint">Tipo scheda</xsl:attribute>non individuabile</xsl:element>
    </xsl:otherwise>
    -->
				</xsl:choose>
			</xsl:element>
		</xsl:element>
		
		<xsl:element name="MT">
		<xsl:attribute name="hint">DATI TECNICI</xsl:attribute>
			<xsl:element name="MTC">
			<xsl:attribute name="hint">MATERIA E TECNICA</xsl:attribute>
				<xsl:if test="cell[@name='MA_it']">
				<xsl:element name="MTCM">
				<xsl:attribute name="hint">Materia</xsl:attribute><xsl:value-of select="cell[@name='MA_it']"/></xsl:element>
				</xsl:if>
				<xsl:for-each select="cell[@name='TK_it']">
					<xsl:element name="MTCT">
					<xsl:attribute name="hint">Tecnica</xsl:attribute><xsl:value-of select="normalize-space()"/></xsl:element>
				</xsl:for-each>
			</xsl:element>
     
			<xsl:apply-templates select="cell[@name='dim_it']"/>
		</xsl:element>
		
  <xsl:variable name="vv" select="normalize-space(cell[@name='VV_it'])"/>
  <xsl:if test="string-length($vv)>0">
		<xsl:element name="AU">
		<xsl:attribute name="hint">DEFINIZIONE CULTURALE</xsl:attribute>
			<xsl:element name="AUT">
			<xsl:attribute name="hint">AUTORE/RESPONSABILITA'</xsl:attribute>
				<xsl:element name="AUTN">
				<xsl:attribute name="hint">Nome di persona o ente</xsl:attribute><xsl:value-of select="$vv"/></xsl:element>
				<xsl:element name="AUTP">
				<xsl:attribute name="hint">Tipo intestazione</xsl:attribute>NR</xsl:element>
			</xsl:element>
		</xsl:element>
  </xsl:if>
	
		<xsl:if test="string-length(normalize-space(cell[@name='CP_geo']))">
		<xsl:element name="GE">
		<xsl:attribute name="hint">GEOREFERENZIAZIONE</xsl:attribute>
			<xsl:element name="GEL">
			<xsl:attribute name="hint">Tipo di localizzazione</xsl:attribute>localizzazione fisica</xsl:element>
			<xsl:element name="GET">
			<xsl:attribute name="hint">Tipo di georeferenziazione</xsl:attribute>georeferenziazione puntuale</xsl:element>
			<xsl:element name="GEC">
			<xsl:attribute name="hint">COORDINATE</xsl:attribute>
				<xsl:variable name="x" select="normalize-space(substring-after(cell[@name='CP_geo'], ','))"/>
				<xsl:element name="GECX">
				<xsl:attribute name="hint">Coordinata x</xsl:attribute>
					<xsl:choose><!-- ignore multiple points -->
					<xsl:when test="contains($x,',')"><xsl:value-of select="substring-before($x,',')"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$x"/></xsl:otherwise>
					</xsl:choose>
				</xsl:element>
				<xsl:element name="GECY">
				<xsl:attribute name="hint">Coordinata y</xsl:attribute><xsl:value-of select="substring-before(cell[@name='CP_geo'], ',')"/></xsl:element>
			</xsl:element>
		</xsl:element>
		</xsl:if>
	
	</xsl:element>
   
   </xsl:otherwise>
   </xsl:choose>
   
   <xsl:element name="harvesting">
    <xsl:for-each select="cell[@name='B1p_url' and string-length(normalize-space())]">
     <xsl:element name="media"><xsl:value-of select="concat(.,'&amp;size=l')"/></xsl:element>
    </xsl:for-each>
    <xsl:if test="string-length(normalize-space(cell[@name='CP_geo']))">
     <xsl:element name="puntoPrincipale">
      <xsl:variable name="x" select="normalize-space(substring-after(cell[@name='CP_geo'], ','))"/>
      <xsl:element name="x">
       <xsl:choose><!-- ignore multiple points -->
        <xsl:when test="contains($x,',')"><xsl:value-of select="substring-before($x,',')"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$x"/></xsl:otherwise>
       </xsl:choose>
      </xsl:element>
      <xsl:element name="y"><xsl:value-of select="substring-before(cell[@name='CP_geo'], ',')"/></xsl:element>
     </xsl:element>
    </xsl:if>
   </xsl:element>
   
  </schede>
 </metadata>
</record>
 </xsl:template>

 <xsl:template match="cell[@name='dim_it']">
		
	 <xsl:element name="MIS">
	  <xsl:attribute name="hint">MISURE</xsl:attribute>
 		<xsl:element name="MISP">
	  	<xsl:attribute name="hint">Riferimento alla parte</xsl:attribute>supporto primario</xsl:element>
		 <xsl:element name="MISZ">
		  <xsl:attribute name="hint">Tipo di misura</xsl:attribute>altezzaxlunghezza</xsl:element>
		 <xsl:element name="MISU">
		  <xsl:attribute name="hint">Unità di misura</xsl:attribute><xsl:value-of select="substring(., string-length(.) - 1)"/></xsl:element>
		 <xsl:choose>
		  <xsl:when test="contains(.,'larghezza')">
  			<xsl:variable name="ALTcc" select="substring-after(.,',')"/>
 	 		<xsl:variable name="LARGcc" select="substring-before(.,',')"/>
 		 	<xsl:variable name="LARGc" select="substring-after($LARGcc,' ')"/>
 			 <xsl:variable name="ALTc" select="substring-after($ALTcc,' ')"/>
 		 	<xsl:variable name="LARG" select="substring-before($LARGc,' ')"/>
 		 	<xsl:variable name="ALT" select="substring-before($ALTc,' ')"/>
 		 	<xsl:element name="MISM">
    		<xsl:attribute name="hint">Valore</xsl:attribute><xsl:value-of select="$ALT"/>x<xsl:value-of select="$LARG"/></xsl:element>
		  </xsl:when>
		  <xsl:when test="contains(.,'lunghezza')">
  			<xsl:variable name="ALTcc" select="substring-after(.,',')"/>
 	 		<xsl:variable name="LARGcc" select="substring-before(.,',')"/>
 		 	<xsl:variable name="LARGc" select="substring-after($LARGcc,' ')"/>
 			 <xsl:variable name="ALTc" select="substring-after($ALTcc,' ')"/>
 		 	<xsl:variable name="LARG" select="substring-before($LARGc,' ')"/>
 		 	<xsl:variable name="ALT" select="substring-before($ALTc,' ')"/>
 		 	<xsl:element name="MISM">
    		<xsl:attribute name="hint">Valore</xsl:attribute><xsl:value-of select="$ALT"/>x<xsl:value-of select="$LARG"/></xsl:element>
		  </xsl:when>
  		<xsl:otherwise>
		  	<xsl:variable name="ALTc" select="normalize-space(substring-after(.,'x'))"/>
  			<xsl:variable name="LARG" select="normalize-space(substring-before(.,'x'))"/>
  			<xsl:variable name="ALT" select="substring-before($ALTc,' ')"/>
			  <xsl:element name="MISM">
    		<xsl:attribute name="hint">Valore</xsl:attribute><xsl:value-of select="$ALT"/>x<xsl:value-of select="$LARG"/></xsl:element>
  		</xsl:otherwise>
	  </xsl:choose>
		</xsl:element>

 </xsl:template>

</xsl:stylesheet>
