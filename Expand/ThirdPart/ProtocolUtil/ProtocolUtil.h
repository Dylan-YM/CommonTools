//
//  ProtocolUtil.h
//  Utils
//
//  Created by Liu, Carl on 10/20/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProtocolUtil : NSObject

+ (BOOL)protocol:(Protocol *)protocol conformsToProtocolList:(NSArray<Protocol *> *)protocols;

+ (BOOL)protocol:(Protocol *)protocol declaredSelector:(SEL)selector;

@end

@interface NSObject (Protocol)

#pragma mark - NSProxy Forwarding
- (void)registerProtocol:(Protocol *)protocol forwardingObject:(NSObject *)object;

- (NSObject *)objectRespondsForProtocol:(Protocol *)protocol;
- (NSArray<NSString *> *)allForwardingProtocols;

@end
