//
//  XZAPIManager.h
//  AirTouch
//
//  Created by Honeywell on 9/14/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "BaseAPIRequest.h"

@interface XZAPIManager : BaseAPIRequest

@property (readonly, nonatomic) NSString *city;
@property (readonly, nonatomic) NSString *language;
@property (readonly, nonatomic) NSString *apiKey;

@end
