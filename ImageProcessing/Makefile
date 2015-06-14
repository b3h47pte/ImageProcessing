include Makefile.inc

halide:
	$(MAKE) -C Filters halide

metal:
	mkdir -p $(METAL_BUILD_DIR)
	$(MAKE) -C Filters metal
	$(METAL_AR) $(METAL_AR_FLAGS) $(METAL_BUILD_DIR)/*
	$(METAL_LIB) $(METAL_LIB_FLAGS) $(METAL_BUILD_DIR)/filters.metal-ar

clean:
	$(MAKE) -C Filters clean
