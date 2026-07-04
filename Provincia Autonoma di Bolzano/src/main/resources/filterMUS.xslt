<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xf="http://www.w3.org/2005/xpath-functions">
 <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no" omit-xml-declaration="yes"/>
 
 <xsl:param name="json"/>
 <!--
 <xsl:variable name="mus" select="json-to-xml(unparsed-text($json))"/>
 -->
 <xsl:variable name="mus" select="json-to-xml($json)"/>

	<xsl:template match="* | @* | text() | comment()" name="copy">
		<xsl:copy><xsl:apply-templates select="* | @* | text() | comment()"/></xsl:copy>
	</xsl:template>
 
 <xsl:template priority="2" match="*/text()[../*]"/>
 
 <xsl:template name="lang-elem">
  <xsl:param name="values"/>
  <xsl:param name="name"/>
  <xsl:param name="lang" select="'it-IT'"/>
  <xsl:if test="count($values)&gt;0">
   <xsl:variable name="v">
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
   </xsl:variable>
   <xsl:element name="cell"><xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
    <xsl:value-of select="$v"/>
   </xsl:element>
  </xsl:if>
 </xsl:template>
 
	<xsl:template priority="2" match="record">

   <xsl:value-of select="'&#xa;'"/><!--
	 	<xsl:call-template name="copy"/> -->
   <xsl:variable name="code" select="institution.name/institution_code"/>
   <xsl:element name="row">
    <xsl:element name="cell"><xsl:attribute name="name">modification</xsl:attribute>
     <xsl:value-of select="@modification"/>
    </xsl:element>
    <xsl:element name="cell"><xsl:attribute name="name">priref</xsl:attribute>
     <xsl:value-of select="@priref"/>
    </xsl:element>
    <xsl:element name="cell"><xsl:attribute name="name">MUS</xsl:attribute>
     <xsl:value-of select="$code"/>
    </xsl:element>
    
    <xsl:call-template name="lang-elem">
     <xsl:with-param name="values" select="institution.name/name/value[string-length(normalize-space())&gt;0]"/>
     <xsl:with-param name="name" select="'BEZEICHNUNG_I'"/>
    </xsl:call-template>
    <xsl:call-template name="lang-elem">
     <xsl:with-param name="values" select="institution.name/name/value[string-length(normalize-space())&gt;0]"/>
     <xsl:with-param name="name" select="'BEZEICHNUNG_D'"/>
     <xsl:with-param name="lang" select="'de-DE'"/>
    </xsl:call-template>

    <xsl:call-template name="lang-elem">
     <xsl:with-param name="values" select="institution.name/Address/address/value[string-length(normalize-space())&gt;0]"/>
     <xsl:with-param name="name" select="'ADRESSE_I'"/>
    </xsl:call-template>
    <xsl:call-template name="lang-elem">
     <xsl:with-param name="values" select="institution.name/Address/address/value[string-length(normalize-space())&gt;0]"/>
     <xsl:with-param name="name" select="'ADRESSE_D'"/>
     <xsl:with-param name="lang" select="'de-DE'"/>
    </xsl:call-template>
    
    <xsl:call-template name="lang-elem">
     <xsl:with-param name="values" select="institution.name/Address/address.place/value[string-length(normalize-space())&gt;0]"/>
     <xsl:with-param name="name" select="'ORTSCHAFT_I'"/>
    </xsl:call-template>
    <xsl:call-template name="lang-elem">
     <xsl:with-param name="values" select="institution.name/Address/address.place/value[string-length(normalize-space())&gt;0]"/>
     <xsl:with-param name="name" select="'ORTSCHAFT_D'"/>
     <xsl:with-param name="lang" select="'de-DE'"/>
    </xsl:call-template>
    
    <xsl:for-each select="institution.name/Internet_address/internet_address[string-length(normalize-space())&gt;0][1]"><!-- "CFW" maxOccurs="1" -->
     <xsl:element name="cell"><xsl:attribute name="name">HOMEPAGE_I</xsl:attribute>
      <xsl:value-of select="."/>
     </xsl:element>
    </xsl:for-each>

    <xsl:for-each select="institution.name/e-mail[string-length(normalize-space())&gt;0][1]">
     <xsl:element name="cell"><xsl:attribute name="name">EMAIL_I</xsl:attribute>
      <xsl:value-of select="."/>
     </xsl:element>
    </xsl:for-each>

    <xsl:for-each select="institution.name/phone[string-length(normalize-space())&gt;0][1]">
     <xsl:element name="cell"><xsl:attribute name="name">TELEFON</xsl:attribute>
      <xsl:value-of select="."/>
     </xsl:element>
    </xsl:for-each>
    <xsl:for-each select="institution.name/phone[string-length(normalize-space())&gt;0][2]">
     <xsl:element name="cell"><xsl:attribute name="name">TELEFON 2</xsl:attribute>
      <xsl:value-of select="."/>
     </xsl:element>
    </xsl:for-each>
    
    <xsl:variable name="xd" select="$mus/xf:map/xf:array/xf:map/xf:map[@key='elements'][xf:map[@key='mus'][xf:string[@key='value']=$code]][1]"/>
    <xsl:if test="count($xd)=1">
    
    <xsl:variable name="description" select="$xd/xf:map[@key='description']/xf:string[@key='value']"/>
    <xsl:if test="string-length($description)">
     <xsl:element name="cell"><xsl:attribute name="name">BESCHREIBUNG_I</xsl:attribute>
      <xsl:value-of select="$description"/>
     </xsl:element>
    </xsl:if>
    
    <xsl:variable name="xgeo" select="$xd/xf:map[@key='geocoordinate_x']/xf:string[@key='value']"/>
    <xsl:if test="string-length($xgeo)">
     <xsl:element name="cell"><xsl:attribute name="name">GEOKOORDINATE_X</xsl:attribute>
      <xsl:value-of select="$xgeo"/>
     </xsl:element>
    </xsl:if>
    <xsl:variable name="ygeo" select="$xd/xf:map[@key='geocoordinate_y']/xf:string[@key='value']"/>
    <xsl:if test="string-length($ygeo)">
     <xsl:element name="cell"><xsl:attribute name="name">GEOKOORDINATE_Y</xsl:attribute>
      <xsl:value-of select="$ygeo"/>
     </xsl:element>
    </xsl:if>
    
    <xsl:variable name="opening_hours" select="$xd/xf:map[@key='opening_hours']/xf:string[@key='value']"/>
    <xsl:if test="string-length($opening_hours)">
     <xsl:element name="cell"><xsl:attribute name="name">ÖFFNUNGSZEITEN_I</xsl:attribute>
      <xsl:value-of select="$opening_hours"/>
     </xsl:element>
    </xsl:if>
    
    <xsl:variable name="fee" select="$xd/xf:map[@key='fee']/xf:string[@key='value']"/>
    <xsl:if test="string-length($fee)">
     <xsl:element name="cell"><xsl:attribute name="name">EINTRITT_I</xsl:attribute>
      <xsl:value-of select="$fee"/>
     </xsl:element>
    </xsl:if>
    
    <xsl:variable name="main_image" select="$xd/xf:map[@key='main_image']/xf:array[@key='value']/xf:map[1]/xf:string[@key='url']"/>
    <xsl:if test="string-length($main_image)">
     <xsl:element name="cell"><xsl:attribute name="name">main_image</xsl:attribute>
      <xsl:value-of select="$main_image"/>
     </xsl:element>
    </xsl:if>
    
    </xsl:if>
    
    <xsl:element name="cell"><xsl:attribute name="name">IN</xsl:attribute>
     <xsl:value-of select="object_number"/>
    </xsl:element>
        
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
    <xsl:for-each select="(Description/description/value[string-length(normalize-space())&gt;0][@lang='it-IT'][1]|
                           Description/description/value[string-length(normalize-space())&gt;0][@invariant='true'][1])[1]">
     <xsl:element name="cell"><xsl:attribute name="name">BE_it</xsl:attribute>
      <xsl:value-of select="."/>
     </xsl:element>
    </xsl:for-each>
    <xsl:for-each select="(Historical_critical_notes/historical_critical_notes/value[string-length(normalize-space())&gt;0][@lang='it-IT'][1]|
                           Historical_critical_notes/historical_critical_notes/value[string-length(normalize-space())&gt;0][@invariant='true'][1])[1]">
     <xsl:element name="cell"><xsl:attribute name="name">B3_it</xsl:attribute>
      <xsl:value-of select="."/>
     </xsl:element>
    </xsl:for-each>
    <xsl:for-each select="Collection">
     <xsl:for-each select="(collection.name/collection/value[string-length(normalize-space())&gt;0][@lang='it-IT'][1]|
                            collection.name/collection/value[string-length(normalize-space())&gt;0][@invariant='true'][1])[1]">
      <xsl:element name="cell"><xsl:attribute name="name">CL_it</xsl:attribute>
       <xsl:value-of select="."/>
      </xsl:element>
     </xsl:for-each>
    </xsl:for-each>
    
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
   </xsl:element>

	</xsl:template>
 
</xsl:stylesheet>
