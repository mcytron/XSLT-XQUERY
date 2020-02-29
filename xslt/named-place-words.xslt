<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
      <xsl:template match="/TEI">
    <output>
      <xsl:apply-templates match="body"/>
    </output>
  </xsl:template>
    
                 <xsl:template name="get-place-name-text">
                <xsl:for-each select=".//placeName[text()]"/> 
                </xsl:template>
                   
   
</xsl:stylesheet>