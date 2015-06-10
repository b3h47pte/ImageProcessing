//
//  Dispatch.h
//  ImageProcessing
//
//  Created by Michael Bao on 6/9/15.
//  Copyright (c) 2015 Michael Bao. All rights reserved.
//

#ifndef ImageProcessing_Dispatch_h
#define ImageProcessing_Dispatch_h

@import Foundation;

// Dispatch class to manage the various filters and language implementations of those filters.
@interface Dispatch: NSObject

+(NSArray*) GetSupportedLanguages;
+(NSArray*) GetSupportedFilters;

-(void) RunFilterOnImage:(UIImage*)image WithFilter:(NSString*)filter Language:(NSString*)language;
@end

#endif