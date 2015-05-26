#ifndef __CONVOLUTION_HALIDE__
#define __CONVOLUTION_HALIDE__

#include "Halide.h"
using namespace Halide;

namespace IMP {

Func convolution(Func input, Func kernel, int width, int height) {
    Var x, y;
    Func convolute;
    RDom horzDomain(-(width - 1)/2, width);
    RDom vertDomain(-(height - 1)/2, height);
    convolute(x, y) = input(x + horzDomain, y + vertDomain) * kernel(horzDomain, vertDomain);
    return convolute;
}

}

#endif
