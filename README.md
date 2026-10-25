# ForthXML
Simple XML typewriter in Forth

`xml_maptools.f` serializes ForthBase `ordered-maps` in insertion order.
Allocate maps with `allocate-map`, store string pairs with `map!` or `=>"`,
and release them with `free-map`. `map@` returns `( 0 0 )` for missing or
empty values. Keys are normalized to uppercase.

`xml.write-map<..> ( map buf -- ior )` writes empty Property tags with ID and
Value attributes; `xml.write-map<>..<> ( map buf -- ior )` writes Property tags
with text content. Both use `map-for-each` callbacks receiving the key and
value directly, including retained empty values. `erase-map` forgets keys;
`reset-map` retains their order and serializes empty values.
# Error handling

XML output words, including map writers, return native `ior` (zero on success).
Buffer overflow or an empty append reports the error and returns normally;
callers must discard incomplete output on nonzero `ior`. Allocation failures
remain fatal. The XML regression suites cover bounded-buffer failures and
continued use after an error.
