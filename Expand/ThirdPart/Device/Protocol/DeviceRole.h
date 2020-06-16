//
//  DeviceRole.h
//  Services
//
//  Created by Liu, Carl on 10/9/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#ifndef DeviceRole_h
#define DeviceRole_h

typedef enum : NSInteger {
    AuthorizeRoleNone = 0,
    AuthorizeRoleObserver = 100,
    AuthorizeRoleController = 200,
    AuthorizeRoleMaster = 300,
    AuthorizeRoleOwner = 400,
} AuthorizeRole;

#endif /* DeviceRole_h */
