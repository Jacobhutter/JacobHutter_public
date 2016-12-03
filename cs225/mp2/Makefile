CXX = clang++
LD = clang++



CXXFLAGS = -std=c++1y -stdlib=libc++ -c -g -O0 -Wall -Wextra -Werror -pedantic
LDFLAGS = -std=c++1y -stdlib=libc++ -lpng -lc++abi -lpthread 
testscene : scene.o png.o image.o testscene.o rgbapixel.o
	$(CXX) $(LDFLAGS) $?  -o testscene 
testimage : image.o rgbapixel.o png.o testimage.o
	$(CXX) $(LDFLAGS) $?  -o testimage
testscene.o : testscene.cpp
	$(CXX) $(CXXFLAGS) $?
testimage.o : testimage.cpp
	$(CXX) $(CXXFLAGS) $?
scene.o : scene.cpp scene.h
	$(CXX) $(CXXFLAGS) scene.cpp
image.o :  image.cpp image.h
	$(CXX) $(CXXFLAGS) image.cpp 
rgbapixel.o : rgbapixel.cpp rgbapixel.h
	$(CXX) $(CXXFLAGS) rgbapixel.cpp
png.o :  png.cpp png.h
	$(CXX) $(CXXFLAGS) png.cpp
clean : 
	rm testscene testscene.o  rgbapixel.o image.o  png.o scene.o
 
