\ serialize a forth-map structure to an XML file
\ requires forth-map/map.fs, forth-map/map-tools.fs
\ requires 

: xml.iterator ( buf c-addr u map -- buf)
\ forth-map iterator
	>R rot R> swap >R								( c-addr u map R:buf)
	s" Property" R@ xml.<tag	
	-rot 2dup s" ID" 2swap R@ xml.keyval 	( c-addr u map R:buf)
	rot >string				      				( c-addr u R:buf)		
	s" Value" 2swap R@ xml.keyval				( R:buf)
	R@ xml./>
	R>
;

: xml.write-map ( map buf --)
\ write out a forth-map to a buffer in xml empty-tag format
\ <Property key="key" value="value"/>
\ the map values are counted strings
	['] xml.iterator rot ( buf xt map) simple-iterate-map
	drop
;

