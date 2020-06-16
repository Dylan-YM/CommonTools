//
//  EasyLinkConf.h
//  HomePlatform
//
//  Created by CarlLiu on 2019/7/12.
//  Copyright © 2019 Honeywell. All rights reserved.
//

#ifndef EasyLinkConf_h
#define EasyLinkConf_h

#define BroadLinkErrorWrongSSID     2400

typedef enum : NSUInteger {
    LinkErrorTypeSuccess,
    LinkErrorTypeTimeOut,
    LinkErrorTypeCancel,
    LinkErrorTypeInvalid
} LinkErrorType;

typedef void(^LinkCallback)(LinkErrorType);

#endif /* EasyLinkConf_h */
