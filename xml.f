\ simple xml writer
NEED buffers

: xml.write ( c-addr u buf -- ior )
	write-buffer dup if cr ." XML buffer full" cr then
;

: xml.echo ( c buf -- ior )
	echo-buffer dup if cr ." XML buffer full" cr then
;	

: xml.<??> ( buf -- ior )
\ write the full XML prolog tag and newline (Windows format)
	s\" <?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n" rot xml.write
;

: xml.<tag { caddr u buf -- ior }
\ open an XML start-tag or empty-element-tag
	'<' buf xml.echo ?dup if exit then
	caddr u buf xml.write
;

: xml.> ( buf -- ior )
\ close an XML start-tag and newline (Windows format)
	s\" >\r\n" rot xml.write
;

: xml./> ( buf -- ior )
\ close an XML empty-element tag and newline (Windows format)
	s\"  />\r\n" rot xml.write
;

: xml.</tag> { caddr u buf -- ior }
\ write an XML end-tag and newline (Windows format)
	s" </" buf xml.write ?dup if exit then
	caddr u buf xml.write ?dup if exit then
	s\" >\r\n" buf xml.write
;

: xml.keyval { key-addr key-u value-addr value-u buf -- ior }
\ write a key (c-addr1 u1) value (c-addr2 u2) pair
	BL buf xml.echo ?dup if exit then
	key-addr key-u buf xml.write ?dup if exit then
	s\" =\"" buf xml.write ?dup if exit then
	value-addr value-u buf xml.write ?dup if exit then
	'"' buf xml.echo
;

: xml.append { caddr u buf -- ior }
\ append a strng to the value just written and reclose
	buf backspace-buffer if cr ." XML buffer empty" cr -1 exit then
	caddr u buf xml.write ?dup if exit then
	'"' buf xml.echo
;

: xml.comment { caddr u buf -- ior }
\ write an XML comment
	s" <!-- " buf xml.write ?dup if exit then
	caddr u buf xml.write ?dup if exit then
	s\"  -->\r\n" buf xml.write
;
	