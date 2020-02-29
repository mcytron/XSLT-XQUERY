xquery version "3.1";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare option exist:serialize 'method=xml';

let $log-in := xmldb:login("/db", "admin", "jeanluc23")

(: set the location of the destination -ography xml file :)

let $doc := doc('/db/madrid/xml/tdsplaces-collectives.xml')
let $collectives := $doc//tei:listPerson
let $collectivesxmlid := $doc//tei:personGrp

(: select all distinct @refs from   rs in TEI docs :)

let $doc2 := doc('/db/madrid/corpus/OBRATDS-TEI.xml')
    for $colref in distinct-values($doc2//(tei:rs[@type='collective']/@ref)  ! tokenize(., '\s+') => distinct-values())
    
(: remove poundsign from TEI doc @ref values and create persongrp element :)

let $colrefclean := replace($colref, '#','')

(: compare collectives@xml:id in tdscollectives.xml with people created from TEI docs and eliminate duplicates:)

let $collectivesexclusion := distinct-values($colrefclean[not(.=$collectivesxmlid/@xml:id)])

(: unused: retrieves a list of distinct values that intersect between two secuences:)

let $collectivesintersect := distinct-values($colrefclean[.=$collectivesxmlid/@xml:id])

(: convert values that are not in -ography.xml to nodes :)

let $collectivesexclusionnodes :=  <personGrp xml:id="{$collectivesexclusion}" xmlns="http://www.tei-c.org/ns/1.0"><note>NEW-COLLECTIVE</note><bibl>OBRATDS</bibl></personGrp>

where $collectivesexclusion != ''

(: update -ography.xml, inserting all new nodes :)

let $update :=
update insert $collectivesexclusionnodes into $collectives

return $collectives