\ Serialize ordered string maps to XML.

NEED ordered-maps

: xml.iter<>..<> { buf key-addr key-u value-addr value-u -- buf }
\ <Property ID="key">value</Property>
    s" Property" buf xml.<tag
    s" ID" key-addr key-u buf xml.keyval
    buf xml.>
    value-addr value-u buf xml.write
    s" Property" buf xml.</tag>
    buf
;

: xml.iter<..> { buf key-addr key-u value-addr value-u -- buf }
\ <Property ID="key" Value="value"/>
    s" Property" buf xml.<tag
    s" ID" key-addr key-u buf xml.keyval
    s" Value" value-addr value-u buf xml.keyval
    buf xml./>
    buf
;

: xml.write-map<>..<> ( map buf -- )
    ['] xml.iter<>..<> rot map-for-each drop
;

: xml.write-map<..> ( map buf -- )
    ['] xml.iter<..> rot map-for-each drop
;
