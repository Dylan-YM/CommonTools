//
//  HWSaveImageInfoAPIManager.m
//  Services
//
//  Created by Liu, Carl on 19/12/2016.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWSaveImageInfoAPIManager.h"
#import "Base64+Category.h"
#import "UIImage+Operation.h"

static CGFloat const imageSize = 500.0f;

@implementation HWSaveImageInfoAPIManager

- (NSString *)apiName {
    return kFeedbackSaveImageInfo;
}

- (RequestType)requestType {
    return RequestType_Post;
}

- (HWRequestSerializer)requestSerializer {
    return HWRequestSerializer_Json;
}

- (void)callAPIWithParam:(id)param completion:(HWAPICallBack)completion {
    UIImage *image = param[@"image"];
    if (image == nil) {
        if (completion) {
            completion(nil, [NSError errorWithDomain:@"image should not be nil" code:NSURLErrorCancelled userInfo:nil]);
        }
        return;
    }
    CGSize size = image.size;
    if (size.width > imageSize || size.height > imageSize) {
        CGFloat ratio = MIN(imageSize/size.width, imageSize/size.height);
        image = [image scale:ratio];
    }
    NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
    NSString *base64 = [imageData base64EncodedString];
    NSDictionary *imageInfo = @{@"imageStream":base64};
    [super callAPIWithParam:imageInfo completion:completion];
}

@end
