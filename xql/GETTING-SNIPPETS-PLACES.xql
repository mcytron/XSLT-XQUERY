xquery version "3.1";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace xs = "http://www.w3.org/2001/XMLSchema";
declare option exist:serialize 'method=xml';


(: Log in :)
let $log-in := xmldb:login("/db", "admin", "jeanluc23")

(: 1. INSERT BOOKS INTO XML FILE :)
(: Get source and target documents :)
let $collection := collection('/db/madrid/corpus')
let $collectionplaces := $collection//tei:div[@type='apartado']//(tei:placeName|tei:rs[@type='place']|tei:rs[@type='demonym'])
let $collectionplacerefs := $collectionplaces//@ref
let $testdoc := doc('/db/madrid/xml/PLACEOGRAPHY-BIBLIO.xml')//tei:title

 (: Loop through books :)
 for $obra in $collection
 let $obraref :=  replace(replace(document-uri( root( $obra ) ),'/db/madrid/corpus/',''),'-TEI.xml','')

 (:let $places := $collectionplaces :)
order by $obra
group by $obra

return 
    if (exists ($testdoc//tei:bibl[@xml:id eq $obraref])) then () else
     update insert <bibl xmlns="http://www.tei-c.org/ns/1.0" xml:id="{$obraref}"></bibl> into $testdoc,
    
(: 2. GRAB SNIPPETS AND INSERT THEM INTO XML FILE BY BOOK :) 
(: Get source and target documents :)
let $collection := collection('/db/madrid/corpus')
let $collectionplaces := $collection//tei:div[@type='apartado']//(tei:placeName|tei:rs[@type='place']|tei:rs[@type='demonym'])
let $collectionplacerefs := $collectionplaces//@ref
let $testdoc := doc('/db/madrid/xml/PLACEOGRAPHY-BIBLIO.xml')//tei:title

(: Loop through places and grab snippets :)
for $place in $collectionplaces
let $placeref := replace($place/@ref,'#','')
let $placeref := replace($placeref,'\?','')
let $placerefforref := replace($placeref,' ','_')


(: grab snippet text before and after result :)
let $placetextbefore :=string-join($place/(preceding::text() intersect ancestor::tei:p[1]//text()))
let $placetextbeforelength := string-length($placetextbefore)
let $placetextbeforestart := if ($placetextbeforelength < 50) then 0 else  ($placetextbeforelength - 50)
let $placetextafter :=string-join($place/(following::text() intersect ancestor::tei:p[1]//text()))
let $placetextafterlength := string-length($placetextafter)
(: create snippet ref :)
let $placeapartado := $place/ancestor::tei:div[@type="apartado"]/@n
let $placecountp := $place/(ancestor::tei:p[1]/(., preceding-sibling::tei:p) => count() )
let $placeancestorcharcount :=  string-length(string-join($place/(preceding::text() intersect ancestor::tei:p[1]//text())))
let $obra2 :=  replace(replace(document-uri( root( $place ) ),'/db/madrid/corpus/',''),'-TEI.xml','')
let $placesnippetref := ($obra2||'-'||$placeapartado||'-'||$placecountp||'-'||$placeancestorcharcount||'-'||$placerefforref)

(: snippet type based on element :)
 let $placesnippettype := 
 
 typeswitch($place)
  case element(tei:placeName) return  'nombrado'
  case element(tei:rs) 
   
  return  if ($place/@type eq 'demonym') then 'gentilicio'
  else if ($place/@type eq 'place') then 'no nombrado'
  else return
  default return 'no especificado'

(: Insert snippet into xml file :)
return
    (
        (:update delete $testdoc/tei:bibl/interp ,:)
 if (exists ($testdoc//tei:interp[@xml:id eq $placesnippetref])) then 
     update replace $testdoc//tei:interp[@xml:id eq $placesnippetref] with
 <interp xmlns="http://www.tei-c.org/ns/1.0" xml:id="{$placesnippetref}" ana="{$placesnippettype}">... {normalize-space(substring($placetextbefore,$placetextbeforestart,$placetextbeforelength))}&#160;<hi>{$place/normalize-space()}</hi>&#160;{substring(normalize-space($placetextafter),0,50)}...</interp> 
 
 else
update insert
<interp xmlns="http://www.tei-c.org/ns/1.0" xml:id="{$placesnippetref}" ana="{$placesnippettype}">... {normalize-space(substring($placetextbefore,$placetextbeforestart,$placetextbeforelength))}&#160;<hi>{$place/normalize-space()}</hi>&#160;{substring(normalize-space($placetextafter),0,50)}...</interp> into $testdoc/tei:bibl[@xml:id eq $obra2])
  