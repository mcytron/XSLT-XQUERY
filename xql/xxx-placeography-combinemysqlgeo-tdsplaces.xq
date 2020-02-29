xquery version "3.1";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace xs = "http://www.w3.org/2001/XMLSchema";
declare option exist:serialize 'method=xml';

(: Log in :)
let $log-in := xmldb:login("/db", "admin", "jeanluc23")

(: Get source and target documents :)
let $exportedmysqldoc := doc('http://45.56.98.26/readingmadrid-places-geo.xml')//place
let $tdsdoc := doc('/db/madrid/xml/tds-placeography.xml')/* 

(: Add place names by placerefs :)
for $place in $exportedmysqldoc
let $placeref := normalize-space($place/placeref)
let $placepoint := normalize-space($place/placepoint)
(:let $placepath := normalize-space($place/placepath) :)
return 
   if ($placepoint eq '\N') then ()
   else
       (if (exists($tdsdoc//tei:place[@xml:id eq $placeref]//tei:location))  then
           
   update replace 
   $tdsdoc//tei:place[@xml:id eq $placeref]/tei:location/tei:geo
   with <geo xmlns="http://www.tei-c.org/ns/1.0">{replace(replace($placepoint,'POINT\(',''),'\)','')}</geo> 
   
   
  else
      
  update insert 
 <location xmlns="http://www.tei-c.org/ns/1.0"><geo>{replace(replace($placepoint,'POINT\(',''),'\)','')}</geo></location>
  into $tdsdoc//tei:place[@xml:id eq $placeref] 
   
(:, 

   if (exists($tdsdoc//tei:place[@xml:id eq $placeref]//tei:note[@type eq 'placepath'])) then
   update replace 
   $tdsdoc//tei:place[@xml:id eq $placeref]/tei:note[@type eq $placepath]
   with <note xmlns="http://www.tei-c.org/ns/1.0" type="placepath">{$placepath})</note> 

 else
  update insert 
 <note xmlns="http://www.tei-c.org/ns/1.0" type="placepath">{$placepath})</note>
 into $tdsdoc//tei:place[@xml:id eq $placeref]:) 
 
 ) 