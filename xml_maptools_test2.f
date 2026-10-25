\ test for XML.f

include "%idir%\..\ForthBase\libraries\libraries.f"
NEED buffers
NEED ordered-maps

include "%idir%\XML.f"
include "%idir%\xml_maptools.f"
NEED simple-tester

	CR
Tstart

	allocate-map CONSTANT emptyMap
	1024 allocate-buffer constant buf0
	T{ emptyMap buf0 xml.write-map<..> }T 0 ==
	
T{	buf0 buffer_used }T 0 ==		\ do nothing with an empty map
 
	allocate-map CONSTANT EuroForth
	s" Oxford" EuroForth =>" 2012"
	s" Hamburg" EuroForth =>" 2013"
	s" Palma" EuroForth =>" 2014"
	
	1024 allocate-buffer constant buf1
	
	
	T{ EuroForth buf1 xml.write-map<>..<> }T 0 ==
	
	\ serialize buf1 to a file
	s" %idir%\xml_maptools_test1_b.xml" r/w create-file drop
	constant test_fileid1
	buf1 test_fileid1 buffer-to-file 
	test_fileid1 close-file drop	

	\ open the reference XML file
	s" %idir%\xml_maptools_test1_reference_b.xml" r/o open-file drop
	constant test_fileid2
	test_fileid2 file-to-buffer
	constant buf2
	test_fileid2 close-file drop

T{ buf1 buffer-to-string hashS }T buf2 buffer-to-string hashS ==

	s" original" emptyMap =>" first"
	s" second" emptyMap =>" second"
	s" replacement" emptyMap =>" first"
	buf0 reset-buffer
T{ emptyMap buf0 xml.write-map<>..<> buf0 buffer-to-string hashS }T
	0 s\" <Property ID=\"FIRST\">\r\nreplacement</Property>\r\n<Property ID=\"SECOND\">\r\nsecond</Property>\r\n" hashS ==
	emptyMap reset-map
	buf0 reset-buffer
T{ emptyMap buf0 xml.write-map<>..<> buf0 buffer-to-string hashS }T
	0 s\" <Property ID=\"FIRST\">\r\n</Property>\r\n<Property ID=\"SECOND\">\r\n</Property>\r\n" hashS ==
	emptyMap erase-map
	buf0 reset-buffer
T{ emptyMap buf0 xml.write-map<>..<> buf0 buffer_used }T 0 0 ==
Tend
	CR

\ release resources
	buf0 free-buffer
	buf1 free-buffer
	buf2 free-buffer
	emptyMap free-map
	EuroForth free-map