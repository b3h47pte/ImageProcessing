CXX = g++
TARGET=$(MAKE_TARGET)
ifeq ($(strip $(MAKE_TARGET)),)
	TARGET = x86-64
else
	TARGET = $(MAKE_TARGET)
endif

MAIN_SRC_DIR=/Users/michaelbao/Github/ImageProcessing/ImageProcessing

HALIDE_DIR = /Users/michaelbao/Documents/halide
HALIDE_CXX_FLAGS = -I$(MAIN_SRC_DIR) -I$(HALIDE_DIR)/include -arch $(TARGET) -std=gnu++11
HALIDE_LD_FLAGS = -L$(HALIDE_DIR)/bin -lHalide

ifeq ($(strip $(MAKE_HALIDE_TARGET)),)
	HALIDE_TARGET = x86-64
else
	HALIDE_TARGET = $(MAKE_HALIDE_TARGET)
endif
