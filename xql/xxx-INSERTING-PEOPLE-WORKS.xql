xquery version "3.1";
declare namespace xsi="http://www.w3.org/2001/XMLSchema-instance";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace xs = "http://www.w3.org/2001/XMLSchema";
declare option exist:serialize 'method=xml';

(: Log in :)
let $log-in := xmldb:login("/db", "admin", "jeanluc23")

(: Get source and target documents :)
let $tdsdoc := doc('/db/madrid/xml/tds-placeography.xml')/* 
let $histpeopledoc := doc('http://45.56.98.26/tds-data/places_country_people_hist.xml')
let $mythpeopledoc := doc('http://45.56.98.26/tds-data/places_country_people_myth.xml')
let $workpeopledoc := doc('http://45.56.98.26/tds-data/places_country_obras.xml')




for $row in ($histpeopledoc,$mythpeopledoc,$workpeopledoc)//row
let $histplaceref := $row//field[@name='placeref']/text()
let $histpeople := $row//field[@name='histpeoplenames']/text()
let $histnames := $row//field[@name='histpeoplenames']/text()
let $mythplaceref := $row//field[@name='placeref']/text()
let $mythpeople := $row//field[@name='mythpeoplenames']/text()
let $mythnames := $row//field[@name='mythpeoplenames']/text()
let $workplaceref := $row//field[@name='placeref']/text()
let $workpeople := $row//field[@name='worknames']/text()
let $worknames := $row//field[@name='worknames']/text()
(:where $tdsdoc//tei:place[@xml:id] eq $placeref and $tdsdoc//tei:bibl[@xml:id] eq $snippetbookref:)
for $place in $tdsdoc//tei:listPlace/tei:place

return
    if(exists($histnames)) then 
        if (exists ($place[@xml:id eq $histplaceref]/tei:note[@type eq "histnames"])) then
            update replace $place[@xml:id eq $histplaceref]/tei:note[@type eq "histnames"] with <note type="histnames" xmlns="http://www.tei-c.org/ns/1.0">{$histnames}</note>
            else
        update insert <note type="histnames" xmlns="http://www.tei-c.org/ns/1.0">{$histnames}</note>
     into  $place[@xml:id eq $histplaceref]
     
     else if (exists($mythnames)) then 
          if (exists ($place[@xml:id eq $mythplaceref]/tei:note[@type eq "mythnames"])) then
            update replace $place[@xml:id eq $mythplaceref]/tei:note[@type eq "mythnames"] with <note type="mythnames" xmlns="http://www.tei-c.org/ns/1.0">{$mythnames}</note>
            else
         update insert
     <note type="mythnames" xmlns="http://www.tei-c.org/ns/1.0">{$mythnames}</note>
     into  $place[@xml:id eq $mythplaceref]
     
     else if (exists($worknames)) then 
          if (exists ($place[@xml:id eq $workplaceref]/tei:note[@type eq "worknames"])) then
            update replace $place[@xml:id eq $workplaceref]/tei:note[@type eq "worknames"] with <note type="worknames" xmlns="http://www.tei-c.org/ns/1.0">{$worknames}</note>
            else
         update insert
     <note type="worknames" xmlns="http://www.tei-c.org/ns/1.0">{$worknames}</note>
     into  $place[@xml:id eq $workplaceref]
     else $place
   