<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:h="http://www.w3.org/HTML/1998/html4"
  xmlns:xw="http://www.3di.it/ns/xw-200203121136"
  exclude-result-prefixes="fn xs xsd xsi h xw">
  
 <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
 <xsl:param name="datestamp" select="'2020-05-07T00:00:00Z'"/>
 
 <!--
  <scheda_xy> ...
   <?xw-meta DbmsVer="25.9.3" OrgNam="Regione Veneto" OrgVer="1.0" Classif="1.0" ManGest="1.0" ManTec="0.0.4" InsUser="l" InsTime="20210310170223" ModUser="xw.14879.fca" ModTime="20210406132020"?>
 
  => header/datestamp 2011-11-20T09:42:36Z
   
 -->

 <xsl:template match="/">
  <xsl:apply-templates select="/*/*"/>
 </xsl:template>
 <xsl:template match="/*/*"><!--  scheda_XY -->
  <record>
   <header>
    <xsl:element name="datestamp">
     <xsl:choose>
      <xsl:when test="processing-instruction('xw-meta')"><xsl:variable name="quote">"</xsl:variable>
       <xsl:variable name="ModTime" select="substring-before(substring-after(processing-instruction('xw-meta'),concat('ModTime=',$quote)), $quote)" />
       <xsl:value-of select="concat(substring($ModTime,1,4),'-',substring($ModTime,5,2),'-',substring($ModTime,7,2),'T',substring($ModTime,9,2),':',substring($ModTime,11,2),':',substring($ModTime,13,2),'Z')"/>
      </xsl:when>
      <xsl:otherwise>
       <xsl:value-of select="$datestamp"/>
      </xsl:otherwise>
     </xsl:choose>
    </xsl:element>
   </header>
   <metadata>
    <schede>
     <xsl:element name="{substring-after(name(),'scheda_')}">
      <xsl:if test="name()='scheda_RA' or name()='scheda_F'"> 
       <xsl:attribute name="version">3.00</xsl:attribute>
      </xsl:if>
      <xsl:if test="not(csm_def/CD/NCT/NCTR/node())">
        <xsl:element name="CD">
         <xsl:element name="NCT">
          <xsl:element name="NCTR">05</xsl:element>
         </xsl:element>
        </xsl:element>
      </xsl:if>
      <!--
      <xsl:choose>
       <xsl:when test="csm_def/CD/NCT/NCTN"/>
       <xsl:when test="csm_def/CD/CBC"/>
       <xsl:when test="csm_def/AC/ACC"/>
       <xsl:otherwise>
       -->
        <xsl:element name="AC">
         <xsl:element name="ACC">
          <xsl:value-of select="csm_def/*[starts-with(name(),'ser_')]"/>
          <xsl:variable name="rvel" select="normalize-space(csm_def/RV/RVE/RVEL)"/>
          <xsl:if test="string-length($rvel)">
           <xsl:value-of select="concat('-', $rvel)"/> 
          </xsl:if>
         </xsl:element>
        </xsl:element>
        <!-- 
       </xsl:otherwise>
      </xsl:choose>
       -->
      <xsl:apply-templates select="csm_def/*"/>
     </xsl:element>
    </schede>
   </metadata>
  </record>
 </xsl:template>
 
 <xsl:template match="NCT/NCTN"/><!-- 
 <xsl:template match="NCT/NCTN"><xsl:copy><xsl:value-of select="normalize-space()"/></xsl:copy></xsl:template>
  -->
 <xsl:template match="RVE/RVEL"><xsl:copy><xsl:value-of select="normalize-space()"/></xsl:copy></xsl:template>
 <xsl:template match="NCT/NCTR"><xsl:copy>05</xsl:copy></xsl:template>
 <xsl:template match="*[not(node())]" priority="1"/>
 <xsl:template match="@xml:space"/>
 <xsl:template match="/*/*/csm_def/DO/FTA/FTA_IMG/*/node()"/>
 <xsl:template match="* | @* | text() | comment()">
  <xsl:copy><xsl:apply-templates select="* | @* | text() | comment()"/></xsl:copy>
 </xsl:template>

</xsl:stylesheet>