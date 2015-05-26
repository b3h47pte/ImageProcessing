#ifndef __CONVOLUTION_HALIDE__
#define __CONVOLUTION_HALIDE__

#include "Halide.h"
using namespace Halide;

namespace IMP {

Func convolution(Func input, Func kernel, int width, int height) {
    Var x, y;
    Func convolute;
    RDom horzDomain(0, width);
    RDom vertDomain(0, height);
    convolute(x, y) = input(x, y);
    return convolute;
}

}

#endif
