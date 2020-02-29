xquery version "3.1";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare option exist:serialize 'method=xml';

let $log-in := xmldb:login("/db", "admin", "jeanluc23")

(: set the location of the destination bibliography xml file :)

(: set the location of the destination placeography xml file :)
let $collection := collection('/db/madrid/corpus')
(:let $doc := doc('/db/madrid/xml/esmpeople.xml'):)



 for $obra in $collection
 
 let $obraref :=  replace(replace(document-uri( root( $obra ) ),'/db/madrid/corpus/',''),'-TEI.xml','')
  let $obrarefshort :=  replace($obraref,'OBRA','')
let $docuri := concat('/db/madrid/xml/',lower-case($obrarefshort),'works.xml')
 let $doc := doc($docuri)
 let $works := $doc//tei:listBibl
let $worksxmlid := $doc//tei:bibl
 let $obrapath := document-uri( root( $obra ) )
(: select all distinct @refs from placeNames and rs in TEI docs :)


let $doc2uri := concat('/db/madrid/corpus/',$obraref,'-TEI.xml')

let $doc2 := doc($doc2uri)

    for $workref in distinct-values($doc2//(tei:rs[@type='meta']/@ref)  ! tokenize(., '\s+') => distinct-values())
    
(: remove poundsign from TEI doc @ref values and create bibl element :)

let $workrefclean := replace($workref, '#','')

(: compare bibl@xml:id in tds-works.xml with works created from TEI docs and eliminate duplicates:)

let $worksexclusion := distinct-values($workrefclean[not(.=$worksxmlid/@xml:id)])

(: unused: retrieves a list of distinct values that intersect between two secuences:)

let $worksintersect := distinct-values($workrefclean[.=$worksxmlid/@xml:id])

(: convert values that are not in bibliography.xml to nodes :)

let $worksexclusionnodes :=  <bibl xml:id="{$worksexclusion}" xmlns="http://www.tei-c.org/ns/1.0">{$obraref}</bibl>

where $worksexclusion != ''

(: update bibliography.xml, inserting all new nodes :)

let $update :=
update insert $worksexclusionnodes into $works

return $works