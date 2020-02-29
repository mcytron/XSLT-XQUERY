xquery version "3.1";
let $log-in := xmldb:login("/db", "admin", "jeanluc23")
let $source-doc := util:binary-doc('/db/madrid/csv/places-obratds.csv')
let $source-doc2 := util:binary-doc('/db/madrid/csv/places-demonyms-obratds.csv')
let $source-doc3 := util:binary-doc('/db/madrid/csv/obras-obratds.csv')
let $source-doc4 := util:binary-doc('/db/madrid/csv/people-obratds.csv')
let $source-doc5 := util:binary-doc('/db/madrid/csv/collectives-obratds.csv')
let $source-doc-obralmi := util:binary-doc('/db/madrid/csv/places-obralmi.csv')
let $source-doc-obralde := util:binary-doc('/db/madrid/csv/places-obralde.csv')
let $source-doc-obralbu := util:binary-doc('/db/madrid/csv/places-obralbu.csv')
let $source-doc-obrains := util:binary-doc('/db/madrid/csv/places-obrains.csv')
let $source-doc-obralct := util:binary-doc('/db/madrid/csv/places-obralct.csv')
let $source-doc-obrahor := util:binary-doc('/db/madrid/csv/places-obrahor.csv')
let $source-doc-obralpi := util:binary-doc('/db/madrid/csv/places-obralpi.csv')
let $source-doc-obraldb := util:binary-doc('/db/madrid/csv/places-obraldb.csv')
let $source-doc-obraesm := util:binary-doc('/db/madrid/csv/places-obraesm.csv')
let $source-doc-obralmi-p := util:binary-doc('/db/madrid/csv/people-obralmi.csv')
let $source-doc-obralde-p := util:binary-doc('/db/madrid/csv/people-obralde.csv')
let $source-doc-obralbu-p := util:binary-doc('/db/madrid/csv/people-obralbu.csv')
let $source-doc-obrains-p := util:binary-doc('/db/madrid/csv/people-obrains.csv')
let $source-doc-obralct-p := util:binary-doc('/db/madrid/csv/people-obralct.csv')
let $source-doc-obrahor-p := util:binary-doc('/db/madrid/csv/people-obrahor.csv')
let $source-doc-obralpi-p := util:binary-doc('/db/madrid/csv/people-obralpi.csv')
let $source-doc-obraldb-p := util:binary-doc('/db/madrid/csv/people-obraldb.csv')
let $source-doc-obraesm-p := util:binary-doc('/db/madrid/csv/people-obraesm.csv')
let $source-doc-obratds-p := util:binary-doc('/db/madrid/csv/people-obratds.csv')
let $source-doc-obralmi-w := util:binary-doc('/db/madrid/csv/works-obralmi.csv')
let $source-doc-obralde-w := util:binary-doc('/db/madrid/csv/works-obralde.csv')
let $source-doc-obralbu-w := util:binary-doc('/db/madrid/csv/works-obralbu.csv')
let $source-doc-obrains-w := util:binary-doc('/db/madrid/csv/works-obrains.csv')
let $source-doc-obralct-w := util:binary-doc('/db/madrid/csv/works-obralct.csv')
let $source-doc-obrahor-w := util:binary-doc('/db/madrid/csv/works-obrahor.csv')
let $source-doc-obralpi-w := util:binary-doc('/db/madrid/csv/works-obralpi.csv')
let $source-doc-obraldb-w := util:binary-doc('/db/madrid/csv/works-obraldb.csv')
let $source-doc-obraesm-w := util:binary-doc('/db/madrid/csv/works-obraesm.csv')
let $source-doc-obratds-w := util:binary-doc('/db/madrid/csv/works-obratds.csv')
let $source-doc-obratds-stats := util:binary-doc('/db/madrid/csv/stats-obratds.csv')
let $source-doc-obratds-stats-perc := util:binary-doc('/db/madrid/csv/stats-perc-obratds.csv')
let $source-doc-obratds-stats-madrid := util:binary-doc('/db/madrid/csv/stats-placename-madrid.csv')


let $source-doc-tds-people := doc('/db/madrid/xml/tds-people.xml')

