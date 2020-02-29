<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" version="1.0">

<xsl:output method="html" omit-xml-declaration="yes" encoding="utf-8" doctype-public="-//W3C//DTD HTML 4.0//EN" doctype-system="http://www.w3.org/TR/html4/strict.dtd"/>

      
     <xsl:template match="/">
      <!--xsl:result-document href="xmldb:exist://admin:jeanluc23@45.56.98.26:8080/exist/xmlrpc/db/madrid/csv/people.html"-->
      <html>
      <head>
          <style>
body {font-family: helvetica,arial,sans-serif;font-size:80%}
h1   {color: black;font-family: helvetica,arial,sans-serif;font-size:90%}
#snippetinfo    {color: gray;font-size:70%}
</style>
      </head>
            <body>
         <xsl:apply-templates/>
      </body>
        </html>
        <!--/xsl:result-document-->
   </xsl:template>
<xsl:variable name="bibliography" select="doc('xmldb:exist://admin:jeanluc23@45.56.98.26:8080/exist/xmlrpc/db/madrid/xml/list-of-works-people.xml')"/>
<xsl:variable name="placeography" select="doc('xmldb:exist://admin:jeanluc23@45.56.98.26:8080/exist/xmlrpc/db/madrid/xml/tds-placeography.xml')"/>

<xsl:variable name="snippets" select="doc('xmldb:exist://admin:jeanluc23@45.56.98.26:8080/exist/xmlrpc/db/madrid/xml/BIBLIOGRAPHY-BIBLIO.xml')"/>
  <xsl:key name="workref" match="//tei:listBibl/tei:bibl" use="@xml:id"/>
  <xsl:key name="bookref" match="//tei:listBibl/tei:bibl/bibl" use="@xml:id"/>


 <xsl:template match="//tei:listBibl/tei:bibl">
    <xsl:variable name="workref">
                        <xsl:value-of select="@xml:id"/>
                    </xsl:variable>
<xsl:if test="@xml:id !='' and @xml:id !='NULL' and @xml:id !='OBRANEEDSOBRA' and @xml:id !='OBRA?'">

 <hr/>
 </xsl:if>
        <a name="{$workref}">
 
<h1>
                        <xsl:if test="tei:title != ''">
                         <i>
                            <xsl:value-of select="tei:title/text()"/>
                            </i>
                        </xsl:if>
                    </h1>

        </a>



<xsl:if test="tei:name[@type ='workauthor'] != ''">
           
           
                <xsl:value-of select="tei:name[@type ='workauthor']"/> <br/>
</xsl:if>

<xsl:if test="tei:country != ''">
 <xsl:variable name="workcountry" select="tei:country"/>
   <xsl:value-of select="$placeography//tei:place[@xml:id=$workcountry]/tei:name"/>
  
   <br/>
            
</xsl:if>

<xsl:if test="tei:note[@type='worktype'] != ''">

<xsl:value-of select="replace(tei:note[@type ='worktype'],',',', ')"/>
<br/>
</xsl:if>

<!--BIBLIOGRAPHY AND SNIPPETS BEGIN-->
<br/>
        <br/>CITAS INTERTEXTUALES:


<xsl:for-each select="tei:bibl">
 <xsl:variable name="biblref" select="@xml:id"/>
  
<!--xsl:if test="tei:bibl/@xml:id=$biblref"-->
<br/>
<!--XPATH SELECTS SIBLING FIELD NODE VALUE USING WHERE STATEMENT-->
<xsl:for-each select="$bibliography//tei:listBibl/tei:bibl[normalize-space(tei:field[@name='workref'])=$biblref]/tei:field[@name='workname']">
<i>
                    <xsl:value-of select="normalize-space()"/>
                </i> </xsl:for-each>(<xsl:value-of select="replace($biblref,'OBRA','')"/>)
<ul>
                <xsl:variable name="workref1" select="concat('-',$workref)"/>
                <xsl:variable name="workref1b" select="concat('-',$workref,'_')"/>
                <xsl:variable name="workrefmid" select="concat('_',$workref,'_')"/>
                <xsl:variable name="workrefx" select="concat('_',$workref)"/>
                <xsl:for-each select="$snippets//tei:bibl[contains(@xml:id,$biblref)]/tei:interp[contains(@xml:id,$biblref) and (ends-with(@xml:id,$workrefx) or contains(@xml:id,$workrefmid) or  contains(@xml:id,$workref1b) or ends-with(@xml:id,$workref1))]">
   <li>
                        <xsl:value-of select="text()"/>   <b>
                            <xsl:value-of select="tei:hi"/>
                        </b>  <xsl:value-of select="text()[2]"/> <br/>
                        <span id="snippetinfo">
                            <b>
                                <xsl:value-of select="@ana"/>:</b> apartado  <xsl:value-of select="tokenize(@xml:id,'-')[2]"/>, párrafo  <xsl:value-of select="tokenize(@xml:id,'-')[3]"/>
                        </span>
                    </li>
</xsl:for-each>
            </ul>
<!--/xsl:if-->

</xsl:for-each>

<!--BIBLIOGRAPHY AND SNIPPETS END-->
<xsl:if test="@xml:id !='' and @xml:id !='NULL' and @xml:id !='OBRANEEDSOBRA' and @xml:id !='OBRA?'">
<br/>

<strong>Códigos:</strong> | <xsl:apply-templates select="@xml:id"/> | 

<xsl:variable name="workwikiID">
                        <xsl:value-of select="tei:idno[@type='workwikiID']"/>
                    </xsl:variable>
<xsl:if test="tei:idno[@type='workwikiID'] != ''">
  Wikidata: <a href="https://www.wikidata.org/wiki/{$workwikiID}" target="new">
                <xsl:apply-templates select="$workwikiID"/>
            </a> | 
</xsl:if>

</xsl:if>



 </xsl:template>
      
      
          
</xsl:stylesheet>