<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="fn"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xs fn">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="pathToCSV" select="'file:./inputTable.csv'"/>
  <!--
        <xsl:function name="fn:getTokens" as="xs:string+">
                <xsl:param name="str" as="xs:string"/>
                <xsl:analyze-string select="concat($str, ',')" regex="((&quot;[^&quot;]*&quot;)+|[^,]*),">
                        <xsl:matching-substring>
                                <xsl:sequence
                                        select="replace(regex-group(1), &quot;^&quot;&quot;|&quot;&quot;$|(&quot;&quot;)&quot;&quot;&quot;, &quot;$1&quot;)"
                                />
                        </xsl:matching-substring>
                </xsl:analyze-string>
        </xsl:function>
  -->
  <xsl:function name="fn:getTokens" as="xs:string+">
   <xsl:param name="str" as="xs:string"/>
   <xsl:analyze-string select="concat($str, ',')" regex='(("[^"]*")+|[^,]*),'>
    <xsl:matching-substring>
     <xsl:sequence select='replace(regex-group(1), "^""|""$|("")""", "$1")'/>
    </xsl:matching-substring>
   </xsl:analyze-string>
  </xsl:function>
 
  <xsl:template match="/" name="main">
  
   <xsl:choose>
	  	<xsl:when test="unparsed-text-available($pathToCSV)">
			  <xsl:variable name="csv" select="unparsed-text($pathToCSV)"/>
     <!--<xsl:variable name="lines" select="tokenize($csv, 'eol\n')" as="xs:string+"/>-->
	 <xsl:variable name="lines" select="tokenize($csv, '\n')" as="xs:string+"/>
     <xsl:variable name="elemNames" select="fn:getTokens($lines[1])" as="xs:string+"/>
     <root>
      <xsl:for-each select="$lines[position() &gt; 1]">
       <row>
        <xsl:variable name="lineItems" select="fn:getTokens(.)" as="xs:string+"/>
        <xsl:for-each select="$elemNames">
         <xsl:variable name="pos" select="position()"/>
         <xsl:variable name="value" select="$lineItems[$pos]"/>
         <xsl:if test="string-length($value)">
          <elem name="{.}"><xsl:value-of select="$value"/></elem>
         </xsl:if> 
        </xsl:for-each>
       </row>
      </xsl:for-each>
     </root>
    </xsl:when>
  		<xsl:otherwise>
			  <xsl:text>Cannot locate : </xsl:text><xsl:value-of select="$pathToCSV"/>
		  </xsl:otherwise>
   </xsl:choose>

  </xsl:template>
  
</xsl:stylesheet>
