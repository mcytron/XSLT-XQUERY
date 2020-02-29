xquery version "3.1";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare option exist:serialize 'method=xml';

let $log-in := xmldb:login("/db", "admin", "jeanluc23")

(: set the location of the destination bibliography xml file :)

let $doc := doc('/db/madrid/xml/tdsworks.xml')
let $works := $doc//tei:listBibl
let $worksxmlid := $doc//tei:bibl

(: select all distinct @refs from workNames and rs in TEI docs :)

let $doc2 := doc('/db/madrid/corpus/OBRATDS-TEI.xml')
    for $workref in distinct-values($doc2//(tei:rs[@type='meta']/@ref)  ! tokenize(., '\s+') => distinct-values())
    
(: remove poundsign from TEI doc @ref values and create bibl element :)

let $workrefclean := replace($workref, '#','')

(: compare bibl@xml:id in tds-works.xml with works created from TEI docs and eliminate duplicates:)

let $worksexclusion := distinct-values($workrefclean[not(.=$worksxmlid/@xml:id)])

(: unused: retrieves a list of distinct values that intersect between two secuences:)

let $worksintersect := distinct-values($workrefclean[.=$worksxmlid/@xml:id])

(: convert values that are not in bibliography.xml to nodes :)

let $worksexclusionnodes :=  <bibl xml:id="{$worksexclusion}" xmlns="http://www.tei-c.org/ns/1.0">OBRATDS</bibl>

where $worksexclusion != ''

(: update bibliography.xml, inserting all new nodes :)

let $update :=
update insert $worksexclusionnodes into $works

return $works