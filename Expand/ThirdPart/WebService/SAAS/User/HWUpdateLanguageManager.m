//
//  HWUpdateLanguageManager.m
//  HomePlatform
//
//  Created by Honeywell on 2017/6/26.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import "HWUpdateLanguageManager.h"

@implementation HWUpdateLanguageManager

- (RequestType)requestType {
    return RequestType_Post;
}

- (NSString *)apiName {
    return kUpdateLanguage;
}

@end
