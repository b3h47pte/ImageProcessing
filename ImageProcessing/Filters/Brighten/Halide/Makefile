include ../../../Makefile.inc

halide: halideBrightenGen.cpp
	$(CXX) $(HALIDE_CXX_FLAGS) $(HALIDE_LD_FLAGS) halideBrightenGen.cpp -o halideBrightenGen
	HL_TARGET=$(HALIDE_TARGET) DYLD_LIBRARY_PATH=$(HALIDE_DIR)/bin ./halideBrightenGen
	rm halideBrightenGen
