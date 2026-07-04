<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
 <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no" omit-xml-declaration="yes"/>

	<xsl:template match="* | @* | text() | comment()" name="copy">
		<xsl:copy><xsl:apply-templates select="* | @* | text() | comment()"/></xsl:copy>
	</xsl:template>
 
 <xsl:template priority="2" match="*/text()[../*]"/>
 
 <xsl:template name="lang-value">
  <xsl:param name="values"/>
  <xsl:param name="lang" select="'it-IT'"/>
  <xsl:choose>
    <xsl:when test="$values[@lang=$lang]">
     <xsl:value-of select="$values[@lang=$lang][1]"/>
    </xsl:when>
    <xsl:when test="$values[@invariantr='true']">
     <xsl:value-of select="$values[@invariantr='true'][1]"/>
    </xsl:when>
    <xsl:otherwise>
     <xsl:value-of select="$values[1]"/>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:template>
 
 <xsl:template name="lang-elem">
  <xsl:param name="values"/>
  <xsl:param name="name"/>
  <xsl:param name="lang" select="'it-IT'"/>
  <xsl:if test="count($values)&gt;0">
   <xsl:element name="cell"><xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
    <xsl:call-template name="lang-value">
     <xsl:with-param name="values" select="$values"/>
     <xsl:with-param name="lang" select="$lang"/>
    </xsl:call-template>
   </xsl:element>
  </xsl:if>
 </xsl:template>
 
	<xsl:template priority="2" match="record">
 <!--
  <xsl:if test="Media/media.reference/reference_number[string-length(normalize-space())&gt;0]
            and Object_name/object_name/term/value    [string-length(normalize-space())&gt;0][@lang='it-IT']">
            --><!-- Eliminare i dati attribuiti all'ente TAP (Archivio Tirolese per la documentazione e l'arte fotografica di Lienz (TAP) perchè non sono italiani e non devono stare nel Catalogo -->
  <xsl:if test="not(institution.code[.='TAP'])
            and Media/media.reference/reference_number[string-length(normalize-space())&gt;0]
            and Object_name/object_name/term/value    [string-length(normalize-space())&gt;0][@lang='it-IT' or @invariant='true']">
   <xsl:value-of select="'&#xa;'"/><!--
	 	<xsl:call-template name="copy"/> -->
   <xsl:element name="row">
    <xsl:element name="cell"><xsl:attribute name="name">modification</xsl:attribute>
     <xsl:value-of select="@modification"/>
    </xsl:element>
    <xsl:element name="cell"><xsl:attribute name="name">priref</xsl:attribute>
     <xsl:value-of select="@priref"/>
    </xsl:element>
    <xsl:element name="cell"><xsl:attribute name="name">IN</xsl:attribute>
     <xsl:value-of select="object_number"/>
    </xsl:element>
    <xsl:element name="cell"><xsl:attribute name="name">MUS</xsl:attribute>
     <xsl:value-of select="institution.code"/>
    </xsl:element>

    <xsl:call-template name="lang-elem">
     <xsl:with-param name="values" select="Title/title/value[string-length(normalize-space())&gt;0]"/>
     <xsl:with-param name="name" select="'TI_it'"/>
    </xsl:call-template>
    
    <xsl:element name="cell"><xsl:attribute name="name">OB_it</xsl:attribute>
     <xsl:for-each select="Object_name/object_name/term/value[string-length(normalize-space())&gt;0][@lang='it-IT']">
      <xsl:if test="position()&gt;1">,</xsl:if>
      <xsl:value-of select="."/>
     </xsl:for-each>
     <xsl:if test="not(Object_name/object_name/term/value[string-length(normalize-space())&gt;0][@lang='it-IT'])">
      <xsl:for-each select="Object_name/object_name/term/value[string-length(normalize-space())&gt;0][@invariant='true']">
       <xsl:if test="position()&gt;1">,</xsl:if>
       <xsl:value-of select="."/>
      </xsl:for-each>
     </xsl:if>
    </xsl:element>
    <xsl:for-each select="Content_subject">
     <xsl:call-template name="lang-elem">
      <xsl:with-param name="values" select="content.subject/value[string-length(normalize-space())&gt;0]"/>
      <xsl:with-param name="name" select="'ip_it'"/>
     </xsl:call-template>
    </xsl:for-each>
    <xsl:call-template name="lang-elem">
     <xsl:with-param name="values" select="Description/description/value[string-length(normalize-space())&gt;0]"/>
     <xsl:with-param name="name" select="'BE_it'"/>
    </xsl:call-template>
    <xsl:call-template name="lang-elem">
     <xsl:with-param name="values" select="Historical_critical_notes/historical_critical_notes/value[string-length(normalize-space())&gt;0]"/>
     <xsl:with-param name="name" select="'B3_it'"/>
    </xsl:call-template>
    <xsl:for-each select="Collection">
     <xsl:call-template name="lang-elem">
      <xsl:with-param name="values" select="collection.name/collection/value[string-length(normalize-space())&gt;0]"/>
      <xsl:with-param name="name" select="'CL_it'"/>
     </xsl:call-template>
    </xsl:for-each>
    
    <xsl:for-each select="Dating/dating.date.start[string-length(normalize-space())&gt;0]">
     <xsl:element name="cell"><xsl:attribute name="name">DS</xsl:attribute>
      <xsl:value-of select="."/>
     </xsl:element>
    </xsl:for-each>
    <!--
      <xsl:call-template name="lang-value">
       <xsl:with-param name="values" select="Dating/dating.date.start.prec/value[string-length(normalize-space())&gt;0]"/>
      </xsl:call-template>
    -->
    <xsl:for-each select="Dating/dating.date.end[string-length(normalize-space())&gt;0]">
     <xsl:element name="cell"><xsl:attribute name="name">DE</xsl:attribute>
      <xsl:value-of select="."/>
     </xsl:element>
    </xsl:for-each>
    <!--
      <xsl:call-template name="lang-value">
       <xsl:with-param name="values" select="Dating/dating.date.end.prec/value[string-length(normalize-space())&gt;0]"/>
      </xsl:call-template>
    -->
    
    <xsl:for-each select="Dimension[dimension.value[string-length(normalize-space())&gt;0]]">
     <xsl:element name="cell"><xsl:attribute name="name">dim_it</xsl:attribute>
      <xsl:value-of select="dimension.value"/><xsl:text>; </xsl:text>
      <xsl:call-template name="lang-value"><xsl:with-param name="values" select="dimension.unit/value     [string-length(normalize-space())&gt;0]"/></xsl:call-template><xsl:text>; </xsl:text>
      <xsl:call-template name="lang-value"><xsl:with-param name="values" select="dimension.part/value     [string-length(normalize-space())&gt;0]"/></xsl:call-template><xsl:text>; </xsl:text>
      <xsl:call-template name="lang-value"><xsl:with-param name="values" select="dimension.type/value     [string-length(normalize-space())&gt;0]"/></xsl:call-template><xsl:text>; </xsl:text>
      <xsl:call-template name="lang-value"><xsl:with-param name="values" select="dimension.precision/value[string-length(normalize-space())&gt;0]"/></xsl:call-template>
     </xsl:element>
    </xsl:for-each>

    <xsl:for-each select="Technique">
     <xsl:call-template name="lang-elem">
      <xsl:with-param name="values" select="technique/value[string-length(normalize-space())&gt;0]"/>
      <xsl:with-param name="name" select="'TK_it'"/>
     </xsl:call-template>
    </xsl:for-each>
    
    <xsl:for-each select="Material">
     <xsl:call-template name="lang-elem">
      <xsl:with-param name="values" select="material/term/value[string-length(normalize-space())&gt;0]"/>
      <xsl:with-param name="name" select="'MA_it'"/>
     </xsl:call-template>
    </xsl:for-each>
    <!--
    <xsl:for-each select="Production[creator/name/value[string-length(normalize-space())&gt;0]]">
     <xsl:call-template name="lang-elem">
      <xsl:with-param name="values" select="creator/name/value[string-length(normalize-space())&gt;0]"/>
      <xsl:with-param name="name" select="'VV_it'"/>
     </xsl:call-template>
    </xsl:for-each>
    -->
    <xsl:if test="Production[creator/name/value[string-length(normalize-space())&gt;0]]">
     <xsl:element name="cell"><xsl:attribute name="name">VV_it</xsl:attribute>
      <xsl:for-each select="Production[creator/name/value[string-length(normalize-space())&gt;0]]">
       <xsl:if test="position()&gt;1">; </xsl:if>
       <xsl:call-template name="lang-value">
        <xsl:with-param name="values" select="creator/name/value[string-length(normalize-space())&gt;0]"/>
       </xsl:call-template>
      </xsl:for-each>
     </xsl:element>
    </xsl:if>

    <xsl:for-each select="(ContentGeo/content.geographical_keyword/term/value[string-length(normalize-space())&gt;0][@lang='it-IT']|
                           ContentGeo/content.geographical_keyword/term/value[string-length(normalize-space())&gt;0][@invariant='true'])">
     <xsl:element name="cell"><xsl:attribute name="name">CP_it_syn</xsl:attribute>
      <xsl:value-of select="."/>
     </xsl:element>
    </xsl:for-each>
    
    <xsl:variable name="jpoint">"Point","coordinates":[</xsl:variable>
    <xsl:for-each select="(ContentGeo/content.geographical_keyword.gis[contains(.,$jpoint)])[1]">
     <xsl:element name="cell"><xsl:attribute name="name">CP_geo</xsl:attribute>
      <xsl:value-of select="concat(substring-before(substring-after(substring-after(.,$jpoint),','),']'),',',substring-before(substring-after(.,$jpoint),','))"/>
     </xsl:element>
    </xsl:for-each>

    <xsl:for-each select="Media/media.reference/reference_number[string-length(normalize-space())&gt;0]">
     <xsl:element name="cell"><xsl:attribute name="name">B1p_url</xsl:attribute>
      <xsl:value-of select="
       concat('https://oggetti-musei-archivi.provincia.bz.it/Content/GetContent?command=getcontent&amp;server=',
       ../../../institution.code,'images&amp;value=',../../../institution.code,'/',
       encode-for-uri(.),'&amp;folderId=',
       ../../../@priref,'&amp;width=1024&amp;height=1024&amp;imageformat=jpg')"/>
     </xsl:element>
    </xsl:for-each>
    
    <xsl:call-template name="lang-elem">
     <xsl:with-param name="values" select="Media/media.reference/rights/value[string-length(normalize-space())&gt;0]"/>
     <xsl:with-param name="name" select="'RI_it'"/>
    </xsl:call-template>
    
   </xsl:element>
  </xsl:if>
	</xsl:template>
 
</xsl:stylesheet>
