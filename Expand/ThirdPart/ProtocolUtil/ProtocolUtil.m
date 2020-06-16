//
//  ProtocolUtil.m
//  Utils
//
//  Created by Liu, Carl on 10/20/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "ProtocolUtil.h"
#import <objc/runtime.h>

@implementation ProtocolUtil

+ (BOOL)protocol:(Protocol *)protocol conformsToProtocolList:(NSArray<Protocol *> *)protocols {
    for (Protocol *procotolInList in protocols) {
        if (protocol_isEqual(protocol, procotolInList)) {
            return YES;
        }
        unsigned int superProtocolCount = 0;
        Protocol * __unsafe_unretained *superProtocols = protocol_copyProtocolList(procotolInList, &superProtocolCount);
        if (superProtocolCount > 0) {
            NSArray<Protocol *> *nsarray = [[NSArray alloc] initWithObjects:superProtocols count:superProtocolCount];
            free(superProtocols);
            
            if ([self protocol:protocol conformsToProtocolList:nsarray]) {
                return YES;
            }
        }
    }
    return NO;
}

+ (BOOL)protocol:(Protocol *)protocol declaredSelector:(SEL)selector {
    static NSArray *matrix;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        matrix = @[@(0x11), @(0x10), @(0x01), @(0x00)];
    });
    for (NSNumber *flag in matrix) {
        NSUInteger intValue = [flag unsignedIntegerValue];
        BOOL isRequiredMethod = (intValue & 0x10) >> 1;
        BOOL isInstanceMethod = (intValue & 0x01);
        struct objc_method_description hasMethod = protocol_getMethodDescription(protocol, selector, isRequiredMethod, isInstanceMethod);
        if (hasMethod.name != NULL) return YES;
    }
    return NO;
}

@end

@implementation NSObject (Protocol)

- (NSMutableDictionary *)forwardingProtocols {
    NSMutableDictionary *protocols = objc_getAssociatedObject(self, @selector(forwardingProtocols));
    if (protocols == nil) {
        protocols = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, @selector(forwardingProtocols), protocols, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return protocols;
}

- (void)registerProtocol:(Protocol *)protocol forwardingObject:(NSObject *)object {
    if (object) {
        self.forwardingProtocols[NSStringFromProtocol(protocol)] = object;
    } else {
        [self.forwardingProtocols removeObjectForKey:NSStringFromProtocol(protocol)];
    }
}

- (NSObject *)objectRespondsForProtocol:(Protocol *)protocol {
    return self.forwardingProtocols[NSStringFromProtocol(protocol)];
}

- (NSArray<NSString *> *)allForwardingProtocols {
    return [self.forwardingProtocols allKeys];
}

@end
