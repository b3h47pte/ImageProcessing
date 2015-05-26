CXX = g++
TARGET=x86_64
MAIN_SRC_DIR=/Users/michaelbao/Github/ImageProcessing/ImageProcessing

HALIDE_DIR = /Users/michaelbao/Documents/halide
HALIDE_CXX_FLAGS = -I$(MAIN_SRC_DIR) -I$(HALIDE_DIR)/include -arch $(TARGET) -std=gnu++11
HALIDE_LD_FLAGS = -L$(HALIDE_DIR)/bin -lHalide
HALIDE_TARGET = x86-64
