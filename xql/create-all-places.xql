xquery version "3.1";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare option exist:serialize 'method=xml';

let $log-in := xmldb:login("/db", "admin", "jeanluc23")




(: set the location of the destination placeography xml file :)
let $collection := collection('/db/madrid/corpus')
(:let $doc := doc('/db/madrid/xml/esmpeople.xml'):)



 for $obra in $collection
 
 let $obraref :=  replace(replace(document-uri( root( $obra ) ),'/db/madrid/corpus/',''),'-TEI.xml','')
  let $obrarefshort :=  replace($obraref,'OBRA','')
let $docuri := concat('/db/madrid/xml/',lower-case($obrarefshort),'places.xml')
 let $doc := doc($docuri)
 let $places := $doc//tei:listPlace
let $placesxmlid := $doc//tei:place
 let $obrapath := document-uri( root( $obra ) )
(: select all distinct @refs from placeNames and rs in TEI docs :)


let $doc2uri := concat('/db/madrid/corpus/',$obraref,'-TEI.xml')

let $doc2 := doc($doc2uri)


    for $placeref in distinct-values($doc2//(tei:placeName/@ref|tei:rs[@type='place']/@ref)  ! tokenize(., '\s+') => distinct-values())
    
(: remove poundsign from TEI doc @ref values and create place element :)

let $placerefclean := replace($placeref, '#','')

(: compare place@xml:id in tdsplaces.xml with places created from TEI docs and eliminate duplicates:)

let $placesexclusion := distinct-values($placerefclean[not(.=$placesxmlid/@xml:id)])

(: unused: retrieves a list of distinct values that intersect between two secuences:)

let $placesintersect := distinct-values($placerefclean[.=$placesxmlid/@xml:id])

(: convert values that are not in placeography.xml to nodes :)

let $placesexclusionnodes :=  <place xml:id="{$placesexclusion}" xmlns="http://www.tei-c.org/ns/1.0"><bibl>{$obraref}</bibl></place>

where $placesexclusion != ''

(: update placeography.xml, inserting all new nodes :)

let $update :=
update insert $placesexclusionnodes into $places

return $places