#ifndef __HALIDE_DISPATCH__
#define __HALIDE_DISPATCH__

@import Foundation;
#import "Dispatch/LanguageDispatch.h"

@interface HalideDispatch: LanguageDispatch

-(void) GaussianBlur:(UIImage* image);
-(void) LaplacianOfGaussianSharpen:(UIImage* image);
-(void) TwirlDistortion:(UIImage* image);

@end


#endif