return 
    (file:serialize-binary($source-doc, '/var/www/html/readingspain.com/public_html/tds-data/places-obratds.csv'),
     file:serialize-binary($source-doc2, '/var/www/html/readingspain.com/public_html/tds-data/places-demonyms-obratds.csv'),
   (:  file:serialize-binary($source-doc3, '/var/www/html/readingspain.com/public_html/tds-data/obras-obratds.csv'),:)
     file:serialize-binary($source-doc4, '/var/www/html/readingspain.com/public_html/tds-data/people-obratds.csv'),
     file:serialize-binary($source-doc5, '/var/www/html/readingspain.com/public_html/tds-data/collectives-obratds.csv'),
     file:serialize-binary($source-doc-obralmi, '/var/www/html/readingspain.com/public_html/tds-data/places-obralmi.csv'),
     file:serialize-binary($source-doc-obralde, '/var/www/html/readingspain.com/public_html/tds-data/places-obralde.csv'),
     file:serialize-binary($source-doc-obralbu, '/var/www/html/readingspain.com/public_html/tds-data/places-obralbu.csv'),
     file:serialize-binary($source-doc-obrains, '/var/www/html/readingspain.com/public_html/tds-data/places-obrains.csv'),
     file:serialize-binary($source-doc-obralct, '/var/www/html/readingspain.com/public_html/tds-data/places-obralct.csv'),
     file:serialize-binary($source-doc-obrahor, '/var/www/html/readingspain.com/public_html/tds-data/places-obrahor.csv'),
     file:serialize-binary($source-doc-obralpi, '/var/www/html/readingspain.com/public_html/tds-data/places-obralpi.csv'),
     file:serialize-binary($source-doc-obraldb, '/var/www/html/readingspain.com/public_html/tds-data/places-obraldb.csv'),
     file:serialize-binary($source-doc-obraesm, '/var/www/html/readingspain.com/public_html/tds-data/places-obraesm.csv'),
     file:serialize-binary($source-doc-obralmi-p, '/var/www/html/readingspain.com/public_html/tds-data/people-obralmi.csv'),
     file:serialize-binary($source-doc-obralde-p, '/var/www/html/readingspain.com/public_html/tds-data/people-obralde.csv'),
     file:serialize-binary($source-doc-obralbu-p, '/var/www/html/readingspain.com/public_html/tds-data/people-obralbu.csv'),
     file:serialize-binary($source-doc-obrains-p, '/var/www/html/readingspain.com/public_html/tds-data/people-obrains.csv'),
     file:serialize-binary($source-doc-obralct-p, '/var/www/html/readingspain.com/public_html/tds-data/people-obralct.csv'),
     file:serialize-binary($source-doc-obrahor-p, '/var/www/html/readingspain.com/public_html/tds-data/people-obrahor.csv'),
     file:serialize-binary($source-doc-obralpi-p, '/var/www/html/readingspain.com/public_html/tds-data/people-obralpi.csv'),
     file:serialize-binary($source-doc-obraldb-p, '/var/www/html/readingspain.com/public_html/tds-data/people-obraldb.csv'),
     file:serialize-binary($source-doc-obraesm-p, '/var/www/html/readingspain.com/public_html/tds-data/people-obraesm.csv'),
     file:serialize-binary($source-doc-obratds-p, '/var/www/html/readingspain.com/public_html/tds-data/people-obratds.csv'),
     file:serialize-binary($source-doc-obralmi-w, '/var/www/html/readingspain.com/public_html/tds-data/works-obralmi.csv'),
     file:serialize-binary($source-doc-obralde-w, '/var/www/html/readingspain.com/public_html/tds-data/works-obralde.csv'),
     file:serialize-binary($source-doc-obralbu-w, '/var/www/html/readingspain.com/public_html/tds-data/works-obralbu.csv'),
     file:serialize-binary($source-doc-obrains-w, '/var/www/html/readingspain.com/public_html/tds-data/works-obrains.csv'),
     file:serialize-binary($source-doc-obralct-w, '/var/www/html/readingspain.com/public_html/tds-data/works-obralct.csv'),
     file:serialize-binary($source-doc-obrahor-w, '/var/www/html/readingspain.com/public_html/tds-data/works-obrahor.csv'),
     file:serialize-binary($source-doc-obralpi-w, '/var/www/html/readingspain.com/public_html/tds-data/works-obralpi.csv'),
     file:serialize-binary($source-doc-obraldb-w, '/var/www/html/readingspain.com/public_html/tds-data/works-obraldb.csv'),
     file:serialize-binary($source-doc-obraesm-w, '/var/www/html/readingspain.com/public_html/tds-data/works-obraesm.csv'),
     file:serialize-binary($source-doc-obratds-w, '/var/www/html/readingspain.com/public_html/tds-data/works-obratds.csv'),
     file:serialize-binary($source-doc-obratds-stats, '/var/www/html/readingspain.com/public_html/tds-data/stats-obratds.csv'),
        file:serialize-binary($source-doc-obratds-stats-perc, '/var/www/html/readingspain.com/public_html/tds-data/stats-perc-obratds.csv'),
         file:serialize-binary($source-doc-obratds-stats-madrid, '/var/www/html/readingspain.com/public_html/tds-data/stats-placename-madrid.csv'),
     file:serialize($source-doc-tds-people, '/var/www/html/readingspain.com/public_html/tds-people.xml', ("omit-xml-declaration=yes", "indent=yes")))
     