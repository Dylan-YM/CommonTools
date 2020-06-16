//
//  NSEnumerator+Linq.h
//  NSEnumeratorLinq
//
//  Created by Anton Bukov on 13.01.13.
//  Copyright (c) 2013 Anton Bukov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSKeyValuePair.h"

#define FUNC(RET, A, BODY) ^RET(A){return (BODY);}
#define ACTION(A, BODY) FUNC(void, A, BODY)
#define TRANSFORM(A, BODY) FUNC(id, A, BODY)
#define PREDICATE(A, BODY) FUNC(BOOL, A, BODY)

#define FUNC_2(RET, A, B, BODY) ^RET(A, B){return (BODY);}
#define ACTION_2(A, B, BODY) FUNC_2(void, A, B, BODY)
#define TRANSFORM_2(A, B, BODY) FUNC_2(id, A, B, BODY)
#define PREDICATE_2(A, B, BODY) FUNC_2(BOOL, A, B, BODY)

// NSDictionary+KeyValueEnumerator

@interface NSDictionary (KeyValueEnumerator)
- (NSEnumerator *)keyValueEnumerator;
@end

// NSEnumerator+Linq

@interface NSEnumerator (Linq)

- (NSEnumerator *)select:(id (^)(id object))func;
- (NSEnumerator *)select_i:(id (^)(id object,int index))func;

- (NSEnumerator *)groupBy:(id<NSCopying> (^)(id object))keySelector;

- (NSEnumerator *)orderBy:(id (^)(id object))func
               comparator:(NSComparisonResult (^)(id obj1, id obj2))objectComparator;
- (NSEnumerator *)orderBy:(id (^)(id object))func;

@end
