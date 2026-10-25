\ Serialize ordered string maps to XML.

NEED ordered-maps

: xml.iter<>..<> { buf ior key-addr key-u value-addr value-u -- buf ior }
\ <Property ID="key">value</Property>
    buf
    ior if ior exit then
    s" Property" buf xml.<tag ?dup if exit then
    s" ID" key-addr key-u buf xml.keyval ?dup if exit then
    buf xml.> ?dup if exit then
    value-addr value-u buf xml.write ?dup if exit then
    s" Property" buf xml.</tag>
;

: xml.iter<..> { buf ior key-addr key-u value-addr value-u -- buf ior }
\ <Property ID="key" Value="value"/>
    buf
    ior if ior exit then
    s" Property" buf xml.<tag ?dup if exit then
    s" ID" key-addr key-u buf xml.keyval ?dup if exit then
    s" Value" value-addr value-u buf xml.keyval ?dup if exit then
    buf xml./>
;

: xml.write-map<>..<> ( map buf -- ior )
    0 ['] xml.iter<>..<> 3 roll map-for-each nip
;

: xml.write-map<..> ( map buf -- ior )
    0 ['] xml.iter<..> 3 roll map-for-each nip
;
