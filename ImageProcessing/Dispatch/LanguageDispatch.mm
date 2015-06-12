#import "LanguageDispatch.h"
#include <cstdlib>
#include <cstring>

@interface LanguageDispatch() 

@end

@implementation LanguageDispatch {

}

-(void) InterleaveChannels:(float*)data Width:(int)width Height:(int)height Channels:(int)channels {
    float* stage = new float[width * height * channels];
    for (int x = 0; x < width; ++x) {
        for (int y = 0; y < height; ++y) {
            for(int c = 0; c < channels; ++c) {
                int originalIndex = c * (width * height) + y * width + x;
                int index = y * (width * channels) + x * channels + c;
                stage[index] = data[originalIndex];
            }
        }
    }
    memcpy(data, stage, width * height * channels * sizeof(float)); 
    delete[] stage;
}

-(void) UninterleaveChannels:(float*)data Width:(int)width Height:(int)height Channels:(int)channels {
    float* stage = new float[width * height * channels];
    for (int x = 0; x < width; ++x) {
        for (int y = 0; y < height; ++y) {
            for(int c = 0; c < channels; ++c) {
                int index = c * (width * height) + y * width + x;
                int originalIndex = y * (width * channels) + x * channels + c;
                stage[index] = data[originalIndex];
            }
        }
    }
    memcpy(data, stage, width * height * channels * sizeof(float)); 
    delete[] stage;
}

-(float*) ConvertUnsignedCharBufferToFloat:(unsigned char*) input Length:(int)length {
    float* data = new float[length];
    for(int i = 0; i < length; ++i) {
        data[i] = (float)input[i] / 255;
    }
    return data;
}

-(unsigned char*) ConvertFloatBufferToUnsignedChar:(float*) input Length:(int)length {
    unsigned char* data = new unsigned char[length];
    for(int i = 0; i < length; ++i) {
        data[i] = input[i] * 255;
    }
    return data;
}

-(unsigned char*) GetRawByteDataFromImage:(UIImage*)image {
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    NSUInteger bytesPerRow = CGImageGetBytesPerRow(imageRef);
    NSUInteger bitsPerComponent = 8;
    NSUInteger bytesPerPixel = bytesPerRow / width;

    unsigned char* data = new unsigned char[width * height * bytesPerPixel];
    CGContextRef context = CGBitmapContextCreate(data, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);

    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    return data;
}

-(UIImage*) GetUIImageFromRawByteData:(unsigned char*)data Width:(int)width Height:(int) height Channels:(int) channels {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(data, width, height, 8, width * channels, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIImage* image = [[UIImage alloc] initWithCGImage:cgImage];
    return image;
}

-(UIImage*) GetUIImageFromFloatData:(float*)data Width:(int)width Height:(int) height Channels:(int) channels {
    unsigned char* byteData = [self ConvertFloatBufferToUnsignedChar:data Length:(width * height * channels)];
    UIImage* image = [self GetUIImageFromRawByteData:byteData Width:width Height:height Channels:channels];
    return image;
}

-(UIImage*) Brighten:(UIImage*) image {
    return NULL;
}

-(UIImage*) GaussianBlur:(UIImage*) image {
    return NULL;
}

-(UIImage*) LaplacianOfGaussianSharpen:(UIImage*) image {
    return NULL;
}

-(UIImage*) TwirlDistortion:(UIImage*) image {
    return NULL;
}

@end
