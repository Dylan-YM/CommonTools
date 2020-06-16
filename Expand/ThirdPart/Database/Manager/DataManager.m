//
//  DataManager.m
//  AirTouch
//
//  Created by apple on 13-11-12.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import "DataManager.h"
#import "AppMarco.h"

static DataManager *instance = nil;

@implementation DataManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (instancetype)shareDataManager
{
    if (!instance) {
        instance = [[DataManager alloc] init];
    }
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (BOOL)needUpdateSqlite {
     NSString *currentSqliteVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *lastSqliteVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kSqliteVersion];
    BOOL result = [currentSqliteVersion compare:lastSqliteVersion options:NSNumericSearch] == NSOrderedDescending;
    if (result || !lastSqliteVersion) {
        return YES;
    }
    return NO;
}

- (void)updateSqliteVersion {
    [[NSUserDefaults standardUserDefaults] setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:kSqliteVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dealloc
{
    instance = nil;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:DATABASENAME withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",DATABASENAME,@".sqlite"]];
    
    if ([self needUpdateSqlite]) {
        NSURL *preloadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:DATABASENAME ofType:@"sqlite"]];
        NSError* err = nil;
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]]) {
            if (![[NSFileManager defaultManager] removeItemAtURL:storeURL error:&err]) {
                NSLog(@"Could not remove old files. Error:%@",err);
            }
        }
        
        if (![[NSFileManager defaultManager] copyItemAtURL:preloadURL toURL:storeURL error:&err]) {
            NSLog(@"Oops, could not copy preloaded data");
        }
        if (!err) {
            [self updateSqliteVersion];
        }
    }
    
    NSError *error = nil;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        //if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (BOOL)migrateStore:(NSURL *)storeURL toVersionTwoStore:(NSURL *)dstStoreURL error:(NSError **)outError {
    
    NSMigrationManager *migration = [[NSMigrationManager alloc] init];
    // Try to get an inferred mapping model.
    NSMappingModel *mappingModel =
    [NSMappingModel inferredMappingModelForSourceModel:[migration sourceModel]
                                      destinationModel:[migration destinationModel] error:outError];
    
    // If Core Data cannot create an inferred mapping model, return NO.
    if (!mappingModel) {
        return NO;
    }
    
    // Create a migration manager to perform the migration.
    NSMigrationManager *manager = [[NSMigrationManager alloc]
                                   initWithSourceModel:[migration sourceModel] destinationModel:[migration destinationModel]];
    
    BOOL success = [manager migrateStoreFromURL:storeURL type:NSSQLiteStoreType
                                        options:nil withMappingModel:mappingModel toDestinationURL:dstStoreURL
                                destinationType:NSSQLiteStoreType destinationOptions:nil error:outError];
    
    return success;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - methods
- (id)createManagedObject:(Class)className
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(className) inManagedObjectContext:managedObjectContext];
}

- (void)deleteAllObjectsForEntityClass:(Class)className
{
    NSArray *objects = [self arrayForEntities:className sortDescriptorsOrNil:nil];
    for (NSManagedObject *object in objects) {
        [self deleteManagedObject:object];
    }
}

- (void)deleteManagedObject:(NSManagedObject*)obj
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    [managedObjectContext deleteObject:obj];
}

- (BOOL)saveManagedObjects
{
    BOOL success = YES;
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    NSError *error;
    if (![managedObjectContext save:&error]) {
        
        success = NO;
        
        // Handle the error.
        NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
        NSArray *detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
        if (detailedErrors != nil && [detailedErrors count] > 0) {
            for (NSError *detailedError in detailedErrors) {
                NSLog(@"  DetailedError: %@", [detailedError userInfo]);
            }
        }
        else {
            NSLog(@"%@", [error userInfo]);
        }
    }
    return success;
}

- (void)refreshManagedObject:(NSManagedObject*)obj
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    [managedObjectContext refreshObject:obj mergeChanges:YES];
}

- (NSUInteger)countForEntityClass:(Class)className
             sortDescriptorsOrNil:(NSArray*)sortDescriptors
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(className) inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    if (sortDescriptors) {
        [request setSortDescriptors:sortDescriptors];
    }
    
    NSError *error;
    NSUInteger count = [managedObjectContext countForFetchRequest:request error:&error];
    if (error) {
        // count for entity
        NSLog(@"error: %@", error);
    }
    return count;
}

- (NSArray *)arrayForEntities:(Class)className
         sortDescriptorsOrNil:(NSArray *)sortDescriptors
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(className) inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    if (sortDescriptors) {
        [request setSortDescriptors:sortDescriptors];
    }
    
    NSError *error;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    if (results == nil) {
        // Handle the error.
        NSLog(@"Unable to retrieve entities for: %@.", NSStringFromClass(className));
    }
    return results;
}


