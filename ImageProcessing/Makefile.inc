CXX = g++
TARGET=$(MAKE_TARGET)
ifeq ($(strip $(MAKE_TARGET)),)
	TARGET = x86_64
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

METAL_BUILD_DIR=/Users/michaelbao/Github/ImageProcessing/ImageProcessing/MetalBuild.bundle
METAL_CXX=metal
METAL_CXX_FLAGS=-arch air64 -emit-llvm -c -gline-tables-only -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS8.3.sdk -ffast-math -std=ios-metal1.0
METAL_AR=metal-ar
METAL_AR_FLAGS=r $(METAL_BUILD_DIR)/filters.metal-ar
METAL_LIB=metallib
METAL_LIB_FLAGS=-o $(METAL_BUILD_DIR)/filters.metallib
