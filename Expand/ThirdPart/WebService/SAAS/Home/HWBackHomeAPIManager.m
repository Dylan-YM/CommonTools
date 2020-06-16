//
//  HWBackHomeAPIManager.m
//  AirTouch
//
//  Created by Liu, Carl on 9/19/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWBackHomeAPIManager.h"
#import "AppMarco.h"
#import "DateTimeUtil.h"

@interface HWBackHomeAPIManager ()

@property (strong, nonatomic) NSString *locationId;
@property (strong, nonatomic) NSString *time;

@end

@implementation HWBackHomeAPIManager

- (NSString *)apiName {
    NSString *api = [kUrl_BackHome stringByReplacingOccurrencesOfString:@"{locationId}" withString:self.locationId];
    return api;
}

- (RequestType)requestType {
    return RequestType_Put;
}

- (void)callAPIWithParam:(id)param completion:(HWAPICallBack)completion {
    self.locationId = param[kUrl_LocationId];
    self.time = param[@"timeToHome"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:param];
    [dict removeObjectForKey:kUrl_LocationId];
    [super callAPIWithParam:dict completion:completion];
}

- (NSError *)handleError:(NSInteger)errorCode responseObject:(id)responseObject {
    NSString *errorMessage = nil;
    switch (errorCode) {
        case 400:{
            if (responseObject && [responseObject isKindOfClass:[NSArray class]] )
            {
                id responseDict;
                if (((NSArray *)responseObject).count > 0) {
                    responseDict = ((NSArray *)responseObject)[0];
                }
                
                if (responseDict && [responseDict isKindOfClass:[NSDictionary class]])
                {
                    for (NSString * key in responseDict)
                    {
                        if ([key isEqualToString:@"message"])
                        {
                            errorMessage = [responseDict objectForKey:key];
                            break;
                        }
                    }
                }
            }
            
            if (errorMessage)
            {
                NSString * aText = @"";
                errorMessage = [NSString stringWithFormat:@"%@: %@",aText,errorMessage];
            }
            else
            {
                //检查设置的时间是否在当前时间半小时之内
                NSDate * backHomeDate = [DateTimeUtil getDateFromUTCString:self.time];
                NSDate * nowDate = [NSDate date];
                
                if ([backHomeDate timeIntervalSinceDate:nowDate] < 30*60) {
                    errorMessage = NSLocalizedString(@"", nil);
                } else {
                    errorMessage = NSLocalizedString(@"common_operation_failed", nil);
                }
            }
            break;
        }
        default:
            break;
    }
    NSError *error = [super handleError:errorCode responseObject:responseObject];
    if (errorMessage) {
        error = [NSError errorWithDomain:errorMessage code:errorCode userInfo:nil];
    }
    return error;
}

@end
