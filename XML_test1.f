\ test for XML.f
include "%idir%\..\ForthBase\libraries\libraries.f"
NEED buffers

include "%idir%\XML.f"
NEED simple-tester
	CR
	
	\ create a new buffer
	1024 allocate-buffer
	constant buf1 

	\ write some XML
	\ example from https://pixinsight.com/doc/docs/XISF-1.0-spec/XISF-1.0-spec.html
: test1 ( buf -- ior )
	>R 0
	R@ xml.<??> or
	
	s" Created with ForthXISF" R@ xml.comment or
	
	s" xisf" R@ xml.<tag or
		s" version" s" 1.0" R@ xml.keyval or
	R@ xml.> or
	
		s" Image" R@ xml.<tag or
			s" geometry" s" 6:6:3" R@ xml.keyval or
			s" sampleFormat" s" UInt8" R@ xml.keyval or
			s" colorSpace" s" RGB" R@ xml.keyval or
			s" location" s" embedded" R@ xml.keyval or
		R@ xml.> or
		
				s" Data" R@ xml.<tag or
					s" encoding" s" base64" R@ xml.keyval or
				R@ xml.> or
					s" AAAAAP8A/wD/AAAAAAAAAP8AAP8AAAAAAAAA/wD/AP8AAAAA/wD//wD/AP8AAP8A/wD//wD//wD//wD/AP8AAP8A/wD//wD/AP8AAAAAAAAA/wD/AP8AAAAAAAAAAP8A/wD/AAAAAAAAAP8A" R@ xml.write or
				s" Data" R@ xml.</tag> or
				
				s" Property" R@ xml.<tag or
					s" id" s" Observation:Center:RA" R@ xml.keyval or
					s" type" s" Float64" R@ xml.keyval or
					s" value" s" 195" R@ xml.keyval or
					s" .4998" R@ xml.append or		\ expect value="195.4998"
				R@ xml./> or
				
		s" Image" R@ xml.</tag> or
		
	s" xisf" R@ xml.</tag> or
	R> drop
;
Tstart
	T{ buf1 test1 }T 0 ==
	
	\ save the XML to a file
	s" %idir%\XML_test1.xml" r/w create-file drop
	constant test_fileid1
	buf1 test_fileid1 buffer-to-file 
	test_fileid1 close-file drop	
	
	\ open the reference XML file
	s" %idir%\XML_test1_reference.xml" r/o open-file drop
	constant test_fileid2
	test_fileid2 file-to-buffer
	constant buf2
	test_fileid2 close-file drop
	
	\ compare the buffers
	T{ buf1 buffer-to-string hashS }T buf2 buffer-to-string hashS ==

Tend
