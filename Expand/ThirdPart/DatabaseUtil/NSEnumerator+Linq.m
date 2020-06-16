//
//  NSEnumerator+Linq.m
//  NSEnumeratorLinq
//
//  Created by Anton Bukov on 13.01.13.
//  Copyright (c) 2013 Anton Bukov. All rights reserved.
//

#import "NSEnumerator+Linq.h"

////////////////////////////////////////////////////////////////////////////////////////////////
// private class

@interface NSEnumeratorWrapper : NSEnumerator
@end
@implementation NSEnumeratorWrapper {
    NSEnumerator * _enumerator;
    id (^_nextObject)(NSEnumerator *);
}
- (id)initWithEnumarator:(NSEnumerator *)enumerator nextObject:(id (^)(NSEnumerator *))nextObject {
    if (self = [super init]) {
        _enumerator = enumerator;
        _nextObject = nextObject;
    }
    return self;
}
- (id)nextObject {
    return _nextObject(_enumerator);
}
@end

////////////////////////////////////////////////////////////////////////////////////////////////

@implementation NSDictionary (KeyValueEnumerator)
- (NSEnumerator *)keyValueEnumerator
{
    NSEnumerator * keyEnumerator = [self keyEnumerator];
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:nil nextObject:^id(NSEnumerator * fakeEnumerator) {
        id key = [keyEnumerator nextObject];
        if (key == nil) return nil;
        id value = [self objectForKey:key];
        return [NSKeyValuePair pairWithKey:key value:value];
    }];
}
@end

////////////////////////////////////////////////////////////////////////////////////////////////

@implementation NSEnumerator (Linq)

- (NSEnumerator *)select:(id (^)(id))func
{
    return [self select_i:^id(id object, int index) {
        return func(object);
    }];
}

- (NSEnumerator *)select_i:(id (^)(id,int))func
{
    __block int index = 0;
    return [[NSEnumeratorWrapper alloc] initWithEnumarator:self nextObject:^id(NSEnumerator * enumerator) {
        id result = [enumerator nextObject];
        if (result)
            return func(result,index++);
        return nil;
    }];
}

- (NSEnumerator *)groupBy:(id<NSCopying> (^)(id))keySelector
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    id object;
    while (object = [self nextObject])
    {
        id<NSCopying> key = keySelector(object);
        NSMutableArray * values = [dict objectForKey:key] ?: [NSMutableArray array];
        [values addObject:object];
        if (values.count == 1)
            [dict setObject:values forKey:key];
    }

    return [dict keyValueEnumerator];
}

- (NSEnumerator *)orderBy:(id (^)(id))func
               comparator:(NSComparisonResult (^)(id obj1, id obj2))objectComparator
{
    return [[[self allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return objectComparator(func(obj1), func(obj2));
    }] objectEnumerator];
}

- (NSEnumerator *)orderBy:(id (^)(id))func
{
    return [self orderBy:func comparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2];
    }];
}

@end
