//
//  NSObject+MultiHook.m
//  AirTouch
//
//  Created by Liu, Carl on 9/21/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "NSObject+MultiHook.h"
#import "objc/runtime.h"

#define HOOK_STRING(clazz, selector)     [NSString stringWithFormat:@"%@_%@", NSStringFromClass(clazz), NSStringFromSelector(selector)]

static NSString * const HOOK_ASPECT_TOKEN   =   @"HOOK_ASPECT_TOKEN";
static NSString * const HOOK_RETAIN_COUNT   =   @"HOOK_RETAIN_COUNT";
static NSString * const HOOK_SELECTOR       =   @"HOOK_SELECTOR";
static NSString * const HOOK_ARRAY          =   @"HOOK_ARRAY";
static NSString * const HOOK_INVOCATION     =   @"HOOK_INVOCATION";
static NSString * const HOOK_OPTION         =   @"HOOK_OPTION";

static NSMutableDictionary *hookTokens;

static void hookSelector(id self, Class clazz, SEL originSelector);

static void releaseToken(Class clazz, SEL originSelector);

@implementation NSObject (AspectsMulti)

#pragma mark - Private Methods
+ (void)hookSelector:(SEL)originSelector {
    hookSelector((id)self, [self superClassRespondsForSelector:originSelector], originSelector);
}

- (void)hookSelector:(SEL)originSelector {
    hookSelector(self, [[self class] superClassRespondsForSelector:originSelector], originSelector);
}

