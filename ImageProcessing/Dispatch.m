//
//  Dispatch.m
//  ImageProcessing
//
//  Created by Michael Bao on 6/9/15.
//  Copyright (c) 2015 Michael Bao. All rights reserved.
//

#import "Dispatch.h"
#import "Dispatch/LanguageDispatch.h"
#import "Dispatch/HalideDispatch.h"
#import "Dispatch/MetalDispatch.h"
#import <Foundation/Foundation.h>

static NSArray* filterOptions;
static NSArray* languageOptions;

@interface Dispatch()
    -(UIImage*) HalideDispatcher:(NSString*) filter Image:(UIImage*)image;
    -(UIImage*) MetalDispatcher:(NSString*) filter Image:(UIImage*)image;
    -(UIImage*) ObjCDispatcher:(NSString*) filter Image:(UIImage*)image;
    -(UIImage*) NEONDispatcher:(NSString*) filter Image:(UIImage*)image;
    -(UIImage*) OpenGLDispatcher:(NSString*) filter Image:(UIImage*)image;
    -(UIImage*) GenericDispatch:(NSString*) filter Image:(UIImage*)image Dispatch:(LanguageDispatch*) dispatch;
@end

@implementation Dispatch {
    // Language dispatch table -- Must be called first to get the object for which to call the filter selector.
    NSString* languageDispatchTable[5];
    // Filter dispatch table
    NSString* filterDispatchTable[4];
}

-(id) init {
    if (self = [super init] ) {
        languageDispatchTable[0] = @"HalideDispatcher:Image:";
        languageDispatchTable[1] = @"MetalDispatcher:Image:";
        languageDispatchTable[2] = @"ObjCDispatcher:Image:";
        languageDispatchTable[3] = @"NEONDispatcher:Image:";
        languageDispatchTable[4] = @"OpenGLDispatcher:Image:";
        
        filterDispatchTable[0] = @"GaussianBlur:";
        filterDispatchTable[1] = @"LaplacianOfGaussianSharpen:";
        filterDispatchTable[2] = @"TwirlDistortion:";
        filterDispatchTable[3] = @"Brighten:";
    }
    return self;
}

+(void) initialize {
    filterOptions = @[@"Gaussian", @"Laplacian of Gaussian Sharpen", @"Twirl (Distortion)", @"Brighten"];
    languageOptions = @[@"Halide", @"Metal", @"Objective C", @"Objective C + NEON", @"OpenGL ES"];
}

+(NSArray*) GetSupportedLanguages {
    return languageOptions;
}

+(NSArray*) GetSupportedFilters {
    return filterOptions;
}

-(UIImage*) RunFilterOnImage:(UIImage*)image WithFilter:(NSString*)filter Language:(NSString*)language {
    bool foundFilter = false;
    NSString* filterSelector;

    for(int i = 0; i < filterOptions.count; ++i) {
        if ([filter isEqualToString:[filterOptions objectAtIndex:i]]) {
            foundFilter = true;
            filterSelector = filterDispatchTable[i];
            break;
        }
    }

    if (!foundFilter) {
        return NULL;
    }

    for (int i = 0; i < languageOptions.count; ++i) {
        if ([language isEqualToString:[languageOptions objectAtIndex:i]] && [self respondsToSelector:NSSelectorFromString(languageDispatchTable[i])])  {
            SEL languageSelector = NSSelectorFromString(languageDispatchTable[i]);
            NSMethodSignature* signature = [Dispatch instanceMethodSignatureForSelector:languageSelector];
            NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setSelector:languageSelector];
            [invocation setTarget:self];
            [invocation setArgument:&filterSelector atIndex:2];
            [invocation setArgument:&image atIndex:3];

            CFTypeRef retImage;
            [invocation invoke];
            [invocation getReturnValue:&retImage];
            if (retImage) {
                CFRetain(retImage);
                UIImage* retUIImage = (__bridge_transfer UIImage*)retImage;
                return retUIImage; 
            }
            return NULL;
        }
    }

    return NULL;
}

-(UIImage*) GenericDispatch:(NSString*) filter Image:(UIImage*)image Dispatch:(LanguageDispatch*) dispatch {
    SEL selector = NSSelectorFromString(filter);
    if (![dispatch respondsToSelector:selector]) {
        return NULL;
    }
    NSMethodSignature* signature = [LanguageDispatch instanceMethodSignatureForSelector:selector];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:selector];
    [invocation setTarget:dispatch];
    [invocation setArgument:&image atIndex:2];

    CFTypeRef retImage;
    [invocation invoke];
    [invocation getReturnValue:&retImage];
    if (retImage) {
        CFRetain(retImage);
        UIImage* retUIImage = (__bridge_transfer UIImage*)retImage;
        return retUIImage;
    }
    return NULL;
}

-(UIImage*) HalideDispatcher:(NSString*) filter Image:(UIImage*)image {
    static HalideDispatch* dispatch = NULL;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        dispatch = [[HalideDispatch alloc] init];
    });
    return [self GenericDispatch:filter Image:image Dispatch:dispatch];
}

-(UIImage*) MetalDispatcher:(NSString*) filter Image:(UIImage*)image {
    static MetalDispatch* dispatch = NULL;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        dispatch = [[MetalDispatch alloc] init];
    });
    return [self GenericDispatch:filter Image:image Dispatch:dispatch];
}

-(UIImage*) ObjCDispatcher:(NSString*) filter Image:(UIImage*)image {
    return NULL;
}

-(UIImage*) NEONDispatcher:(NSString*) filter Image:(UIImage*)image {
    return NULL;
}

-(UIImage*) OpenGLDispatcher:(NSString*) filter Image:(UIImage*)image {
    return NULL;
}

@end

