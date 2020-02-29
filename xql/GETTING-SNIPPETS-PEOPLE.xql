xquery version "3.1";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace xs = "http://www.w3.org/2001/XMLSchema";
declare option exist:serialize 'method=xml';


(: Log in :)
let $log-in := xmldb:login("/db", "admin", "jeanluc23")

(: 1. INSERT BOOKS INTO XML FILE :)
(: Get source and target documents :)
let $collection := collection('/db/madrid/corpus')
let $collectionpeople := $collection//tei:div[@type='apartado']//(tei:persName|tei:rs[@type='person'])
let $collectionpersrefs := $collectionpeople//@ref
let $testdoc := doc('/db/madrid/xml/PERSONOGRAPHY-BIBLIO.xml')//tei:title

 (: Loop through books :)
 for $obra in $collection
 let $obraref :=  replace(replace(document-uri( root( $obra ) ),'/db/madrid/corpus/',''),'-TEI.xml','')

 (:let $people := $collectionpeople :)
order by $obra
group by $obra

return 
    if (exists ($testdoc//tei:bibl[@xml:id eq $obraref])) then () else
     update insert <bibl xmlns="http://www.tei-c.org/ns/1.0" xml:id="{$obraref}"></bibl> into $testdoc,
    
(: 2. GRAB SNIPPETS AND INSERT THEM INTO XML FILE BY BOOK :) 
(: Get source and target documents :)
let $collection := collection('/db/madrid/corpus')
let $collectionpeople := $collection//tei:div[@type='apartado']//(tei:persName|tei:rs[@type='person'])
let $collectionpersrefs := $collectionpeople//@ref
let $testdoc := doc('/db/madrid/xml/PERSONOGRAPHY-BIBLIO.xml')//tei:title

(: Loop through people and grab snippets :)
for $person in $collectionpeople
let $persref := replace($person/@ref,'#','')
let $persref := replace($persref,'\?','')
let $persrefforref := replace($persref,' ','_')


(: grab snippet text before and after result :)
let $persontextbefore :=string-join($person/(preceding::text() intersect ancestor::tei:p[1]//text()))
let $persontextbeforelength := string-length($persontextbefore)
let $persontextbeforestart := if ($persontextbeforelength < 50) then 0 else  ($persontextbeforelength - 50)
let $persontextafter :=string-join($person/(following::text() intersect ancestor::tei:p[1]//text()))
let $persontextafterlength := string-length($persontextafter)
(: create snippet ref :)
let $personapartado := $person/ancestor::tei:div[@type="apartado"]/@n
let $personcountp := $person/(ancestor::tei:p[1]/(., preceding-sibling::tei:p) => count() )
let $personancestorcharcount :=  string-length(string-join($person/(preceding::text() intersect ancestor::tei:p[1]//text())))
let $obra2 :=  replace(replace(document-uri( root( $person ) ),'/db/madrid/corpus/',''),'-TEI.xml','')
let $peoplesnippetref := ($obra2||'-'||$personapartado||'-'||$personcountp||'-'||$personancestorcharcount||'-'||$persrefforref)

(: snippet type based on element :)
 let $peoplesnippettype := 
 
 typeswitch($person)
  case element(tei:persName) return  'nombrado'
  case element(tei:rs) 
   
  return  if ($person/@type eq 'demonym') then 'gentilicio'
  else if ($person/@type eq 'person') then 'no nombrado'
  else return
  default return 'no especificado'

(: Insert snippet into xml file :)
return
    (
        (:update delete $testdoc/tei:bibl/interp ,:)
 if (exists ($testdoc//tei:interp[@xml:id eq $peoplesnippetref])) then 
     update replace $testdoc//tei:interp[@xml:id eq $peoplesnippetref] with
 <interp xmlns="http://www.tei-c.org/ns/1.0" xml:id="{$peoplesnippetref}" ana="{$peoplesnippettype}">... {normalize-space(substring($persontextbefore,$persontextbeforestart,$persontextbeforelength))}&#160;<hi>{$person/normalize-space()}</hi>&#160;{substring(normalize-space($persontextafter),0,50)}...</interp> 
 
 else
update insert
<interp xmlns="http://www.tei-c.org/ns/1.0" xml:id="{$peoplesnippetref}" ana="{$peoplesnippettype}">... {normalize-space(substring($persontextbefore,$persontextbeforestart,$persontextbeforelength))}&#160;<hi>{$person/normalize-space()}</hi>&#160;{substring(normalize-space($persontextafter),0,50)}...</interp> into $testdoc/tei:bibl[@xml:id eq $obra2])
  