+ (NSMutableDictionary *)classHookInvocations {
    NSMutableDictionary *classHookInvocations = objc_getAssociatedObject([NSObject class], @selector(classHookInvocations));
    if (classHookInvocations == nil) {
        classHookInvocations = [NSMutableDictionary dictionary];
        objc_setAssociatedObject([NSObject class], @selector(classHookInvocations), classHookInvocations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return classHookInvocations;
}

- (NSMutableDictionary *)instanceHookInvocations {
    NSMutableDictionary *instanceHookInvocations = objc_getAssociatedObject(self, @selector(instanceHookInvocations));
    if (instanceHookInvocations == nil) {
        instanceHookInvocations = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, @selector(instanceHookInvocations), instanceHookInvocations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return instanceHookInvocations;
}

+ (void)hookWithDictionary:(NSMutableDictionary *)source originSelector:(SEL)originSelector withSelector:(SEL)hookedSelector withOptions:(AspectOptions)options{
    NSMethodSignature *signature = [self instanceMethodSignatureForSelector:hookedSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = hookedSelector;
    
    Class clazz = [self superClassRespondsForSelector:originSelector];
    NSString *hookKey = HOOK_STRING(clazz, originSelector);
    
    NSString *hookedSelectorString = NSStringFromSelector(hookedSelector);
    
    NSMutableDictionary *hookDictionary = source[hookKey];
    if (hookDictionary == nil) {
        [self hookSelector:originSelector];
        hookDictionary = [NSMutableDictionary dictionary];
        source[hookKey] = hookDictionary;
    }
    
    if (hookDictionary[HOOK_ARRAY] == nil) {
        hookDictionary[HOOK_ARRAY] = [NSMutableArray array];
    }
    [hookDictionary[HOOK_ARRAY] addObject:@{HOOK_SELECTOR:hookedSelectorString,
                                            HOOK_INVOCATION:invocation,
                                            HOOK_OPTION:@(options)}];
}

+ (void)unhookWithDictionary:(NSMutableDictionary *)source originSelector:(SEL)originSelector withSelector:(SEL)hookedSelector {
    Class clazz = [self superClassRespondsForSelector:originSelector];
    NSString *hookKey = HOOK_STRING(clazz, originSelector);
    NSString *hookedSelectorString = NSStringFromSelector(hookedSelector);
    
    NSMutableDictionary *hookDictionary = source[hookKey];
    if (hookDictionary != nil) {
        for (NSDictionary *dict in hookDictionary[HOOK_ARRAY]) {
            if ([dict[HOOK_SELECTOR] isEqualToString:hookedSelectorString]) {
                [hookDictionary[HOOK_ARRAY] removeObject:dict];
                releaseToken(clazz, originSelector);
                break;
            }
        }
    }
}

#pragma mark - Class Hierarchy
+ (Class)superClassRespondsForSelector:(SEL)originSelector {
    Class clszz = self;
    while ([clszz instancesRespondToSelector:originSelector]) {
        clszz = [clszz superclass];
    }
    return clszz;
}

#pragma mark - Public Methods

+ (void)hookOriginSelector:(SEL)originSelector withSelector:(SEL)hookedSelector withOptions:(AspectOptions)options {
    [self hookWithDictionary:self.classHookInvocations originSelector:originSelector withSelector:hookedSelector withOptions:options];
}

- (void)hookOriginSelector:(SEL)originSelector withSelector:(SEL)hookedSelector withOptions:(AspectOptions)options {
    [[self class] hookWithDictionary:self.instanceHookInvocations originSelector:originSelector withSelector:hookedSelector withOptions:options];
}

+ (void)unhookOriginSelector:(SEL)originSelector withSelector:(SEL)hookedSelector {
    [self unhookWithDictionary:self.classHookInvocations originSelector:originSelector withSelector:hookedSelector];
}

- (void)unhookOriginSelector:(SEL)originSelector withSelector:(SEL)hookedSelector {
    [[self class] unhookWithDictionary:self.instanceHookInvocations originSelector:originSelector withSelector:hookedSelector];
}

@end

static void retainToken(id<AspectToken> token, Class clazz, SEL originSelector) {
    if (hookTokens == nil) {
        hookTokens = [NSMutableDictionary dictionary];
    }
    NSString *hookKey = HOOK_STRING(clazz, originSelector);
    
    NSMutableDictionary *savedTokenDictionary = hookTokens[hookKey];
    if (savedTokenDictionary == nil) {
        savedTokenDictionary = [NSMutableDictionary dictionary];
        hookTokens[hookKey] = savedTokenDictionary;
        savedTokenDictionary[HOOK_ASPECT_TOKEN] = token;
        savedTokenDictionary[HOOK_RETAIN_COUNT] = @(1);
    } else {
        NSInteger retainCount = [savedTokenDictionary[HOOK_RETAIN_COUNT] integerValue] + 1;
        savedTokenDictionary[HOOK_RETAIN_COUNT] = @(retainCount);
    }
}

static void releaseToken(Class clazz, SEL originSelector) {
    if (hookTokens == nil) {
        hookTokens = [NSMutableDictionary dictionary];
    }
    NSString *hookKey = HOOK_STRING(clazz, originSelector);
    
    NSMutableDictionary *savedTokenDictionary = hookTokens[hookKey];
    if (savedTokenDictionary != nil) {
        NSInteger retainCount = [savedTokenDictionary[HOOK_RETAIN_COUNT] integerValue] - 1;
        savedTokenDictionary[HOOK_RETAIN_COUNT] = @(retainCount);
        if (retainCount == 0) {
            id<AspectToken> token = savedTokenDictionary[HOOK_ASPECT_TOKEN];
            [token remove];
            [hookTokens removeObjectForKey:hookKey];
        }
    }
}

static void hookSelector(id self, Class clazz, SEL originSelector) {
    NSString *hookKey = HOOK_STRING(clazz, originSelector);
    if (hookTokens[hookKey]) {
        retainToken(hookTokens[hookKey], clazz, originSelector);
        return;
    }
    
    id<AspectToken> token = [self aspect_hookSelector:originSelector withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aspectInfo) {
        NSObject *instance = aspectInfo.instance;
        NSInvocation *originalInvocation = aspectInfo.originalInvocation;
        
        NSArray *classHookInvocations = [NSObject classHookInvocations][hookKey][HOOK_ARRAY];
        NSArray *instanceHookInvocations = instance.instanceHookInvocations[hookKey][HOOK_ARRAY];
        
        NSMutableArray *hooks = [NSMutableArray array];
        [hooks addObjectsFromArray:classHookInvocations];
        [hooks addObjectsFromArray:instanceHookInvocations];
        
        NSMutableArray *beforeInvocations = [NSMutableArray array];
        NSMutableArray *insteadInvocations = [NSMutableArray array];
        NSMutableArray *afterInvocations = [NSMutableArray array];
        
        for (NSDictionary *dict in hooks) {
            NSInvocation *invocation = dict[HOOK_INVOCATION];
            AspectOptions options = [dict[HOOK_OPTION] unsignedIntegerValue];
            switch (options) {
                case AspectPositionBefore:
                    [beforeInvocations addObject:invocation];
                    break;
                case AspectPositionInstead:
                    [insteadInvocations addObject:invocation];
                    break;
                case AspectPositionAfter:
                    [afterInvocations addObject:invocation];
                    break;
                    
                default:
                    break;
            }
        }
        
        void(^invoke)(NSInvocation *, NSInvocation *) = ^(NSInvocation *invocation, NSInvocation *origin) {
            if (invocation != origin) {
                NSInteger numberOfArguments = invocation.methodSignature.numberOfArguments;
                NSInteger originNumberOfArguments = origin.methodSignature.numberOfArguments;
                void *argBuf = NULL;
                for (NSUInteger idx = 2; idx < originNumberOfArguments; idx++) {
                    const char *type = [origin.methodSignature getArgumentTypeAtIndex:idx];
                    NSUInteger argSize;
                    NSGetSizeAndAlignment(type, &argSize, NULL);
                    
                    if (!(argBuf = reallocf(argBuf, argSize))) {
                        return;
                    }
                    
                    [origin getArgument:argBuf atIndex:idx];
                    [invocation setArgument:argBuf atIndex:idx];
                }
                
                if (originNumberOfArguments > 2) {
                    free(argBuf);
                }
                if (numberOfArguments > originNumberOfArguments) {
                    [invocation setArgument:&origin atIndex:originNumberOfArguments];
                }
            }
            [invocation invokeWithTarget:instance];
        };
        
        for (NSInvocation *invocation in beforeInvocations) {
            invoke(invocation, originalInvocation);
        }
        if (insteadInvocations.count > 0) {
            for (NSInvocation *invocation in insteadInvocations) {
                invoke(invocation, originalInvocation);
            }
        } else {
            invoke(originalInvocation, originalInvocation);
        }
        for (NSInvocation *invocation in afterInvocations) {
            invoke(invocation, originalInvocation);
        }
    } error:nil];
    if (token) {
        retainToken(token, clazz, originSelector);
    }
}
