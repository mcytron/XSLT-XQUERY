xquery version "3.1";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace xs = "http://www.w3.org/2001/XMLSchema";
declare option exist:serialize 'method=xml';

(: FUNCTION THAT COLLECTS AND TOKENIZES WORDS :)
declare function local:collect-words($words as xs:string*) as xs:string*
{
    fn:string-join($words, " ")
    => fn:translate("!?.',-", "")
    => fn:lower-case()
    => fn:tokenize (" ")
};

(: FUNCTION THAT DETERMINES FREQUENCY :)
 declare function local:determine-frequency($words as xs:string*) as element(word)*
{
    for $word in fn:distinct-values($words)
    let $item :=
        element word {
            attribute frequency { fn:count($words[. = $word]) },
            $word
        }
    order by $item/@frequency descending
    return $item
};


declare function local:get-place-name-by-id($collection as document-node(), $placeref as xs:string) as xs:string
{
  let $placeName := $collection//tei:place[@xml:id = $placeref]
  return fn:string-join($placeName/tei:placeName//text(), " ")
};

declare function local:get-scenes-by-id($collection as document-node(), $placeref as xs:string) as xs:string*
{
  let $scenes :=
    for $apartado in $collection//tei:div[@type="apartado"]
    for $p in $apartado/tei:p
    let $apartado-p := fn:concat("apartado ", $apartado/@n, ", ", "p ", count($p))
    where $placeref = $p//tei:placename/@ref|tei:rs[@type="place"/@ref|tei:rs[@type="demonym"/@ref ! fn:tokenize(., " ") ! fn:replace(., "#", "")
    return $apartado-p
  return fn:string-join($scenes, "; ")
};


(: Log in :)
let $log-in := xmldb:login("/db", "admin", "jeanluc23")

(: Get source and target documents :)
let $collectionplaces := collection('/db/madrid/corpus')//tei:div[@type='apartado']//(tei:placeName|tei:rs[@type='place']|tei:rs[@type='demonym'])