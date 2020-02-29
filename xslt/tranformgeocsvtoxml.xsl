<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:csv="csv:csv" xmlns:tei="http://www.tei-c.org/ns/1.0" version="1.0">


transform:transform(
        (),
        doc("/db/csv-to-xml_v3.xsl"),
        <parameters>
                <param name="pathToCSV" value="sftp://readingmadrid:jeanluc23@45.56.98.26/var/www/html/readingspain.com/public_html/readingmadrid-places-geo.csv"/>
        </parameters>,
        <attributes>
                <attr name="http://saxon.sf.net/feature/initialTemplate" value="main"/>
        </attributes>,
        ()
)
</xsl:stylesheet>