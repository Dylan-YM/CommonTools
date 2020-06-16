//
//  NSString+Url.m
//  AirTouch
//
//  Created by BobYang on 16/5/19.
//  Copyright © 2016年 Honeywell. All rights reserved.
//

#import "NSString+Url.h"

@implementation NSString (Url)

- (NSDictionary *)urlRequestParameters
{
    NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
    NSArray *components = [self componentsSeparatedByString:@"?"];
    if ([components count] == 2) {
        NSString *requestParametersString = components[1];
        NSArray *keyValues = [requestParametersString componentsSeparatedByString:@"&"];
        for (NSString * keyAndValueItem in keyValues) {
            NSRange range = [keyAndValueItem rangeOfString:@"="];
            if (range.location != NSNotFound && range.location != keyAndValueItem.length - 1) {
                NSString *key = [keyAndValueItem substringToIndex:range.location];
                NSString *value = [keyAndValueItem substringFromIndex:range.location+1];
                requestParameters[key] = value;
            }
        }
    }
    return requestParameters;
}

@end
