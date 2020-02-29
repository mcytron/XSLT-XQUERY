xquery version "3.1";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare option exist:serialize 'method=xml';

(:let $log-in := xmldb:login("/db", "schedule", "skedge23") :)

(: set the location of the destination personography xml file :)

let $doc := doc('/db/madrid/xml/personography.xml')
let $people := $doc//tei:listPerson
let $peoplexmlid := $doc//tei:person

(: select all distinct @refs from persNames and rs in TEI docs :)

let $collection := collection('/db/madrid/corpus')
    for $persref in distinct-values($collection//(tei:persName/@ref|tei:rs[@type='person']/@ref)  ! tokenize(., '\s+') => distinct-values())
    
(: remove poundsign from TEI doc @ref values and create person element :)

let $persrefclean := <person xml:id="{replace($persref, '#','')}"><note>NEW-PERSON</note></person>

(: compare person@xml:id in personography.xml with people created from TEI docs and eliminate duplicates:)

let $peopleexclusion := distinct-values($persrefclean/@xml:id[not(.=$peoplexmlid/@xml:id)])

(: unused: retrieves a list of distinct values that intersect between two secuences:)

let $peopleintersect := distinct-values($persrefclean/@xml:id[.=$peoplexmlid/@xml:id])

(: convert values that are not in personography.xml to nodes :)

let $peopleexclusionnodes :=  <person xml:id="{$peopleexclusion}" xmlns="http://www.tei-c.org/ns/1.0"><note>NEW-PERSON</note></person>

(: update personography.xml, inserting all new nodes :)

let $update := 
  
update insert $peopleexclusionnodes into $people

return $people