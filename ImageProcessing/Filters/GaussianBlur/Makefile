include ../../Makefile.inc

.PHONY: halide
halide:
	$(MAKE) -C Halide halide

.PHONY: metal
metal:
	$(MAKE) -C Metal metal

clean:
	$(MAKE) -C Halide clean
	$(MAKE) -C Metal clean
