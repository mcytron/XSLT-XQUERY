xquery version "3.1";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace xs = "http://www.w3.org/2001/XMLSchema";
declare option exist:serialize 'method=xml';


(: Log in :)
let $log-in := xmldb:login("/db", "admin", "jeanluc23")

(: 1. INSERT BOOKS INTO XML FILE :)
(: Get source and target documents :)
let $corpus1 := collection('/db/madrid/corpus')
let $corpus2 := collection('/db/madrid/corpus2')
let $corpus1places := $corpus1//tei:placeName[@ref='#PLACEMADRID']
let $corpus2places := $corpus2//tei:placeName[@ref='#PLACEMADRID']

let $madridplacestatsdoc := doc('/db/madrid/xml/stats-madrid.xml')

 (: Loop through books :)
 for $obra in $corpus1//tei:body
 let $obraref :=  replace(replace(document-uri( root( $obra ) ),'/db/madrid/corpus/',''),'-TEI.xml','')
  let $placecount :=  count($obra//tei:placeName[@ref='#PLACEMADRID'])


return 
   
     update insert <bibl xmlns="http://www.tei-c.org/ns/1.0" xml:id="{$obraref}"><interp xmlns="http://www.tei-c.org/ns/1.0">{$placecount}</interp></bibl> into $madridplacestatsdoc//tei:listBibl,
     
     
let $madridplacestatsdoc := doc('/db/madrid/xml/stats-madrid.xml')
let $corpus2 := collection('/db/madrid/corpus2')
let $corpus2places := $corpus2//tei:placeName[@ref='#PLACEMADRID']

 for $obra2 in $corpus2//tei:body
 let $obraref :=  replace(replace(document-uri( root( $obra2 ) ),'/db/madrid/corpus2/',''),'-TEI.xml','')
  let $placecount :=  count($obra2//tei:placeName[@ref='#PLACEMADRID'])


return 
   
     update insert <bibl xmlns="http://www.tei-c.org/ns/1.0" xml:id="{$obraref}"><interp xmlns="http://www.tei-c.org/ns/1.0">{$placecount}</interp></bibl> into $madridplacestatsdoc//tei:listBibl