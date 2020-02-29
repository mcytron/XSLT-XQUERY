xquery version "3.1";
declare namespace xsi="http://www.w3.org/2001/XMLSchema-instance";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace xs = "http://www.w3.org/2001/XMLSchema";
declare option exist:serialize 'method=xml';

(: Log in :)
let $log-in := xmldb:login("/db", "admin", "jeanluc23")

(: Get source and target documents :)
let $exportedmysqldoc := doc('http://45.56.98.26/tds-data/places_tds_mysql_export.xml')//row
let $tdsdoc := doc('/db/madrid/xml/tds-placeography.xml')/* 



(: Add place names by placerefs :)
for $row in $exportedmysqldoc
  let $placeref := normalize-space($row/field[@name eq 'placeref'])
  let $placename := normalize-space($row/field[@name eq 'placename'])
  let $placegeonamesid := normalize-space($row/field[@name eq 'placegeonamesid'])
let $placewikidataid := normalize-space($row/field[@name eq 'placewikidataid'])
let $placecontinent := normalize-space($row/field[@name eq 'placecontinent'])
let $placeosmdataid := normalize-space($row/field[@name eq 'placeosmdataid'])
let $placecountry := normalize-space($row/field[@name eq 'placecountry'])
let $placeprovince := normalize-space($row/field[@name eq 'placeprovince'])
let $placetype := normalize-space($row/field[@name eq 'placetype'])
let $placeworks := normalize-space($row/field[@name eq 'placeworks'])


(: let $placepointcoords := normalize-space($row/field[@name eq 'placepointcoords']) :)

  return 
(if (not(exists($tdsdoc//tei:place[@xml:id eq $placeref]))) then
  update insert 
 <place xmlns="http://www.tei-c.org/ns/1.0" xml:id="{$placeref}"></place>
  into $tdsdoc//tei:listPlace    
    
    else
 (if (exists($tdsdoc//tei:place[@xml:id eq $placeref]//tei:name)) then
   update replace 
   $tdsdoc//tei:place[@xml:id eq $placeref]/tei:name
   with  <name xmlns="http://www.tei-c.org/ns/1.0">{$placename}</name>
  else
  update insert 
 <name xmlns="http://www.tei-c.org/ns/1.0">{$placename}</name>
  into $tdsdoc//tei:place[@xml:id eq $placeref] 
  ,
  if (exists($tdsdoc//tei:place[@xml:id eq $placeref]//tei:idno[@type eq 'geonamesid'])) then
   update replace 
   $tdsdoc//tei:place[@xml:id eq $placeref]/tei:idno[@type eq 'geonamesid']
   with    <idno xmlns="http://www.tei-c.org/ns/1.0" type="geonamesid">{$placegeonamesid}</idno>
  else
  update insert 
  <idno xmlns="http://www.tei-c.org/ns/1.0" type="geonamesid">{$placegeonamesid}</idno>
  into $tdsdoc//tei:place[@xml:id eq $placeref] 
  
  ,
  if (exists($tdsdoc//tei:place[@xml:id eq $placeref]//tei:idno[@type eq 'wikidataid'])) then
   update replace 
   $tdsdoc//tei:place[@xml:id eq $placeref]/tei:idno[@type eq 'wikidataid']
   with    <idno xmlns="http://www.tei-c.org/ns/1.0" type="wikidataid">{$placewikidataid}</idno>
  else
  update insert 
 <idno xmlns="http://www.tei-c.org/ns/1.0" type="wikidataid">{$placewikidataid}</idno>
  into $tdsdoc//tei:place[@xml:id eq $placeref] 
   ,
  if (exists($tdsdoc//tei:place[@xml:id eq $placeref]//tei:idno[@type eq 'osmdataid'])) then
   update replace 
   $tdsdoc//tei:place[@xml:id eq $placeref]/tei:idno[@type eq 'osmdataid']
   with      <idno xmlns="http://www.tei-c.org/ns/1.0" type="osmdataid">{$placeosmdataid}</idno>
  else
  update insert 
  <idno xmlns="http://www.tei-c.org/ns/1.0" type="osmdataid">{$placeosmdataid}</idno>
  into $tdsdoc//tei:place[@xml:id eq $placeref] 
  
   ,
  if (exists($tdsdoc//tei:place[@xml:id eq $placeref]//tei:bloc[@type eq 'continent'])) then
   update replace 
   $tdsdoc//tei:place[@xml:id eq $placeref]/tei:bloc[@type eq 'continent']
   with       <bloc xmlns="http://www.tei-c.org/ns/1.0" type="continent">{$placecontinent}</bloc>
  else
  update insert 
 <bloc xmlns="http://www.tei-c.org/ns/1.0" type="continent">{$placecontinent}</bloc>
  into $tdsdoc//tei:place[@xml:id eq $placeref] 
  
     ,
  if (exists($tdsdoc//tei:place[@xml:id eq $placeref]//tei:country)) then
   update replace 
   $tdsdoc//tei:place[@xml:id eq $placeref]/tei:country
   with      <country xmlns="http://www.tei-c.org/ns/1.0">{$placecountry}</country>
  else
  update insert 
 <country xmlns="http://www.tei-c.org/ns/1.0">{$placecountry}</country>
  into $tdsdoc//tei:place[@xml:id eq $placeref] 
  
  
     ,
  if (exists($tdsdoc//tei:place[@xml:id eq $placeref]//tei:region[@type eq 'province'])) then
   update replace 
   $tdsdoc//tei:place[@xml:id eq $placeref]/tei:region[@type eq 'province']
   with <region xmlns="http://www.tei-c.org/ns/1.0" type="province">{$placeprovince}</region>
  else
  update insert 
<region xmlns="http://www.tei-c.org/ns/1.0" type="province">{$placeprovince}</region>
  into $tdsdoc//tei:place[@xml:id eq $placeref] 
  
     ,
  if (exists($tdsdoc//tei:place[@xml:id eq $placeref]//tei:note[@type eq 'placetype'])) then
   update replace 
   $tdsdoc//tei:place[@xml:id eq $placeref]/tei:note[@type eq 'placetype']
   with  <note xmlns="http://www.tei-c.org/ns/1.0" type="placetype">{$placetype}</note>
  else
  update insert 
<note xmlns="http://www.tei-c.org/ns/1.0" type="placetype">{$placetype}</note>
  into $tdsdoc//tei:place[@xml:id eq $placeref] 
  
   ,

       
  update insert 
  if ($placeworks ne '') 
  then 
   for $work in tokenize($placeworks,',')

   return
 if (not(exists($tdsdoc//tei:place[@xml:id eq $placeref]/tei:bibl[@xml:id eq $work]))) then
   
<bibl xmlns="http://www.tei-c.org/ns/1.0" xml:id="{$work}"></bibl>
 else $work

else  <bibl  xmlns="http://www.tei-c.org/ns/1.0" ></bibl>

  into $tdsdoc//tei:place[@xml:id eq $placeref]
  
))