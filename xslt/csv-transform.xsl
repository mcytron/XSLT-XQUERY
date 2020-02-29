<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" version="1.0">
<xsl:output method="text" omit-xml-declaration="yes"/>
<xsl:variable name="newline" select="'&#xA;'"/>
  <xsl:template match="//tei:place">
    <xsl:variable name="places">
    <xsl:value-of select="@xml:id"/>
    </xsl:variable>
     <xsl:value-of select="$places"/>
    <xsl:value-of select="$newline"/>
  </xsl:template>
</xsl:stylesheet>