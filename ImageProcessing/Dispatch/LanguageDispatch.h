#ifndef __LANGUAGE_DISPATCH__
#define __LANGUAGE_DISPATCH__

@import Foundation;
@import UIKit;

@interface LanguageDispatch: NSObject

-(void) InterleaveChannels:(float*)data Width:(int)width Height:(int)height Channels:(int)channels;
-(void) UninterleaveChannels:(float*)data Width:(int)width Height:(int)height Channels:(int)channels;

// Convert between UIImage and Raw Byte Data.
-(unsigned char*) ConvertFloatBufferToUnsignedChar:(float*) input Length:(int)length;
-(float*) ConvertUnsignedCharBufferToFloat:(unsigned char*) input Length:(int)length;
-(unsigned char*) GetRawByteDataFromImage:(UIImage*)image;
-(UIImage*) GetUIImageFromRawByteData:(unsigned char*)data Width:(int)width Height:(int) height Channels:(int) channels;
-(UIImage*) GetUIImageFromFloatData:(float*)data Width:(int)width Height:(int) height Channels:(int) channels;

-(UIImage*) Brighten:(UIImage*) image;
-(UIImage*) GaussianBlur:(UIImage*) image;
-(UIImage*) LaplacianOfGaussianSharpen:(UIImage*) image;
-(UIImage*) TwirlDistortion:(UIImage*) image;

@end

#endif

