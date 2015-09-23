CXXFLAGS = -DHALF -O4 -Wall -DLEVELCOUNTS

default: all

CFILES = cubepos.h cubepos.cpp cubepos_test.cpp kocsymm.h kocsymm.cpp \
   kocsymm_test.cpp phase1prune.h phase1prune.cpp phase1prune_test.cpp \
   phase2prune.h phase2prune.cpp phase2prune_test.cpp twophase.cpp hcoset.cpp

HSOURCES = bestsol.h corner_order.h

MISCSOURCES = makefile twophase.html hcoset.html index.html

SOURCES = $(HSOURCES) $(MISCSOURCES)

BINARIES = twophase hcoset

TESTBINARIES = cubepos_test kocsymm_test phase2prune_test phase1prune_test

all: $(BINARIES) $(TESTBINARIES)

test: $(TESTBINARIES)
	./cubepos_test && ./kocsymm_test && ./phase2prune_test && ./phase1prune_test

dist:
	rm -rf dist
	mkdir dist
	cp $(SOURCES) dist
	tar czf dist.tar.gz dist

bigdist:
	rm -rf bigdist
	mkdir bigdist
	cp $(SOURCES) $(CFILES) bigdist
	tar czf bigdist.tar.gz bigdist

cubepos_test: cubepos.cpp cubepos.h cubepos_test.cpp
	$(CXX) $(CXXFLAGS) -o cubepos_test cubepos_test.cpp cubepos.cpp

kocsymm_test: kocsymm.cpp kocsymm.h kocsymm_test.cpp cubepos.h cubepos.cpp
	$(CXX) $(CXXFLAGS) -o kocsymm_test kocsymm_test.cpp kocsymm.cpp cubepos.cpp

phase2prune_test: phase2prune_test.cpp phase2prune.cpp phase2prune.h kocsymm.cpp kocsymm.h cubepos.h cubepos.cpp
	$(CXX) $(CXXFLAGS) -o phase2prune_test phase2prune_test.cpp phase2prune.cpp kocsymm.cpp cubepos.cpp

phase1prune_test: phase1prune_test.cpp phase1prune.cpp phase1prune.h kocsymm.cpp kocsymm.h cubepos.h cubepos.cpp
	$(CXX) $(CXXFLAGS) -o phase1prune_test phase1prune_test.cpp phase1prune.cpp kocsymm.cpp cubepos.cpp

twophase: twophase.cpp phase1prune.cpp phase1prune.h phase2prune.cpp phase2prune.h kocsymm.cpp kocsymm.h cubepos.cpp cubepos.h
	$(CXX) $(CXXFLAGS) -o twophase twophase.cpp phase1prune.cpp phase2prune.cpp kocsymm.cpp cubepos.cpp -lpthread

hcoset: hcoset.cpp phase1prune.cpp phase1prune.h kocsymm.cpp kocsymm.h cubepos.cpp cubepos.h bestsol.h corner_order.h
	$(CXX) $(CXXFLAGS) -o hcoset hcoset.cpp phase1prune.cpp kocsymm.cpp cubepos.cpp -lpthread

clean:
	rm -rf $(BINARIES) $(TESTBINARIES)
