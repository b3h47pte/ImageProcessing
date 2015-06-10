#ifndef __LANGUAGE_DISPATCH__
#define __LANGUAGE_DISPATCH__

@import Foundation;

@interface LanguageDispatch: NSObject

-(void) GaussianBlur:(UIImage* image);
-(void) LaplacianOfGaussianSharpen:(UIImage* image);
-(void) TwirlDistortion:(UIImage* image);

@end

#endif

