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
#import <Foundation/Foundation.h>

static NSArray* filterOptions = @[@"Gaussian", @"Laplacian of Gaussian Sharpen", @"Twirl (Distortion)"];
static NSArray* languageOptions = @[@"Halide", @"Metal", @"Objective C", @"Objective C + NEON", @"OpenGL ES"];

@interface Dispatch()
    -(void) HalideDispatcher:SEL filter Image:(UIImage*)image;
    -(void) MetalDispatcher:SEL filter Image:(UIImage*)image;
    -(void) ObjCDispatcher:SEL filter Image:(UIImage*)image;
    -(void) NEONDispatcher:SEL filter Image:(UIImage*)image;
    -(void) OpenGLDispatcher:SEL filter Image:(UIImage*)image;
    -(void) GenericDispatch:SEL filter Image:(UIImage*)image Dispatch:(LanguageDispatch*) dispatch;
@end

@implementation Dispatch {
    // Language dispatch table -- Must be called first to get the object for which to call the filter selector.
    SEL languageDispatchTable[5] = {
        @selector(HalideDispatcher:Image:),
        @selector(MetalDispatcher:Image:),
        @selector(ObjCDispatcher:Image:),
        @selector(NEONDispatcher:Image:),
        @selector(OpenGLDispatcher:Image:)
    };

    // Filter dispatch table
    SEL filterDispatchTable[3] = {
        @selector(GaussianBlur:), 
        @selector(LaplacianOfGaussianSharpen:), 
        @selector(TwirlDistortion:)
    };
}

+(NSArray*) GetSupportedLanguages {
    return languageOptions;
}

+(NSArray*) GetSupportedFilters {
    return filterOptions;
}

-(void) RunFilterOnImage:(UIImage*)image WithFilter:(NSString*)filter Language:(NSString*)language {
    bool foundFilter = false;
    SEL filterSelector;

    for(int i = 0; i < filterOptions.count; ++i) {
        if (filter == [filterOptions objectAtIndex:i]) {
            foundFilter = true;
            filterSelector = filterDispatchTable[i];
            break;
        }
    }

    if (!foundFilter) {
        return;
    }

    for (int i = 0; i < languageOptions.count; ++i) {
        if (language == [languageOptions objectAtIndex:i] && [self respondsToSelector:languageDispatchTable[i]])  {
            [self performSelector:languageDispatchTable[i] withObject:filterSelector withObject:image];
            break;
        }
    }
}

-(void) GenericDispatch:SEL filter Image:(UIImage*)image Dispatch:(LanguageDispatch*) dispatch {
    if (![dispatch respondsToSelector:filter]) {
        return;
    }
    [dispatch performSelector:filter withObject:image];
}

-(void) HalideDispatcher:SEL filter Image:(UIImage*)image {
    static HalideDispatch* dispatch = [[HalideDispatch alloc] init];
    [self GenericDispatch:filter Image:image Dispatch:dispatch];
}

-(void) MetalDispatcher:SEL filter Image:(UIImage*)image {
}

-(void) ObjCDispatcher:SEL filter Image:(UIImage*)image {
}

-(void) NEONDispatcher:SEL filter Image:(UIImage*)image {
}

-(void) OpenGLDispatcher:SEL filter Image:(UIImage*)image {
}

@end

