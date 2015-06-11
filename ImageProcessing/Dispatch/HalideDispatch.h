#ifndef __HALIDE_DISPATCH__
#define __HALIDE_DISPATCH__

#import "LanguageDispatch.h"

@import Foundation;
@import UIKit;

@interface HalideDispatch: LanguageDispatch

-(UIImage*) GaussianBlur:(UIImage*) image;
-(UIImage*) LaplacianOfGaussianSharpen:(UIImage*) image;
-(UIImage*) TwirlDistortion:(UIImage*) image;

@end


#endif
