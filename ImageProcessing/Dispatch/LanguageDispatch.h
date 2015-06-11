#ifndef __LANGUAGE_DISPATCH__
#define __LANGUAGE_DISPATCH__

@import Foundation;
@import UIKit;

@interface LanguageDispatch: NSObject

// Convert between UIImage and Raw Byte Data.
-(unsigned char*) GetRawByteDataFromImage:(UIImage*)image;
-(UIImage*) GetUIImageFromRawByteData:(unsigned char*)data Width:(int)width Height:(int) height;

-(UIImage*) GaussianBlur:(UIImage*) image;
-(UIImage*) LaplacianOfGaussianSharpen:(UIImage*) image;
-(UIImage*) TwirlDistortion:(UIImage*) image;

@end

#endif

