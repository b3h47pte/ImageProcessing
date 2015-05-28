#ifndef __CONVOLUTION_HALIDE__
#define __CONVOLUTION_HALIDE__

#include "Halide.h"
using namespace Halide;

namespace IMP {

Func convolution(Func input, Func kernel, Expr xStart, Expr xWidth, Expr yStart, Expr yWidth) {
    Var x, y, c;
    RDom domain(xStart, xWidth, yStart, yWidth);
    Func convolute;
    convolute(x, y, c) += input(x + domain.x, y + domain.y, c) * kernel(domain.x, domain.y, c);
    return convolute;
}

}

#endif
