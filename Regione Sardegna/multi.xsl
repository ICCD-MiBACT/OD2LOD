<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 
 <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>

	<xsl:template match="@* | node()">
		<xsl:copy><xsl:apply-templates select="@* | node()"/></xsl:copy>
	</xsl:template>
 
 <xsl:variable name="splitter">// </xsl:variable>
 
 <xsl:template match="*[ends-with(.,$splitter)]">
  <xsl:copy>
   <xsl:value-of select="substring(.,1,string-length(.) - string-length($splitter))"/>
  </xsl:copy>
 </xsl:template>
 
 <xsl:template match="CMPD[contains(.,$splitter)]">
  <xsl:variable name="tokens" select="tokenize(.,$splitter)"/>
  <xsl:copy>
   <xsl:value-of select="$tokens[last()]"/>
  </xsl:copy>
 </xsl:template>

 <xsl:template match="CMPN[contains(.,$splitter)]">
  <xsl:variable name="tokens" select="tokenize(.,$splitter)"/>
  <xsl:for-each select="$tokens[string-length(normalize-space())>0]">
   <xsl:element name="CMPN">
    <xsl:value-of select="."/>
   </xsl:element>
  </xsl:for-each>
 </xsl:template>
 
 <!-- manca STCR (riferimento alla parte) ? -->
 <xsl:template match="STC[STCC[contains(.,$splitter)]]">
  <xsl:variable name="tokens" select="tokenize(STCC,$splitter)"/>
  <xsl:for-each select="$tokens[string-length(normalize-space())>0]">
   <xsl:element name="STC">
    <xsl:element name="STCC">
     <xsl:value-of select="."/>
    </xsl:element>
   </xsl:element>
  </xsl:for-each>
 </xsl:template>
 
 <xsl:template match="RE[REV[REVS[contains(.,$splitter)]]][REL[RELS[contains(.,$splitter)]]][REN[RENR[contains(.,$splitter)]]]">
  <!-- minOccurs="1" -->
  <xsl:variable name="revTokens" select="tokenize(REV/REVS,$splitter)"/>
  <xsl:variable name="relTokens" select="tokenize(REL/RELS,$splitter)"/>
  <xsl:variable name="renTokens" select="tokenize(REN/RENR,$splitter)"/>
  <!-- minOccurs="0" -->
  <xsl:variable name="revxTokens" select="tokenize(REV/REVI,$splitter)"/>
  <xsl:variable name="relxTokens" select="tokenize(REL/RELI,$splitter)"/>
  <xsl:variable name="renxTokens" select="tokenize(REN/RENS,$splitter)"/>
  <xsl:choose>
   <xsl:when test="count($revTokens)=count($relTokens) and count($revTokens)=count($renTokens) and 
                   (count($revxTokens)=0 or count($revTokens)=count($revxTokens)) and
                   (count($relxTokens)=0 or count($relTokens)=count($relxTokens)) and
                   (count($renxTokens)=0 or count($renTokens)=count($renxTokens)) ">
    <xsl:for-each select="$renTokens">
     <xsl:variable name="position" select="position()"/>
     <xsl:element name="RE">
      <xsl:element name="REN">
       <xsl:element name="RENR">
        <xsl:value-of select="."/>
       </xsl:element>
       <xsl:if test="count($renxTokens)>0">
        <xsl:element name="RENS">
         <xsl:value-of select="$renxTokens[$position=position()]"/>
        </xsl:element>
       </xsl:if>
      </xsl:element>
      <xsl:element name="REV">
       <xsl:element name="REVS">
        <xsl:value-of select="$revTokens[$position=position()]"/>
       </xsl:element>
       <xsl:if test="count($revxTokens)>0">
        <xsl:element name="REVI">
         <xsl:value-of select="$revxTokens[$position=position()]"/>
        </xsl:element>
       </xsl:if>      
      </xsl:element>
      <xsl:element name="REL">
       <xsl:element name="RELS">
        <xsl:value-of select="$relTokens[$position=position()]"/>
       </xsl:element>
       <xsl:if test="count($relxTokens)>0">
        <xsl:element name="RELI">
         <xsl:value-of select="$relxTokens[$position=position()]"/>
        </xsl:element>
       </xsl:if>      
      </xsl:element>
     </xsl:element>
    </xsl:for-each>
   </xsl:when>
   <xsl:otherwise>
    <xsl:copy><xsl:apply-templates select="@* | node()"/></xsl:copy>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>
 
</xsl:stylesheet>