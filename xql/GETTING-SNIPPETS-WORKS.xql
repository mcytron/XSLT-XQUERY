xquery version "3.1";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace xs = "http://www.w3.org/2001/XMLSchema";
declare option exist:serialize 'method=xml';


(: Log in :)
let $log-in := xmldb:login("/db", "admin", "jeanluc23")

(: 1. INSERT BOOKS INTO XML FILE :)
(: Get source and target documents :)
let $collection := collection('/db/madrid/corpus')
let $collectionworks := $collection//tei:div[@type='apartado']//(tei:rs[@type='meta'])
let $collectionworkrefs := $collectionworks//@ref
let $testdoc := doc('/db/madrid/xml/BIBLIOGRAPHY-BIBLIO.xml')//tei:title

 (: Loop through books :)
 for $obra in $collection
 let $obraref :=  replace(replace(document-uri( root( $obra ) ),'/db/madrid/corpus/',''),'-TEI.xml','')

 (:let $works := $collectionworks :)
order by $obra
group by $obra

return 
    if (exists ($testdoc//tei:bibl[@xml:id eq $obraref])) then () else
     update insert <bibl xmlns="http://www.tei-c.org/ns/1.0" xml:id="{$obraref}"></bibl> into $testdoc,
    
(: 2. GRAB SNIPPETS AND INSERT THEM INTO XML FILE BY BOOK :) 
(: Get source and target documents :)
let $collection := collection('/db/madrid/corpus')
let $collectionworks := $collection//tei:div[@type='apartado']//(tei:rs[@type='meta'])
let $collectionworkrefs := $collectionworks//@ref
let $testdoc := doc('/db/madrid/xml/BIBLIOGRAPHY-BIBLIO.xml')//tei:title

(: Loop through works and grab snippets :)
for $work in $collectionworks
let $workref := replace($work/@ref,'#','')
let $workref := replace($workref,'\?','')
let $workrefforref := replace($workref,' ','_')

(: grab snippet text before and after result :)
let $worktextbefore :=string-join($work/(preceding::text() intersect ancestor::tei:p[1]//text()))
let $worktextbeforelength := string-length($worktextbefore)
let $worktextbeforestart := if ($worktextbeforelength < 50) then 0 else  ($worktextbeforelength - 50)
let $worktextafter :=string-join($work/(following::text() intersect ancestor::tei:p[1]//text()))
let $worktextafterlength := string-length($worktextafter)
(: create snippet ref :)
let $workapartado := $work/ancestor::tei:div[@type="apartado"]/@n
let $workcountp := $work/(ancestor::tei:p[1]/(., preceding-sibling::tei:p) => count() )
let $workancestorcharcount :=  string-length(string-join($work/(preceding::text() intersect ancestor::tei:p[1]//text())))
let $obra2 :=  replace(replace(document-uri( root( $work ) ),'/db/madrid/corpus/',''),'-TEI.xml','')
let $worksnippetref := ($obra2||'-'||$workapartado||'-'||$workcountp||'-'||$workancestorcharcount||'-'||$workrefforref)

(: snippet type based on element :)
 let $worksnippettype := 'meta'

(: Insert snippet into xml file :)
return
    (
        (:update delete $testdoc/tei:bibl/interp ,:)
 if (exists ($testdoc//tei:interp[@xml:id eq $worksnippetref])) then 
     update replace $testdoc//tei:interp[@xml:id eq $worksnippetref] with
 <interp xmlns="http://www.tei-c.org/ns/1.0" xml:id="{$worksnippetref}" ana="{$worksnippettype}">... {normalize-space(substring($worktextbefore,$worktextbeforestart,$worktextbeforelength))}&#160;<hi>{$work/normalize-space()}</hi>&#160;{substring(normalize-space($worktextafter),0,50)}...</interp> 
 
 else
update insert
<interp xmlns="http://www.tei-c.org/ns/1.0" xml:id="{$worksnippetref}" ana="{$worksnippettype}">... {normalize-space(substring($worktextbefore,$worktextbeforestart,$worktextbeforelength))}&#160;<hi>{$work/normalize-space()}</hi>&#160;{substring(normalize-space($worktextafter),0,50)}...</interp> into $testdoc/tei:bibl[@xml:id eq $obra2])
  