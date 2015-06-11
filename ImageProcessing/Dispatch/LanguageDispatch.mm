#import "LanguageDispatch.h"

@interface LanguageDispatch() 

@end

@implementation LanguageDispatch {

}

-(unsigned char*) GetRawByteDataFromImage:(UIImage*)image {
    return NULL;
}

-(UIImage*) GetUIImageFromRawByteData:(unsigned char*)data Width:(int)width Height:(int) height {
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
