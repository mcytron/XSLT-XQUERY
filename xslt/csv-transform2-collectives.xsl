<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:csv="csv:csv" xmlns:tei="http://www.tei-c.org/ns/1.0" version="1.0">
        <xsl:output omit-xml-declaration="yes" method="text" encoding="utf-8"/>
        <xsl:variable name="separator" select="','"/>
        <xsl:variable name="newline" select="'&#xA;'"/>
        <xsl:template match="/">
            <xsl:result-document href="xmldb:exist://admin:jeanluc23@45.56.98.26:8080/exist/xmlrpc/db/madrid/csv/collectives-obratds.csv">
            <!--xsl:result-document href="sftp://readingmadrid:jeanluc23@45.56.98.26/home/readingmadrid/ftp/files/places-obratds.csv"-->
            <!--xmldb:exist://admin:jeanluc23@45.56.98.26:8080/exist/xmlrpc/db/madrid/csv/places-obratds.csv-->
            <!--xmldb:exist:///admin:jeanluc23@db/madrid/xml/places.csv-->
            <!--sftp://readingmadrid:jeanluc23@45.56.98.26/home/readingmadrid/ftp/files/places.csv-->
                <xsl:text>colref</xsl:text>
                <xsl:value-of select="$separator"/>
                 <xsl:text>colworks</xsl:text>
                <xsl:value-of select="$newline"/>
                <xsl:for-each select="//tei:personGrp">
                    <xsl:variable name="collective">
                        <xsl:value-of select="@xml:id"/>
                    </xsl:variable>
                    <xsl:value-of select="$collective"/>
                    <xsl:value-of select="$separator"/>
                    <xsl:text>OBRATDS</xsl:text>
                    <xsl:value-of select="$newline"/>
                </xsl:for-each>
             
            </xsl:result-document>
        </xsl:template>
</xsl:stylesheet>