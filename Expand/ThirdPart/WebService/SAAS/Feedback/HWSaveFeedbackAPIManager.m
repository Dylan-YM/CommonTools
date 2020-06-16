//
//  HWSaveFeedbackAPIManager.m
//  Services
//
//  Created by Liu, Carl on 19/12/2016.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWSaveFeedbackAPIManager.h"

@implementation HWSaveFeedbackAPIManager

- (NSString *)apiName {
    return kFeedbackSaveFeedBack;
}

- (RequestType)requestType {
    return RequestType_Post;
}

- (HWRequestSerializer)requestSerializer {
    return HWRequestSerializer_Json;
}

@end
