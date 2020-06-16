//
//  DataManager.h
//  AirTouch
//
//  Created by apple on 13-11-12.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define DATABASENAME @"Hplus_CitysList"

@interface DataManager : NSObject
{
    
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (instancetype)init;
- (id)createManagedObject:(Class)className;
- (void)deleteAllObjectsForEntityClass:(Class)className;
- (void)deleteManagedObject:(NSManagedObject*)obj;
- (BOOL)saveManagedObjects;
- (void)refreshManagedObject:(NSManagedObject*)obj;
- (NSUInteger)countForEntityClass:(Class)className
             sortDescriptorsOrNil:(NSArray*)sortDescriptors;

- (NSArray *)arrayForEntities:(Class)className
         sortDescriptorsOrNil:(NSArray *)sortDescriptors;

+ (instancetype)shareDataManager;
+ (id)createManagedInstance:(Class)className;
+ (void)deleteAllObjectsForEntity:(Class)className;
+ (void)deleteManagedInstance:(NSManagedObject *)obj;
+ (BOOL)saveManagedInstances;
+ (void)refreshManagedInstance:(NSManagedObject *)obj;
+ (void)rollback;

+ (NSUInteger)countForEntity:(Class)className
        sortDescriptorsOrNil:(NSArray *)sortDescriptors;
+ (NSUInteger)countForEntityClass:(Class)className
             sortDescriptorsOrNil:(NSArray*)sortDescriptors
                   predicateOrNil:(NSPredicate *)predicate;

+ (NSMutableArray *)mutableArrayForEntity:(Class)className;

+ (NSArray *)arrayForEntity:(Class)className
       sortDescriptorsOrNil:(NSArray *)sortDescriptors
             predicateOrNil:(NSPredicate *)predicate;

+ (NSArray *)arrayForEntity:(Class)className
       sortDescriptorsOrNil:(NSArray *)sortDescriptors;

+ (NSArray *)arrayForEntity:(Class)className
       sortDescriptorsOrNil:(NSArray *)sortDescriptors
             predicateOrNil:(NSPredicate *)predicate
            fetchLimitOrNil:(NSUInteger)fetchLimitNumber
             fetchOffsetNil:(NSRange)fetchRange;

@end
