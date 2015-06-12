#include "Halide.h"
#include "Utility/constants.h"
using namespace Halide;

int main(int argc, char** argv) {
    Var x, y, c;
    ImageParam state(Float(32), 3);
    Func image = BoundaryConditions::repeat_edge(state);
    Func finalImage;
    finalImage(x, y, c) = clamp(image(x, y, c) + 0.2f, 0.f, 1.f);
    finalImage.compile_to_file("brighten", {state});
    return 0;
}
