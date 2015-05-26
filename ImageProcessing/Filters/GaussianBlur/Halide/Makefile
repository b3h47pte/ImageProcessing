include ../../../Makefile.inc

halide: halideGaussianBlurGen.cpp
	$(CXX) $(HALIDE_CXX_FLAGS) $(HALIDE_LD_FLAGS) halideGaussianBlurGen.cpp -o halideGaussianBlurGen
	HL_TARGET=$(HALIDE_TARGET) DYLD_LIBRARY_PATH=$(HALIDE_DIR)/bin ./halideGaussianBlurGen 
	rm halideGaussianBlurGen
