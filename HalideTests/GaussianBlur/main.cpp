#include <iostream>
#include "Filters/GaussianBlur/Halide/gaussianBlur.h"
#include "Halide.h"

using namespace Halide;
using Halide::Image;
#include "image_io.h"
int main(int argc, char** argv)
{
    Image<float> input = load<float>("/Users/michaelbao/Github/ImageProcessing/HalideTests/Images/test1.png");
    buffer_t output = {0};
    output.extent[0] = input.raw_buffer()->extent[0];
    output.extent[1] = input.raw_buffer()->extent[1];
    output.extent[2] = input.raw_buffer()->extent[2];
    output.stride[0] = input.raw_buffer()->stride[0];
    output.stride[1] = input.raw_buffer()->stride[1];
    output.stride[2] = input.raw_buffer()->stride[2];
    output.elem_size = input.raw_buffer()->elem_size;
    output.host = new uint8_t[4 * 3 * input.width() * input.height()];
    gaussianBlur(input.raw_buffer(), 3.0f, &output);

    Image<float> outputImage(&output);
    save(outputImage, "/Users/michaelbao/Github/ImageProcessing/HalideTests/Images/test1-gaussianBlur.png");
    return 0;
}
