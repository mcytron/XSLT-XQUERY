xquery version "3.1";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare option exist:serialize 'method=xml';

let $log-in := xmldb:login("/db", "admin", "jeanluc23")

(: set the location of the destination placeography xml file :)

let $doc := doc('/db/madrid/xml/tdsplaces-demonyms.xml')
let $places := $doc//tei:listPlace
let $placesxmlid := $doc//tei:place

(: select all distinct @refs from placeNames and rs in TEI docs :)

let $doc2 := doc('/db/madrid/corpus/OBRATDS-TEI.xml')
    for $placeref in distinct-values($doc2//(tei:rs[@type='demonym']/@ref|tei:rs[@type='ethnonym']/@ref)  ! tokenize(., '\s+') => distinct-values())
    
(: remove poundsign from TEI doc @ref values and create place element :)

let $placerefclean := replace($placeref, '#','')

(: compare place@xml:id in tdsplaces.xml with places created from TEI docs and eliminate duplicates:)

let $placesexclusion := distinct-values($placerefclean[not(.=$placesxmlid/@xml:id)])

(: unused: retrieves a list of distinct values that intersect between two secuences:)

let $placesintersect := distinct-values($placerefclean[.=$placesxmlid/@xml:id])

(: convert values that are not in placeography.xml to nodes :)

let $placesexclusionnodes :=  <place xml:id="{$placesexclusion}" xmlns="http://www.tei-c.org/ns/1.0"><note>NEW-PLACE-DEMONYM</note><bibl>OBRATDS</bibl></place>

where $placesexclusion != ''

(: update placeography.xml, inserting all new nodes :)

let $update :=
update insert $placesexclusionnodes into $places

return $places