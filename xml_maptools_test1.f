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
	
	
	T{ EuroForth buf1 xml.write-map<..> }T 0 ==
	
	\ serialize buf1 to a file
	s" %idir%\xml_maptools_test1_a.xml" r/w create-file drop
	constant test_fileid1
	buf1 test_fileid1 buffer-to-file 
	test_fileid1 close-file drop	

	\ open the reference XML file
	s" %idir%\xml_maptools_test1_reference_a.xml" r/o open-file drop
	constant test_fileid2
	test_fileid2 file-to-buffer
	constant buf2
	test_fileid2 close-file drop

T{ buf1 buffer-to-string hashS }T buf2 buffer-to-string hashS ==

	s" original" emptyMap =>" first"
	s" second" emptyMap =>" second"
	s" replacement" emptyMap =>" first"
	buf0 reset-buffer
T{ emptyMap buf0 xml.write-map<..> buf0 buffer-to-string hashS }T
	0 s\" <Property ID=\"FIRST\" Value=\"replacement\" />\r\n<Property ID=\"SECOND\" Value=\"second\" />\r\n" hashS ==
	emptyMap reset-map
	buf0 reset-buffer
T{ emptyMap buf0 xml.write-map<..> buf0 buffer-to-string hashS }T
	0 s\" <Property ID=\"FIRST\" Value=\"\" />\r\n<Property ID=\"SECOND\" Value=\"\" />\r\n" hashS ==
	emptyMap erase-map
	buf0 reset-buffer
T{ emptyMap buf0 xml.write-map<..> buf0 buffer_used }T 0 0 ==
	4 allocate-buffer constant small-buffer
T{ s" too long" small-buffer xml.write 0<> small-buffer buffer_used }T -1 0 ==
T{ s" x" small-buffer xml.write }T 0 ==
	small-buffer reset-buffer
T{ s" x" small-buffer xml.append }T -1 ==
	s" Oxford" emptyMap =>" 2012"
T{ emptyMap small-buffer xml.write-map<..> 0<> }T -1 ==
T{ depth }T 0 ==
	small-buffer free-buffer
Tend
	CR

\ release resources
	buf0 free-buffer
	buf1 free-buffer
	buf2 free-buffer
	emptyMap free-map
	EuroForth free-map