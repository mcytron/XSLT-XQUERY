xquery version "3.1";

declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare option exist:serialize 'method=xml';


(: set the location of the destination placeography xml file :)

let $doc := doc('/db/madrid/xml/placerefs.xml')
let $places := $doc//tei:listPlace
let $placesxmlid := $doc//tei:place
let $connection := sql:get-connection("com.mysql.jdbc.Driver", "jdbc:mysql://localhost/readingmadrid", "readingmadrid","jeanluc23") 


(: select all distinct @refs from placeNames and rs in TEI docs :)

let $TDSplaces := doc('/db/madrid/corpus/OBRATDS-TEI.xml')
    for $TDSplaceref in distinct-values($TDSplaces//(tei:placeName/@ref|tei:rs[@type='place']/@ref))
(:
let $LBUplaces := doc('/db/madrid/corpus/La-busca-baroja-TEI.xml')
    for $LBUplaceref in distinct-values($LBUplaces//(tei:placeName/@ref|tei:rs[@type='place']/@ref))
    
 
let $INSplaces := doc('/db/madrid/corpus/Insolacion-Pardo-Bazan-TEI.xml')
    for $INSplaceref in distinct-values($INSplaces//(tei:placeName/@ref|tei:rs[@type='place']/@ref))
    
let $LCTplaces := doc('/db/madrid/corpus/conciencia-tranquila-carmen-martin-gaite-TEI.xml')
    for $LCTplaceref in distinct-values($LCTplaces//(tei:placeName/@ref|tei:rs[@type='place']/@ref))
    
let $LDEplaces := doc('/db/madrid/corpus/la-desheredada-TEI.xml')
    for $LDEplaceref in distinct-values($LDEplaces//(tei:placeName/@ref|tei:rs[@type='place']/@ref))
    
let $LMIplaces := doc('/db/madrid/corpus/misericordia-galdos-TEI.xml')
    for $LMIplaceref in distinct-values($LMIplaces//(tei:placeName/@ref|tei:rs[@type='place']/@ref)) :)
    
(: remove poundsign from TEI doc @ref values and create place element :)

let $TDSplacerefclean := <place xml:id="{replace($TDSplaceref, '#','')}"><placeref>{replace($TDSplaceref, '#','')}</placeref><obra>OBRATDS</obra></place>

(: compare place@xml:id in placeography.xml with places created from TEI docs and eliminate duplicates:)

let $TDSplacesexclusion := distinct-values($TDSplacerefclean/@xml:id[not(.=$placesxmlid/@xml:id)])

(: unused: retrieves a list of distinct values that intersect between two secuences:)

let $TDSplacesintersect := distinct-values($TDSplacerefclean/@xml:id[.=$placesxmlid/@xml:id])

(: convert values that are not in placeography.xml to nodes :)

let $TDSplacesexclusionnodes :=  <place xml:id="{$TDSplacesexclusion}" xmlns="http://www.tei-c.org/ns/1.0"><placeref>{replace($TDSplaceref, '#','')}</placeref><obra>OBRATDS</obra><note>new</note></place>


(: 

let $LBUplacerefclean := <place xml:id="{replace($LBUplaceref, '#','')}"><placeref>{replace($LBUplaceref, '#','')}</placeref><obra>OBRALBU</obra></place>

(: compare place@xml:id in placeography.xml with places created from TEI docs and eliminate duplicates:)

let $LBUplacesexclusion := distinct-values($LBUplacerefclean/@xml:id[not(.=$placesxmlid/@xml:id)])

(: unused: retrieves a list of distinct values that intersect between two secuences:)

let $LBUplacesintersect := distinct-values($LBUplacerefclean/@xml:id[.=$placesxmlid/@xml:id])

(: convert values that are not in placeography.xml to nodes :)

let $LBUplacesexclusionnodes :=  <place xml:id="{$LBUplacesexclusion}" xmlns="http://www.tei-c.org/ns/1.0"><placeref>{replace($LBUplaceref, '#','')}</placeref><obra>OBRALBU</obra><note>new</note></place>
 :)



(: update placeography.xml, inserting all new nodes :)

let $update := 
  
update insert $TDSplacesexclusionnodes   into $places  

(:   :let $update2 := 
  
update insert $LBUplacesexclusionnodes  into $places  :)
return $places