<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">

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
<xsl:variable name="snippets" select="doc('xmldb:exist://admin:jeanluc23@45.56.98.26:8080/exist/xmlrpc/db/madrid/xml/PERSONOGRAPHY-BIBLIO.xml')"/>
<xsl:variable name="snippetsbooks" select="doc('xmldb:exist://admin:jeanluc23@45.56.98.26:8080/exist/xmlrpc/db/madrid/xml/BIBLIOGRAPHY-BIBLIO.xml')"/>
<xsl:variable name="obrasbyauthor" select="doc('xmldb:exist://admin:jeanluc23@45.56.98.26:8080/exist/xmlrpc/db/madrid/xml/tds-works.xml')"/>
<xsl:variable name="placeography" select="doc('xmldb:exist://admin:jeanluc23@45.56.98.26:8080/exist/xmlrpc/db/madrid/xml/tds-placeography.xml')"/>
  <xsl:key name="persref" match="//tei:person" use="@xml:id"/>
  <xsl:key name="bookref" match="//tei:person/bibl" use="@xml:id"/>


 <xsl:template match="//tei:person">
    <xsl:variable name="persref">
                        <xsl:value-of select="@xml:id"/>
                    </xsl:variable>
<xsl:if test="@xml:id !='' and @xml:id !='NULL' and @xml:id !='PERSNEEDSPERSON' and @xml:id !='PERS?'">

 <hr/>
 </xsl:if>
        <a name="{$persref}">
 <xsl:choose>
 <xsl:when test="tei:name[@type ='persfirstname'] = '' and tei:name[@type ='perslastname'] = '' and tei:name[@type ='persepithet'] = ''"> </xsl:when>
 <xsl:otherwise>
<h1>
                        <xsl:if test="tei:name[@type ='persfirstname'] != ''">
                            <xsl:value-of select="tei:name[@type ='persfirstname']"/>
                        </xsl:if>
                        <xsl:if test="tei:name[@type ='persepithet'] != ''"> "<xsl:value-of select="tei:name[@type ='persepithet']"/>"</xsl:if> <xsl:value-of select="tei:name[@type ='perslastname']"/>
                    </h1>
</xsl:otherwise>
</xsl:choose>
        </a>
<xsl:choose>
<xsl:when test="tei:name[@type ='persfirstname'] = '' and tei:name[@type ='perslastname'] = '' and tei:name[@type ='persepithet'] = ''">
<xsl:if test="tei:name[@type ='persmoniker'] != ''">
                    <h1>
                        <hi type="italic">
                            <xsl:value-of select="tei:name[@type ='persmoniker']"/>
                        </hi>
                    </h1>
                </xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="tei:name[@type ='persmoniker'] != ''">
                    <hi type="italic">
                        <xsl:value-of select="tei:name[@type ='persmoniker']"/>
                    </hi>
                </xsl:if>
</xsl:otherwise>
</xsl:choose>


<xsl:if test="tei:note[@type ='persoccupation'] != ''">
          
            <hi type="italic">
                <xsl:value-of select="tei:note[@type ='persoccupation']"/> </hi>  <br/>
</xsl:if>
<xsl:if test="tei:sex != ''">
          
            <xsl:value-of select="tei:sex"/>  <br/>
</xsl:if>

<xsl:if test="tei:country != ''">
 <!-- <xsl:for-each select="key('persref',tei:country)">-->
 <xsl:variable name="perscountry" select="tei:country"/>
   <xsl:value-of select="$placeography//tei:place[@xml:id=$perscountry]/tei:name"/>
  <br/>
  <!-- </xsl:for-each>-->
</xsl:if>
<xsl:if test="tei:note[@type ='perstype'] != ''">

<xsl:value-of select="replace(tei:note[@type ='perstype'],',',', ')"/>
<br/>
</xsl:if>

<!--BIBLIOGRAPHY AND SNIPPETS BEGIN-->
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
                <xsl:variable name="persref1" select="concat('-',$persref)"/>
                <xsl:variable name="persref1b" select="concat('-',$persref,'_')"/>
                <xsl:variable name="persrefmid" select="concat('_',$persref,'_')"/>
                <xsl:variable name="persrefx" select="concat('_',$persref)"/>
                <xsl:for-each select="$snippets//tei:bibl[contains(@xml:id,$biblref)]/tei:interp[contains(@xml:id,$biblref) and (ends-with(@xml:id,$persrefx) or contains(@xml:id,$persrefmid) or  contains(@xml:id,$persref1b) or ends-with(@xml:id,$persref1))]">
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


    

<!--XPATH SELECTS SIBLING FIELD NODE VALUE USING WHERE STATEMENT-->
<xsl:for-each select="$obrasbyauthor//tei:listBibl/tei:bibl[tei:name[@type='workauthor'and @ref=$persref]]">
<xsl:variable name="workref" select="@xml:id"/>
<xsl:variable name="worktitle" select="tei:title"/>

                  
            
<ul>
                 <xsl:value-of select="$worktitle"/> 
               <xsl:for-each select="$snippetsbooks//tei:bibl[contains(@xml:id,$biblref)]/tei:interp[contains(@xml:id,$biblref) and  contains(@xml:id,$workref)]">
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
</xsl:for-each>



<!--BIBLIOGRAPHY AND SNIPPETS END-->
<xsl:if test="@xml:id !='' and @xml:id !='NULL' and @xml:id !='PERSNEEDSPERSON' and @xml:id !='PERS?'">
<br/>

<strong>Códigos:</strong> | <xsl:apply-templates select="@xml:id"/> | 

<xsl:variable name="wikidataid">
                        <xsl:value-of select="tei:idno[@type='wikidataid']"/>
                    </xsl:variable>
<xsl:if test="tei:idno[@type='wikidataid'] != ''">
  Wikidata: <a href="https://www.wikidata.org/wiki/{$wikidataid}" target="new">
                <xsl:apply-templates select="$wikidataid"/>
            </a> |
</xsl:if>
</xsl:if>



 </xsl:template>
      
      
          
</xsl:stylesheet>