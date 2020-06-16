//
//  HWRequestProtocol.h
//  HTTPClient
//
//  Created by Honeywell on 2017/1/4.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HWRequestMode) {
    HWRequestMode_AFNetworking,
    HWRequestMode_Socket,
};

typedef NS_ENUM(NSUInteger, HWRequestSerializer) {
    HWRequestSerializer_Form,
    HWRequestSerializer_Json,
};

typedef NS_ENUM(NSInteger, RequestType) {
    RequestType_Get,
    RequestType_Post,
    RequestType_Put,
    RequestType_Delete
};

typedef void (^HWAPICallBack)(id object, NSError *error);

@protocol HWRequestProtocol <NSObject>

@property (assign, nonatomic) float timeout;

- (void)sendRequestWithUrl:(NSString *)url params:(id)requestParams headerDict:(NSDictionary *)headerDict method:(RequestType)requestType requestSerializer:(HWRequestSerializer)requestSerializer useCert:(BOOL)useCert callBack:(HWAPICallBack)callBack;

- (void)cancel;

@end
