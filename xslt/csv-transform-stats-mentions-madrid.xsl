<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:csv="csv:csv" xmlns:tei="http://www.tei-c.org/ns/1.0" version="3.0">
        <xsl:output omit-xml-declaration="yes" method="text" encoding="utf-8"/>
        <xsl:variable name="separator" select="','"/>
        <xsl:variable name="newline" select="'&#xA;'"/>
        <!--xsl:variable name="worksdoc" select="doc('xmldb:exist://admin:jeanluc23@45.56.98.26:8080/exist/xmlrpc/db/madrid/xml/TESTTENWORKS.xml')"/-->

 <!--xsl:variable name="works" select="//tei:listBibl"/-->

 

        <xsl:template match="/">
         <!--xsl:for-each select="//tei:listBibl/tei:bibl"-->

        <!--xsl:variable name="workref" select="tei:field[@name='workref']"/-->
        <!--xsl:variable name="workreflc" select="lower-case($workref)"/-->
        <!--xsl:variable name="workrefshort" select="replace($workref,'OBRA','')"/-->
        <!--xsl:variable name="workrefshortlc" select="lower-case($workrefshort)"/-->
        <!--xsl:variable name="sourcedocuri" select="concat('xmldb:exist://admin:jeanluc23@45.56.98.26:8080/exist/xmlrpc/db/madrid/xml/',$workrefshortlc,'places.xml')"/-->
        
            <!--xsl:result-document href="xmldb:exist://admin:jeanluc23@45.56.98.26:8080/exist/xmlrpc/db/madrid/csv/stats-{$workreflc}.csv"-->
             <xsl:result-document href="xmldb:exist://admin:jeanluc23@45.56.98.26:8080/exist/xmlrpc/db/madrid/csv/stats-placename-madrid.csv">
            
           
                <xsl:text>obra</xsl:text>
                <xsl:value-of select="$separator"/>
                 <xsl:text>menciones</xsl:text>
                 <!-- <xsl:value-of select="$separator"/>
                <xsl:text>palabras</xsl:text>-->
                <xsl:value-of select="$newline"/>
                
<xsl:for-each select="//tei:bibl">

 <xsl:variable name="obraref">
                        <xsl:value-of select="@xml:id"/>
                    </xsl:variable>
                    <xsl:value-of select="$obraref"/>
                    <xsl:value-of select="$separator"/>
                <xsl:variable name="numplaces">
                        <xsl:value-of select=".//tei:interp"/>
                    </xsl:variable>
                    <xsl:value-of select="$numplaces"/>
                    <xsl:value-of select="$newline"/>
                </xsl:for-each>
            
               
                 
            </xsl:result-document> 
        </xsl:template>
        
</xsl:stylesheet>