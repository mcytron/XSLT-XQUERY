xquery version "3.1";
declare namespace xsi="http://www.w3.org/2001/XMLSchema-instance";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace xs = "http://www.w3.org/2001/XMLSchema";
declare option exist:serialize 'method=xml';

(: Log in :)
let $log-in := xmldb:login("/db", "admin", "jeanluc23")

(: Get source and target documents :)
let $tdsdoc := doc('/db/madrid/xml/tds-works.xml')/* 
let $snippetsdoc := doc('/db/madrid/xml/BIBLIOGRAPHY-BIBLIO.xml')//tei:interp



for $snippet in $snippetsdoc 
let $snippetref:= $snippet/@xml:id
let $snippetbookref := tokenize($snippet/@xml:id,'-')[1]
let $snippetworkref := tokenize($snippet/@xml:id,'-')[5]

(:where $tdsdoc//tei:bibl[@xml:id] eq $workref and $tdsdoc//tei:bibl[@xml:id] eq $snippetbookref:)
for $work in $tdsdoc//tei:listBibl/tei:bibl

let $workrefstart := concat($work/@xml:id, '_')
let $workrefend := concat( '_',$work/@xml:id)
let $workrefmiddle := concat( '_',$work/@xml:id,'_')
where 

($snippetworkref eq $work/@xml:id) or ((starts-with($snippetworkref,$workrefstart)) or (ends-with($snippetworkref,$workrefend)) or (contains($snippetworkref,$workrefmiddle)))


for $book in $work/tei:bibl
return
    if(exists($tdsdoc//tei:interp[@xml:id eq $snippetref]))
    then
    update replace $tdsdoc//tei:interp[@xml:id eq $snippetref] with $snippet
    
    else
    update insert $snippet
    

   into  $book[@xml:id eq $snippetbookref]

