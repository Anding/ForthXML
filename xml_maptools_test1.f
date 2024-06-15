\ test for XML.f

include "%idir%\..\forth-map\map.fs"
include "%idir%\..\forth-map\map-tools.fs"
include "%idir%\..\ForthBase\buffers\buffers.f"
include "%idir%\XML.f"
include "%idir%\xml_maptools.f"
include "%idir%\..\simple-tester\simple-tester.f"

	CR
Tstart

	256 -> map.space					\ prepare for counted string storage
	
	map CONSTANT emptyMap
	1024 allocate-buffer constant buf0
	emptyMap buf0 xml.write-map
	
T{	buf0 buffer_used }T 0 ==		\ do nothing with an empty map
 
	map CONSTANT EuroForth
	s" 2012" EuroForth >addr s" Oxford" rot place \ string-store, i.e. $!
	s" 2013" EuroForth >addr s" Hamburg" rot place
	s" 2014" EuroForth >addr s" Palma" rot place
	
	1024 allocate-buffer constant buf1 
	
	EuroForth buf1 xml.write-map
	
	\ serialize buf1 to a file
	s" %idir%\xml_maptools_test1.xml" r/w create-file drop
	constant test_fileid1
	buf1 test_fileid1 buffer-to-file 
	test_fileid1 close-file drop	

	\ open the reference XML file
	s" %idir%\xml_maptools_test1_reference.xml" r/o open-file drop
	constant test_fileid2
	test_fileid2 file-to-buffer
	constant buf2
	test_fileid2 close-file drop

T{ buf1 buffer-to-string hashS }T buf2 buffer-to-string hashS ==
Tend
	CR
	
\ review buffers
	buf1 buffer-to-string dump
	buf2 buffer-to-string dump                  

\ release resources
	buf0 free-buffer
	buf1 free-buffer
	buf2 free-buffer