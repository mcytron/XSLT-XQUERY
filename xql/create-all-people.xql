xquery version "3.1";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare option exist:serialize 'method=xml';

let $log-in := xmldb:login("/db", "admin", "jeanluc23")



(: set the location of the destination personography xml file :)
let $collection := collection('/db/madrid/corpus')
(:let $doc := doc('/db/madrid/xml/esmpeople.xml'):)



 for $obra in $collection
 
 let $obraref :=  replace(replace(document-uri( root( $obra ) ),'/db/madrid/corpus/',''),'-TEI.xml','')
  let $obrarefshort :=  replace($obraref,'OBRA','')
let $docuri := concat('/db/madrid/xml/',lower-case($obrarefshort),'people.xml')
 let $doc := doc($docuri)
 let $people := $doc//tei:listPerson
let $peoplexmlid := $doc//tei:person
 let $obrapath := document-uri( root( $obra ) )
(: select all distinct @refs from persNames and rs in TEI docs :)


let $doc2uri := concat('/db/madrid/corpus/',$obraref,'-TEI.xml')

let $doc2 := doc($doc2uri)
    for $persref in distinct-values($doc2//(tei:persName/@ref|tei:rs[@type='person']/@ref)  ! tokenize(., '\s+') => distinct-values())
    
   
(: remove poundsign from TEI doc @ref values and create person element :)

let $persrefclean := replace($persref, '#','')

(: compare person@xml:id in tdspeople.xml with people created from TEI docs and eliminate duplicates:)

let $peopleexclusion := distinct-values($persrefclean[not(.=$peoplexmlid/@xml:id)])

(: unused: retrieves a list of distinct values that intersect between two secuences:)

let $peopleintersect := distinct-values($persrefclean[.=$peoplexmlid/@xml:id])

(: convert values that are not in personography.xml to nodes :)

let $peopleexclusionnodes :=  <person xml:id="{$peopleexclusion}" xmlns="http://www.tei-c.org/ns/1.0"><bibl>{$obraref}</bibl></person>

where $peopleexclusion != ''

(: update personography.xml, inserting all new nodes :)

let $update :=
update insert $peopleexclusionnodes into $people

return $people