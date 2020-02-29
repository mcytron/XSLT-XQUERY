<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="3.0">
  
  <xsl:template xmlns="http://www.tei-c.org/ns/1.0" match="/">
  <p><xsl:apply-templates select="//placeName"/>:::</p>
  </xsl:template>
</xsl:stylesheet>