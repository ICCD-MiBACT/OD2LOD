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
  xmlns:foaf="http://xmlns.com/foaf/0.1/"
  xmlns:arco="https://w3id.org/arco/ontology/arco/"
  exclude-result-prefixes="fn">
  
 <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

 <!-- 
 
 /scheda_RA/csm_def/ser_ra => /record/metadata/schede/RA/ser_ra
 <ser_ra xmlns:xw="http://www.3di.it/ns/xw-200303121136" xml:space="preserve">CRV-RA_0010664</ser_ra>
 
  => https://beniculturali.regione.veneto.it/xway-front/application/crv/engine/crv.jsp?verbo=queryplain&view=@completa&query=(%5bser_gen%5d=%22CRV-RA_0010664%22)

  NB: negli xpath la / non è efficace perché la trasformazione lavora su element e non document
  
  NOTA: ci sono casi in cui RV/RSE esprime una relazione che sarebbe papabile per istanziare una RelatedWorkSituation (arco.xslt 29788) ma arco-fn:related-property non è efficace e l'omissione passa inosservata 

 -->
  
 <xsl:template match="scheda_RA">
  <rdf:RDF 
   xml:base="https://w3id.org/arco/resource/Veneto/"
   xmlns="https://w3id.org/arco/resource/"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
   xmlns:foaf="http://xmlns.com/foaf/0.1/"
   xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   >  
   <xsl:element name="rdf:Description">
    <xsl:attribute name="rdf:about">ArchaeologicalProperty/<xsl:value-of select="csm_def/AC/ACC"/></xsl:attribute>
    <xsl:for-each select="csm_def/DO/FTA/FTA_IMG/*[@agent.meta]">
     <xsl:element name="foaf:depiction">
      <xsl:attribute name="rdf:resource"><xsl:value-of select="concat('https://dati.beniculturali.it/catalogo/regione-veneto',substring-after(@name,'crv_back-RA'))"/></xsl:attribute>
     </xsl:element>
    </xsl:for-each>		
   </xsl:element>
  </rdf:RDF>
 </xsl:template>
 
</xsl:stylesheet>
