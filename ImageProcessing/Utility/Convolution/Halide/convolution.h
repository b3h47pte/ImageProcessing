#ifndef __CONVOLUTION_HALIDE__
#define __CONVOLUTION_HALIDE__

#include "Halide.h"
using namespace Halide;

namespace IMP {

Func convolution(Func input, Func kernel, Expr xStart, Expr xWidth, Expr yStart, Expr yWidth) {
    Var x, y;
    Func convolute;
    RDom domain(xStart, xWidth, yStart, yWidth);
    convolute(x, y) = 0.f;
    convolute(x, y) += input(x + domain.x, y + domain.y) * kernel(domain.x, domain.y);
    return convolute;
}

}

#endif
