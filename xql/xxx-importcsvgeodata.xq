xquery version "1.0";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace xsi="http://www.w3.org/2001/XMLSchema-instance";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace util = "http://exist-db.org/xquery/util";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";

let $log-in := xmldb:login("/db", "admin", "jeanluc23")
let $csvbinaryfile := util:binary-doc("db/csv/readingmadrid-places-geo.csv")
let $csvtextfile := util:binary-to-string($csvbinaryfile)


let $lines := tokenize($csvtextfile, '\n')

let $body := remove($lines, 1)
return
    <listPlaces>
        {
            for $line in $body
            let $fields := tokenize($line, ',')
            return
                <person>
                    {
                    for $key at $pos in $fields
                        let $value := $fields[$pos]
                        return
                            element { $key } { $value }
                    }
                </person>
        }
    </listPlaces>
