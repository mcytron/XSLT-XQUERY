xquery version "3.1";
declare namespace xsi="http://www.w3.org/2001/XMLSchema-instance";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace xs = "http://www.w3.org/2001/XMLSchema";
declare option exist:serialize 'method=xml';

(: Log in :)
let $log-in := xmldb:login("/db", "admin", "jeanluc23")

(: Get source and target documents :)
let $exportedmysqldoc := doc('http://45.56.98.26/tds-data/people_tds_mysql_export.xml')//row
let $tdsdoc := doc('/db/madrid/xml/tds-people.xml')/* 



(: Add pers names by persrefs :)
for $row in $exportedmysqldoc
  let $persref := normalize-space($row/field[@name eq 'persref'])
  let $persfirstname := normalize-space($row/field[@name eq 'persfirstname'])
    let $persepithet := normalize-space($row/field[@name eq 'persepithet'])
    let $perslastname := normalize-space($row/field[@name eq 'perslastname'])
   let $persmoniker := normalize-space($row/field[@name eq 'persmoniker'])
let $perswikidataid := normalize-space($row/field[@name eq 'perswikidataid'])
let $persgender := normalize-space($row/field[@name eq 'persgender'])
let $persoccupation := normalize-space($row/field[@name eq 'persoccupation'])
let $perscontinent := normalize-space($row/field[@name eq 'perscontinent'])
let $perscountry := normalize-space($row/field[@name eq 'perscountry'])
let $perstype := normalize-space($row/field[@name eq 'perstype'])
let $persworks := normalize-space($row/field[@name eq 'persworks'])

  return 
    (: LIMIT INSERTED PLACES TO TDS: and contains($persworks,'OBRATDS')) :)  
(if ((not(exists($tdsdoc//tei:person[@xml:id eq $persref]))) and contains($persworks,'OBRATDS')) then
  update insert 
 <person xmlns="http://www.tei-c.org/ns/1.0" xml:id="{$persref}"></person>
  into $tdsdoc//tei:listPerson   
    
    else
 (if (exists($tdsdoc//tei:person[@xml:id eq $persref]//tei:name[@type eq 'persfirstname'])) then
   update replace 
   $tdsdoc//tei:person[@xml:id eq $persref]/tei:name[@type eq 'persfirstname']
   with  <name xmlns="http://www.tei-c.org/ns/1.0" type="persfirstname">{$persfirstname}</name>
  else
  update insert 
 <name xmlns="http://www.tei-c.org/ns/1.0" type="persfirstname">{$persfirstname}</name>
  into $tdsdoc//tei:person[@xml:id eq $persref] 
 
   ,
   if (exists($tdsdoc//tei:person[@xml:id eq $persref]//tei:name[@type eq 'persepithet'])) then
   update replace 
   $tdsdoc//tei:person[@xml:id eq $persref]/tei:name[@type eq 'persepithet']
   with  <name xmlns="http://www.tei-c.org/ns/1.0" type="persepithet">{$persepithet}</name>
  else
  update insert 
 <name xmlns="http://www.tei-c.org/ns/1.0" type="persepithet">{$persepithet}</name>
  into $tdsdoc//tei:person[@xml:id eq $persref] 
 ,
 if (exists($tdsdoc//tei:person[@xml:id eq $persref]//tei:name[@type eq 'perslastname'])) then
   update replace 
   $tdsdoc//tei:person[@xml:id eq $persref]/tei:name[@type eq 'perslastname']
   with  <name xmlns="http://www.tei-c.org/ns/1.0" type="perslastname">{$perslastname}</name>
  else
  update insert 
 <name xmlns="http://www.tei-c.org/ns/1.0" type="perslastname">{$perslastname}</name>
  into $tdsdoc//tei:person[@xml:id eq $persref] 
  ,
 if (exists($tdsdoc//tei:person[@xml:id eq $persref]//tei:name[@type eq 'persmoniker'])) then
   update replace 
   $tdsdoc//tei:person[@xml:id eq $persref]/tei:name[@type eq 'persmoniker']
   with  <name xmlns="http://www.tei-c.org/ns/1.0" type="persmoniker">{$persmoniker}</name>
  else
  update insert 
 <name xmlns="http://www.tei-c.org/ns/1.0" type="persmoniker">{$persmoniker}</name>
  into $tdsdoc//tei:person[@xml:id eq $persref] 
 
  ,
  if (exists($tdsdoc//tei:person[@xml:id eq $persref]//tei:idno[@type eq 'wikidataid'])) then
   update replace 
   $tdsdoc//tei:person[@xml:id eq $persref]/tei:idno[@type eq 'wikidataid']
   with    <idno xmlns="http://www.tei-c.org/ns/1.0" type="wikidataid">{$perswikidataid}</idno>
  else
  update insert 
 <idno xmlns="http://www.tei-c.org/ns/1.0" type="wikidataid">{$perswikidataid}</idno>
  into $tdsdoc//tei:person[@xml:id eq $persref] 
 
  
     ,
  if (exists($tdsdoc//tei:person[@xml:id eq $persref]//tei:country)) then
   update replace 
   $tdsdoc//tei:person[@xml:id eq $persref]/tei:country
   with      <country xmlns="http://www.tei-c.org/ns/1.0">{$perscountry}</country>
  else
  update insert 
 <country xmlns="http://www.tei-c.org/ns/1.0">{$perscountry}</country>
  into $tdsdoc//tei:person[@xml:id eq $persref] 
  
    ,
  if (exists($tdsdoc//tei:person[@xml:id eq $persref]//tei:sex)) then
   update replace 
   $tdsdoc//tei:person[@xml:id eq $persref]/tei:sex
   with      <sex xmlns="http://www.tei-c.org/ns/1.0">{$persgender}</sex>
  else
  update insert 
 <sex xmlns="http://www.tei-c.org/ns/1.0">{$persgender}</sex>
  into $tdsdoc//tei:person[@xml:id eq $persref] 
  
  ,
  if (exists($tdsdoc//tei:person[@xml:id eq $persref]//tei:note[@type eq 'persoccupation'])) then
   update replace 
   $tdsdoc//tei:person[@xml:id eq $persref]/tei:note[@type eq 'persoccupation']
   with  <note xmlns="http://www.tei-c.org/ns/1.0" type="persoccupation">{$persoccupation}</note>
  else
  update insert 
<note xmlns="http://www.tei-c.org/ns/1.0" type="persoccupation">{$persoccupation}</note>
  into $tdsdoc//tei:person[@xml:id eq $persref]
  
     ,
  if (exists($tdsdoc//tei:person[@xml:id eq $persref]//tei:note[@type eq 'perstype'])) then
   update replace 
   $tdsdoc//tei:person[@xml:id eq $persref]/tei:note[@type eq 'perstype']
   with  <note xmlns="http://www.tei-c.org/ns/1.0" type="perstype">{$perstype}</note>
  else
  update insert 
<note xmlns="http://www.tei-c.org/ns/1.0" type="perstype">{$perstype}</note>
  into $tdsdoc//tei:person[@xml:id eq $persref] ,
  
  
       
  update insert 
  if ($persworks ne '') 
  then 
   for $work in tokenize($persworks,',')

   return
 if (not(exists($tdsdoc//tei:person[@xml:id eq $persref]/tei:bibl[@xml:id eq $work]))) then
   
<bibl xmlns="http://www.tei-c.org/ns/1.0" xml:id="{$work}"></bibl>
 else $work

else  <bibl  xmlns="http://www.tei-c.org/ns/1.0" ></bibl>

  into $tdsdoc//tei:person[@xml:id eq $persref]
  
  )
  )
 