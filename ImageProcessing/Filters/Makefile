include ../Makefile.inc

halide:
	$(MAKE) -C GaussianBlur halide
	$(MAKE) -C Brighten halide

metal:
	$(MAKE) -C GaussianBlur metal
	$(MAKE) -C Brighten metal

clean:
	$(MAKE) -C GaussianBlur clean
	$(MAKE) -C Brighten clean
