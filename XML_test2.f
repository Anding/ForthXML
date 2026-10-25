\ test for XML.f with ordered string maps
include "%idir%\..\ForthBase\libraries\libraries.f"
NEED buffers
NEED ordered-maps

include "%idir%\XML.f"
NEED simple-tester
	CR
	
	\ create maps of properties and values
	
	allocate-map CONSTANT XISFattribute
	s" 1" XISFattribute =>" Observation:Center:RA"
	s" 1" XISFattribute =>" Observation:Center:Dec"
	s" 1" XISFattribute =>" Observation:StartTime"
	s" 0" XISFattribute =>" Observation:Location:Name"
	
	allocate-map CONSTANT XISFtypes
	s" Float64" XISFtypes =>" Observation:Center:RA"
	s" Float64" XISFtypes =>" Observation:Center:Dec"
	s" TimePoint" XISFtypes =>" Observation:StartTime"
	s" String" XISFtypes =>" Observation:Location:Name"

	
	allocate-map CONSTANT XISFimage
	s" 195.4997911" XISFimage =>" Observation:Center:RA"
	s" 47.2661464" XISFimage =>" Observation:Center:Dec"
	s" '2024-03-15T02:55:15'" XISFimage =>" Observation:StartTime"
	s" Observatorio de Aras de los Olmos (OAO)" XISFimage =>" Observation:Location:Name"
	
	
	: xml-iterator { buf ior key-addr key-u value-addr value-u -- buf ior }
		buf
		ior if ior exit then
		s" Property" buf xml.<tag ?dup if exit then
		s" id" key-addr key-u buf xml.keyval ?dup if exit then
		s" type" key-addr key-u XISFtypes map@ buf xml.keyval ?dup if exit then
		key-addr key-u XISFattribute map@ toInteger if
			s" value" value-addr value-u buf xml.keyval ?dup if exit then
			buf xml./>
		else
			buf xml.> ?dup if exit then
			value-addr value-u buf xml.write ?dup if exit then
			s" Property" buf xml.</tag>
		then
	;
	
	\ create a new buffer
	1024 allocate-buffer
	constant buf1 

Tstart
	T{ buf1 0 ' xml-iterator XISFimage map-for-each nip }T 0 ==
	
	\ save the XML to a file
	s" %idir%\XML_test2.xml" r/w create-file drop
	constant test_fileid1
	buf1 test_fileid1 buffer-to-file 
	test_fileid1 close-file drop	
	
	\ open the reference XML file
	s" %idir%\XML_test2_reference.xml" r/o open-file drop
	constant test_fileid2
	test_fileid2 file-to-buffer
	constant buf2
	test_fileid2 close-file drop
	
	\ compare the buffers
	T{ buf1 buffer-to-string hashS }T buf2 buffer-to-string hashS ==

 Tend

	XISFattribute free-map
	XISFtypes free-map
	XISFimage free-map
	buf1 free-buffer
	buf2 free-buffer