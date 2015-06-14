#ifndef __METAL_DISPATCH__
#define __METAL_DISPATCH__

#import "LanguageDispatch.h"

@import Foundation;
@import UIKit;

@interface MetalDispatch: LanguageDispatch
-(id) init;

-(UIImage*) Brighten:(UIImage*) image;
-(UIImage*) GaussianBlur:(UIImage*) image;
-(UIImage*) LaplacianOfGaussianSharpen:(UIImage*) image;
-(UIImage*) TwirlDistortion:(UIImage*) image;
@end

#endif


