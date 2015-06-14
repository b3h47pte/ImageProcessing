#import "HalideDispatch.h"
#include "../Filters/GaussianBlur/Halide/gaussianBlur.h"
#include "../Filters/Brighten/Halide/brighten.h"

@interface HalideDispatch()
-(void) BrightenHelper:(NSData*) input Output:(NSData*) output;
-(void) GaussianBlurHelper:(NSData*) input Output:(NSData*) output;
@end

@implementation HalideDispatch {
}

-(buffer_t*) UnpackNSDataToBuffer:(NSData*)data {
    buffer_t* output = NULL;
    [data getBytes:&output length:sizeof(buffer_t*)];
    return output;
}

-(UIImage*) HalideDispatchHelper:(SEL) func Image:(UIImage*) image {
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    NSUInteger bytesPerRow = CGImageGetBytesPerRow(imageRef);
    NSUInteger bytesPerPixel = bytesPerRow / width; // Assume each byte is a component.

    unsigned char* data = [self GetRawByteDataFromImage:image];
    float* floatData = [self ConvertUnsignedCharBufferToFloat:data Length:(width * height * bytesPerPixel)];
    [self UninterleaveChannels:floatData Width:width Height:height Channels:bytesPerPixel];
    delete[] data;

    buffer_t input = {0};
    buffer_t* inputAddress = &input;
    buffer_t** dpInputAddress = &inputAddress;
    buffer_t output = {0};
    buffer_t* outputAddress = &output;
    buffer_t** dpOutputAddress = &outputAddress;
    input.extent[0] = output.extent[0] = bytesPerPixel;
    input.extent[1] = output.extent[1] = width;
    input.extent[2] = output.extent[2] = height;
    input.stride[0] = output.stride[0] = 1;
    input.stride[1] = output.stride[1] = bytesPerPixel;
    input.stride[2] = output.stride[2] = bytesPerPixel * width;
    input.elem_size = output.elem_size = bytesPerPixel;

    NSData* inputData = [NSData dataWithBytes:dpInputAddress length:sizeof(buffer_t*)];
    NSData* outputData = [NSData dataWithBytes:dpOutputAddress length:sizeof(buffer_t*)];

    input.host = (uint8_t*)floatData;
    float* outputPixels = new float[width * height * 4];
    output.host = (uint8_t*)outputPixels;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:func withObject:inputData withObject:outputData];
#pragma clang diagnostic pop
    [self InterleaveChannels:outputPixels Width:width Height:height Channels:bytesPerPixel];
    UIImage* retImage = [self GetUIImageFromFloatData:outputPixels Width:width Height:height Channels:bytesPerPixel];
    delete[] outputPixels;
    return retImage;
}

-(void) BrightenHelper:(NSData*) input Output:(NSData*) output {
    brighten([self UnpackNSDataToBuffer:input], [self UnpackNSDataToBuffer:output]);
}

-(UIImage*) Brighten:(UIImage*) image {
    return [self HalideDispatchHelper:@selector(BrightenHelper:Output:) Image:image];
}

-(void) GaussianBlurHelper:(NSData*) input Output:(NSData*) output {
    gaussianBlur([self UnpackNSDataToBuffer:input], 1.f, [self UnpackNSDataToBuffer:output]);
}

-(UIImage*) GaussianBlur:(UIImage*) image {
    return [self HalideDispatchHelper:@selector(GaussianBlurHelper:Output:) Image:image];
}

-(UIImage*) LaplacianOfGaussianSharpen:(UIImage*) image {
    return NULL;
}

-(UIImage*) TwirlDistortion:(UIImage*) image {
    return NULL;
}


@end
