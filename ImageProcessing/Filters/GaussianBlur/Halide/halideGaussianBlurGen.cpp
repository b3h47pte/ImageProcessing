#include "Halide.h"
#include "Utility/constants.h"
#include "Utility/Convolution/Halide/convolution.h"
using namespace Halide;

int main(int argc, char** argv) {
    Var x, y;
    // Generate a Gaussian Blur Kernel that can be used for convolution.
    ImageParam state(Float(32), 2);
    Param<float> sigma;
    int radius = ceil(sigma.get() * 3.f);

    // Implement Gaussian Blur like NVIDIA : http://http.developer.nvidia.com/GPUGems3/gpugems3_ch40.html
    // Gaussian Function
    Func gaussian;
    gaussian(x)  = exp(-x * x / (2.0f * sigma * sigma));

    Func image = BoundaryConditions::repeat_edge(state);

    RVar domain(-radius, radius);
    // Vertical Blur
//    Func vertBlur;
//    vertBlur(x, y) = gaussian(cast<int>(abs(domain))) * image(x, y + domain);
//
//    // Horizontal Blur
//    Func horzBlur;
//    horzBlur(x, y) = gaussian(cast<int>(abs(domain))) * image(x + domain, y);
    Func result;
    result(x, y) = image(x, y);
    result.compile_to_file("gaussianBlur", {state, sigma});

    return 0;
}
