//
//  ATFont.m
//  FontTest
//
//  Created by Rich on 8/18/15.
//  Copyright (c) 2015 Rich. All rights reserved.
//

#import "HWFont.h"
#import "AppConfig.h"
#import "AppMarco.h"

@implementation HWFont

+ (CGFloat)adapationSize:(CGFloat)fontSize {
//    return fontSize*(ISLarge47Inch?1.3:(ISLarge4INCH?1.15:(ISSmall4INCH?0.9:1.0)));
    return fontSize*(MIN(SCREENWIDTH, 414))/BaseFontSizeWidth;
}

+ (UIFont *)systemFontOfSize:(CGFloat)fontSize {
    if ([AppConfig isEnglish]) {
        return [UIFont fontWithName:HoneywellBook size:[HWFont adapationSize:fontSize]];
    } else {
        return [UIFont systemFontOfSize:[HWFont adapationSize:fontSize]];
    }
}

+ (UIFont *)boldSystemFontOfSize:(CGFloat)fontSize {
    if ([AppConfig isEnglish]) {
        return [UIFont fontWithName:HoneywellBold size:[HWFont adapationSize:fontSize]];
    } else {
        return [UIFont boldSystemFontOfSize:[HWFont adapationSize:fontSize]];
    }
}

@end