#pragma mark - static methods
+ (NSUInteger)countForEntity:(Class)className sortDescriptorsOrNil:(NSArray *)sortDescriptors
{
    NSManagedObjectContext *managedObjectContext = [[DataManager shareDataManager] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(className) inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    if (sortDescriptors) {
        [request setSortDescriptors:sortDescriptors];
    }
    
    NSError *error;
    NSUInteger count = [managedObjectContext countForFetchRequest:request error:&error];
    if (error) {
        // count for entity
        NSLog(@"error: %@", error);
    }
    return count;
}

+ (NSUInteger)countForEntityClass:(Class)className
             sortDescriptorsOrNil:(NSArray*)sortDescriptors
                   predicateOrNil:(NSPredicate *)predicate
{
    NSManagedObjectContext *managedObjectContext = [[DataManager shareDataManager] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(className) inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    if (sortDescriptors) {
        [request setSortDescriptors:sortDescriptors];
    }
    if (predicate) {
        [request setPredicate:predicate];
    }
    NSError *error;
    NSUInteger count = [managedObjectContext countForFetchRequest:request error:&error];
    if (error) {
        // count for entity
        NSLog(@"error: %@", error);
    }
    return count;
}

+ (NSArray *)arrayForEntity:(Class)className sortDescriptorsOrNil:(NSArray *)sortDescriptors
{
    NSManagedObjectContext *managedObjectContext = [[DataManager shareDataManager] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(className) inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    if (sortDescriptors) {
        [request setSortDescriptors:sortDescriptors];
    }
    
    NSError *error;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    if (results == nil) {
        // Handle the error.
        NSLog(@"Unable to retrieve entities for: %@.", NSStringFromClass(className));
    }
    return results;
}


+ (NSArray *)arrayForEntity:(Class)className sortDescriptorsOrNil:(NSArray *)sortDescriptors predicateOrNil:(NSPredicate *)predicate
{
    NSManagedObjectContext *managedObjectContext = [[DataManager shareDataManager] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(className) inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    if (sortDescriptors) {
        [request setSortDescriptors:sortDescriptors];
    }
    
    if (predicate) {
        [request setPredicate:predicate];
    }
    
    NSError *error;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    if (results == nil) {
        // Handle the error.
        NSLog(@"Unable to retrieve entities for: %@.", NSStringFromClass(className));
    }
    return results;
}

+ (NSArray *)arrayForEntity:(Class)className sortDescriptorsOrNil:(NSArray *)sortDescriptors predicateOrNil:(NSPredicate *)predicate fetchLimitOrNil:(NSUInteger)fetchLimitNumber fetchOffsetNil:(NSRange)fetchRange
{
    NSManagedObjectContext *managedObjectContext = [[DataManager shareDataManager] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(className) inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    if (sortDescriptors) {
        [request setSortDescriptors:sortDescriptors];
    }
    
    if (predicate) {
        [request setPredicate:predicate];
    }
    
    if (fetchLimitNumber != NSNotFound) {
        [request setFetchLimit:fetchLimitNumber];
    }
    
    if (fetchRange.location != NSNotFound) {
        [request setFetchOffset:fetchRange.location*fetchRange.length];
    }
    
    NSError *error;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    if (results == nil) {
        // Handle the error.
        NSLog(@"Unable to retrieve entities for: %@.", NSStringFromClass(className));
    }
    return results;
}

+ (NSMutableArray *)mutableArrayForEntity:(Class)className
{
    NSManagedObjectContext *managedObjectContext = [[DataManager shareDataManager] managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(className) inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    NSError *error;
    NSMutableArray *mutableResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableResults == nil) {
        // Handle the error.
        NSLog(@"Unable to retrieve entities for: %@.", NSStringFromClass(className));
    }
    return mutableResults;
}

+ (BOOL)saveManagedInstances
{
    BOOL success = YES;
    NSManagedObjectContext *managedObjectContext = [[DataManager shareDataManager] managedObjectContext];
    
    NSError *error;
    if (![managedObjectContext save:&error]) {
        
        success = NO;
        
        // Handle the error.
        NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
        NSArray *detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
        if (detailedErrors != nil && [detailedErrors count] > 0) {
            for (NSError *detailedError in detailedErrors) {
                NSLog(@"  DetailedError: %@", [detailedError userInfo]);
            }
        }
        else {
            NSLog(@"%@", [error userInfo]);
        }
    }
    return success;
}


+ (void)deleteAllObjectsForEntity:(Class)className {
    
    NSArray *objects = [DataManager arrayForEntity:className sortDescriptorsOrNil:nil];
    for (NSManagedObject *object in objects) {
        [DataManager deleteManagedInstance:object];
    }
}


+ (void)rollback
{
    NSManagedObjectContext *managedObjectContext = [[DataManager shareDataManager] managedObjectContext];
    [managedObjectContext rollback];
}


+ (void)deleteManagedInstance:(NSManagedObject *)obj
{
    NSManagedObjectContext *managedObjectContext = [[DataManager shareDataManager] managedObjectContext];
    [managedObjectContext deleteObject:obj];
}


+ (void)refreshManagedInstance:(NSManagedObject *)obj
{
    NSManagedObjectContext *managedObjectContext = [[DataManager shareDataManager] managedObjectContext];
    [managedObjectContext refreshObject:obj mergeChanges:YES];
}


+ (id)createManagedInstance:(Class)className
{
    NSManagedObjectContext *managedObjectContext = [[DataManager shareDataManager] managedObjectContext];
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(className) inManagedObjectContext:managedObjectContext];
}


@end
