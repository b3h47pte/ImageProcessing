#include "Halide.h"
#include "Utility/constants.h"
#include "Utility/Convolution/Halide/convolution.h"
using namespace Halide;

int main(int argc, char** argv) {
    Var x, y, c;
    // Generate a Gaussian Blur Kernel that can be used for convolution.
    ImageParam state(Float(32), 3);
    Param<float> sigma;
    Expr radius = ceil(sigma * 3.f);

    // Implement Gaussian Blur like NVIDIA : http://http.developer.nvidia.com/GPUGems3/gpugems3_ch40.html
    // Gaussian Function
    Func gaussian;
    gaussian(x) = exp(-x * x / (2.0f * sigma * sigma)) / (sqrtf(2.f * IMP::PI) * sigma);

    Func image = BoundaryConditions::repeat_edge(state);

    Expr domainWidth = 2 * radius + 1;
    RDom gaussDomain(-radius, domainWidth);
    // Vertical
    Func vertGaussian;
    vertGaussian(x, y, c) = gaussian(y) / sum(gaussian(gaussDomain));
    
    // Horizontal 
    Func horzGaussian;
    horzGaussian(x, y, c) = gaussian(x) / sum(gaussian(gaussDomain));

    // Convolute Horizontal and Vertical
    Func stepImage = IMP::convolution(image, vertGaussian, 0, 1, -radius, domainWidth);
    Func finalImage = IMP::convolution(stepImage, horzGaussian, -radius, domainWidth, 0, 1);
    finalImage.compile_to_file("gaussianBlur", {state, sigma});

    return 0;
}
