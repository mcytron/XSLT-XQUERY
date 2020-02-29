xquery version "3.1";
declare namespace xsi="http://www.w3.org/2001/XMLSchema-instance";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace xs = "http://www.w3.org/2001/XMLSchema";
declare option exist:serialize 'method=xml';

(: Log in :)
let $log-in := xmldb:login("/db", "admin", "jeanluc23")

(: Get source and target documents :)
let $exportedmysqldoc := doc('http://45.56.98.26/tds-data/works_tds_mysql_export.xml')//row
let $tdsdoc := doc('/db/madrid/xml/tds-works.xml')/* 



(: Add work names by workrefs :)
for $row in $exportedmysqldoc
  let $workref := normalize-space($row/field[@name eq 'workref'])
  let $workname := normalize-space($row/field[@name eq 'workname'])
    let $workauthor := normalize-space($row/field[@name eq 'workauthor'])
    let $workauthorID := normalize-space($row/field[@name eq 'persref'])
let $workwikiID := normalize-space($row/field[@name eq 'workwikiID'])
let $workcountry := normalize-space($row/field[@name eq 'workcountry'])
let $worktype := normalize-space($row/field[@name eq 'worktype'])
let $workworks := normalize-space($row/field[@name eq 'workworks'])

  return 
    (: LIMIT INSERTED PLACES TO TDS: and contains($workworks,'OBRATDS')) :)  
(if ((not(exists($tdsdoc//tei:listBibl/tei:bibl[@xml:id eq $workref]))) and contains($workworks,'OBRATDS')) then
  update insert 
 <bibl xmlns="http://www.tei-c.org/ns/1.0" xml:id="{$workref}"></bibl>
  into $tdsdoc//tei:listBibl   
    
    else
 (if (exists($tdsdoc//tei:listBibl/tei:bibl[@xml:id eq $workref]//tei:title)) then
   update replace 
   $tdsdoc//tei:listBibl/tei:bibl[@xml:id eq $workref]/tei:title
   with  <title xmlns="http://www.tei-c.org/ns/1.0">{$workname}</title>
  else
  update insert 
 <title xmlns="http://www.tei-c.org/ns/1.0">{$workname}</title>
  into $tdsdoc//tei:listBibl/tei:bibl[@xml:id eq $workref] 
 
   ,
   if (exists($tdsdoc//tei:listBibl/tei:bibl[@xml:id eq $workref]/tei:name[@type eq 'workauthor'])) then
   update replace 
   $tdsdoc//tei:listBibl/tei:bibl[@xml:id eq $workref]/tei:name[@type eq 'workauthor']
   with  <name xmlns="http://www.tei-c.org/ns/1.0" type="workauthor" ref="{$workauthorID}">{$workauthor}</name>
  else
  update insert 
 <name xmlns="http://www.tei-c.org/ns/1.0" type="workauthor" ref="{$workauthorID}">{$workauthor}</name>
  into $tdsdoc//tei:listBibl/tei:bibl[@xml:id eq $workref] 
 
 
  ,
  if (exists($tdsdoc//tei:listBibl/tei:bibl[@xml:id eq $workref]//tei:idno[@type eq 'workwikiID'])) then
   update replace 
   $tdsdoc//tei:listBibl/tei:bibl[@xml:id eq $workref]/tei:idno[@type eq 'workwikiID']
   with    <idno xmlns="http://www.tei-c.org/ns/1.0" type="workwikiID">{$workwikiID}</idno>
  else
  update insert 
 <idno xmlns="http://www.tei-c.org/ns/1.0" type="workwikiID">{$workwikiID}</idno>
  into $tdsdoc//tei:listBibl/tei:bibl[@xml:id eq $workref] 
 
  
     ,
  if (exists($tdsdoc//tei:listBibl/tei:bibl[@xml:id eq $workref]//tei:country)) then
   update replace 
   $tdsdoc//tei:listBibl/tei:bibl[@xml:id eq $workref]/tei:country
   with      <country xmlns="http://www.tei-c.org/ns/1.0">{$workcountry}</country>
  else
  update insert 
 <country xmlns="http://www.tei-c.org/ns/1.0">{$workcountry}</country>
  into $tdsdoc//tei:listBibl/tei:bibl[@xml:id eq $workref] 
  
 
     ,
  if (exists($tdsdoc//tei:listBibl/tei:bibl[@xml:id eq $workref]//tei:note[@type eq 'worktype'])) then
   update replace 
   $tdsdoc//tei:listBibl/tei:bibl[@xml:id eq $workref]/tei:note[@type eq 'worktype']
   with  <note xmlns="http://www.tei-c.org/ns/1.0" type="worktype">{$worktype}</note>
  else
  update insert 
<note xmlns="http://www.tei-c.org/ns/1.0" type="worktype">{$worktype}</note>
  into $tdsdoc//tei:listBibl/tei:bibl[@xml:id eq $workref] ,
  
  
       
  update insert 
  if ($workworks ne '') 
  then 
   for $work in tokenize($workworks,',')

   return
 if (not(exists($tdsdoc//tei:listBibl/tei:bibl[@xml:id eq $workref]/tei:bibl[@xml:id eq $work]))) then
   
<bibl xmlns="http://www.tei-c.org/ns/1.0" xml:id="{$work}"></bibl>
 else $work

else  <bibl  xmlns="http://www.tei-c.org/ns/1.0" ></bibl>

  into $tdsdoc//tei:listBibl/tei:bibl[@xml:id eq $workref]
  
  )
  )
 