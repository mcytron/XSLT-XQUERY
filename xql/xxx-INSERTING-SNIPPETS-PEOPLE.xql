xquery version "3.1";
declare namespace xsi="http://www.w3.org/2001/XMLSchema-instance";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace xs = "http://www.w3.org/2001/XMLSchema";
declare option exist:serialize 'method=xml';

(: Log in :)
let $log-in := xmldb:login("/db", "admin", "jeanluc23")

(: Get source and target documents :)
let $tdsdoc := doc('/db/madrid/xml/tds-placeography.xml')/* 
let $snippetsdoc := doc('/db/madrid/xml/PLACEOGRAPHY-BIBLIO.xml')//tei:interp


(: loop through snippets in TEST-PLACEOGRAPHY-BIBLIO.xml :)
for $snippet in $snippetsdoc 
let $snippetref:= $snippet/@xml:id
let $snippetbookref := tokenize($snippet/@xml:id,'-')[1]
let $snippetplaceref := tokenize($snippet/@xml:id,'-')[5]

(: loop through places in placeography :)

(:where $tdsdoc//tei:place[@xml:id] eq $placeref and $tdsdoc//tei:bibl[@xml:id] eq $snippetbookref:)
for $place in $tdsdoc//tei:listPlace/tei:place

(: check for space separated placerefs :)
let $placerefstart := concat($place/@xml:id, '_')
let $placerefend := concat( '_',$place/@xml:id)
let $placerefmiddle := concat( '_',$place/@xml:id,'_')
where 

($snippetplaceref eq $place/@xml:id) or ((starts-with($snippetplaceref,$placerefstart)) or (ends-with($snippetplaceref,$placerefend)) or (contains($snippetplaceref,$placerefmiddle)))

(: loop through books adding book if not present and inserting snippets by place :)
for $book in $place/tei:bibl
return
    if(exists($tdsdoc//tei:interp[@xml:id eq $snippetref]))
    then
    update replace $tdsdoc//tei:interp[@xml:id eq $snippetref] with $snippet
    
    else
    update insert $snippet
    

   into  $book[@xml:id eq $snippetbookref]
