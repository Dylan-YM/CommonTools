//
//  HWDataBaseManager.m
//  TestDB
//
//  Created by Honeywell on 2017/4/11.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import "HWDataBaseManager.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"

NSString *const DataBaseColumnTypeText = @"text";
NSString *const DataBaseColumnTypeInteger = @"integer";
NSString *const DataBaseColumnTypeFloat = @"float";
NSString *const DataBaseColumnTypeBlob = @"blob";
NSString *const DataBaseColumnTypeBoolean = @"boolean";

NSString *const DB_ROWID = @"rowid";

@interface HWDataBaseManager ()

@property (nonatomic, strong) FMDatabaseQueue *queue;

@property (nonatomic, strong) NSString *dbPath;

@end

@implementation HWDataBaseManager

#pragma mark -- 创建数据库
- (id)initWithDBName:(NSString *)dbName {
    self = [super init];
    if (self) {
        NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.dbPath = [documents[0] stringByAppendingPathComponent:dbName];
        
        self.queue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
        
    }
    return self;
}

#pragma mark -- 打开数据库
- (id)initAndOpenWithDBPath:(NSString *)dbPath {
    self = [super init];
    if (self) {
        self.queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return self;
}

#pragma mark -- 给指定数据库建表
- (void)createTable:(NSString *)tableName keyTypes:(NSDictionary *)keyTypes withCallBack:(HWDBCallBack)callBack {
    if (self.queue) {
        [self.queue inDatabase:^(FMDatabase *db) {
            [self createTable:tableName inDB:db keyTypes:keyTypes withCallBack:callBack];
        }];
    } else {
        NSError *error = [NSError errorWithDomain:@"No Queue" code:0 userInfo:nil];
        if (callBack) {
            callBack(nil,error);
        }
    }
}

- (void)createTable:(NSString *)tableName inDB:(FMDatabase *)db keyTypes:(NSDictionary *)keyTypes withCallBack:(HWDBCallBack)callBack {
    NSError *error = nil;
    
    if ([keyTypes count] == 0) {
        error = [NSError errorWithDomain:@"keyTypes should not be empty" code:0 userInfo:nil];
        if (callBack) {
            callBack(nil, error);
        }
        return;
    }
    
    NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (",tableName]];
    
    NSArray *keys = [keyTypes allKeys];
    for (NSInteger i = 0; i < [keys count]; i++) {
        NSString *key = keys[i];
        NSString *type = keyTypes[key];
        [sql appendString:key];
        [sql appendString:@" "];
        [sql appendString:type];
        if (i < [keys count]-1) {
            [sql appendString:@", "];
        }
    }
    [sql appendString:@")"];
    
    BOOL result = NO;
    if (![db tableExists:tableName]) {
        result = [db executeUpdate:sql values:nil error:&error];
    }
    
    if (callBack) {
        callBack(nil, result ? nil : error);
    }
}

#pragma mark --给指定数据库的表添加值
- (void)insertIntoTable:(NSString *)tableName KeyValues:(NSDictionary *)keyValues withCallBack:(HWDBCallBack)callBack {
    if (self.queue) {
        [self.queue inDatabase:^(FMDatabase *db) {
            NSMutableArray *values = [NSMutableArray array];
            NSArray *keys = [keyValues allKeys];
            
            NSMutableString *keyString = [NSMutableString string];
            NSMutableString *valueString = [NSMutableString string];
            
            for (NSInteger i = 0; i < [keys count]; i++) {
                NSString *key = keys[i];
                NSString *value = keyValues[key];
                [values addObject:value];
                BOOL alterTableResult = [self database:db alterTable:tableName addColumn:key type:[self getKeyTypeWithValue:value]];
                NSLog(@"Alter Table %@ ,column : %@ , result : %@", tableName, key, @(alterTableResult));
                
                [keyString appendString:key];
                [valueString appendString:@"?"];
                if (i < [keys count]-1) {
                    [keyString appendString:@", "];
                    [valueString appendString:@", "];
                }
            }
            
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", tableName, keyString, valueString];
            
            NSError *error = nil;
            BOOL result = [db executeUpdate:sql values:values error:&error];
            if (callBack) {
                callBack(nil, result ? nil : error);
            }
        }];
    } else {
        NSError *error = [NSError errorWithDomain:@"No Queue" code:0 userInfo:nil];
        if (callBack) {
            callBack(nil,error);
        }
    }
}

-(void)insertIntoTable:(NSString *)tableName KeyValuesArray:(NSArray *)keyValuesArray withCallBack:(HWDBCallBack)callBack {
    if (self.queue) {
        [self.queue inDatabase:^(FMDatabase *db) {
            NSLog(@"============================");
            [db beginTransaction];
            
            BOOL isRollBack = NO;
            
            @try {
                for (NSInteger i = 0; i < keyValuesArray.count; i++) {
                    NSDictionary *keyValues = keyValuesArray[i];
                    NSMutableArray *values = [NSMutableArray array];
                    NSArray *keys = [keyValues allKeys];
                    
                    NSMutableString *keyString = [NSMutableString string];
                    NSMutableString *valueString = [NSMutableString string];
                    
                    for (NSInteger i = 0; i < [keys count]; i++) {
                        NSString *key = keys[i];
                        NSString *value = keyValues[key];
                        [values addObject:value];
                        [self database:db alterTable:tableName addColumn:key type:[self getKeyTypeWithValue:value]];
//                        NSLog(@"Alter Table %@ ,column : %@ , result : %@", tableName, key, @(alterTableResult));
                        
                        [keyString appendString:key];
                        [valueString appendString:@"?"];
                        if (i < [keys count]-1) {
                            [keyString appendString:@", "];
                            [valueString appendString:@", "];
                        }
                    }
                    
                    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", tableName, keyString, valueString];
                    
                    NSError *error = nil;
                    [db executeUpdate:sql values:values error:&error];
                }
            }
            @catch (NSException *exception) {
                isRollBack = YES;
                [db rollback];
            }
            @finally {
                if (!isRollBack) {
                    [db commit];
                }
                if (callBack) {
                    callBack(nil,isRollBack?[NSError errorWithDomain:@"rollBack" code:0 userInfo:nil]:nil);
                }
            }
        }];
    } else {
        NSError *error = [NSError errorWithDomain:@"No Queue" code:0 userInfo:nil];
        if (callBack) {
            callBack(nil,error);
        }
    }
}

#pragma mark --条件更新
-(void)updateTable:(NSString *)tableName keyValues:(NSDictionary *)keyValues whereClause:(NSString *)whereClause whereArgs:(NSArray *)whereArgs withCallBack:(HWDBCallBack)callBack {
    if (self.queue) {
        [self.queue inDatabase:^(FMDatabase *db) {
            NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"UPDATE %@ SET", tableName]];
            
            NSMutableArray *values = [NSMutableArray array];
            NSArray *keys = [keyValues allKeys];
            for (NSInteger i = 0; i < [keys count]; i++) {
                NSString *key = keys[i];
                NSString *value = keyValues[key];
                [values addObject:value];
                [sql appendFormat:@" %@ = ?",key];
                if (i < [keys count]-1) {
                    [sql appendString:@", "];
                }
            }
            
            [sql appendFormat:@" WHERE %@", whereClause];
            
            if ([whereArgs count] > 0) {
                [values addObjectsFromArray:whereArgs];
            }
            
            NSError *error = nil;
            BOOL result = [db executeUpdate:sql values:values error:&error];
            if (callBack) {
                callBack(nil, result ? nil : error);
            }
        }];
    } else {
        NSError *error = [NSError errorWithDomain:@"No Queue" code:0 userInfo:nil];
        if (callBack) {
            callBack(nil,error);
        }
    }
}

#pragma mark --条件查询数据库中的数据
-(void)selectFromTable:(NSString *)tableName columns:(NSArray *)columns selection:(NSString *)selection selectionArgs:(NSArray *)selectionArgs groupBy:(NSString *)groupBy having:(NSString *)having orderBy:(NSString *)orderBy limit:(NSString *)limit withCallBack:(HWDBCallBack)callBack {
    if (self.queue) {
        [self.queue inDatabase:^(FMDatabase *db) {
            NSMutableString *query = [NSMutableString stringWithFormat:@"SELECT %@, ", DB_ROWID];
            
            if ([columns count] > 0) {
                for (NSInteger i = 0; i < [columns count]; i++) {
                    [query appendString:columns[i]];
                    if (i < [columns count]-1) {
                        [query appendString:@", "];
                    }
                }
            } else {
                [query appendString:@"*"];
            }
            [query appendFormat:@" FROM %@",tableName];
            
            if (selection != nil && selection.length > 0) {
                [query appendFormat:@" WHERE (%@)", selection];
            }
            if (groupBy != nil) {
                [query appendFormat:@" GROUP BY %@", groupBy];
            }
            if (having != nil) {
                [query appendFormat:@" HAVING %@", having];
            }
            if (orderBy != nil) {
                [query appendFormat:@" ORDER BY %@", orderBy];
            }
            if (limit != nil) {
                [query appendFormat:@" LIMIT %@", limit];
            }
            NSError *error = nil;
            FMResultSet *result =  [db executeQuery:query values:selectionArgs error:&error];
            NSArray *resultArray = [self getArrWithFMResultSet:result];
            if (callBack) {
                callBack(resultArray,error);
            }
            [result close];
        }];
    } else {
        NSError *error = [NSError errorWithDomain:@"No Queue" code:0 userInfo:nil];
        if (callBack) {
            callBack(nil,error);
        }
    }
}

-(void)selectWithRawQuery:(NSString *)query values:(NSArray *)values withCallBack:(HWDBCallBack)callBack {
    if (self.queue) {
        [self.queue inDatabase:^(FMDatabase *db) {
            NSError *error = nil;
            FMResultSet *result =  [db executeQuery:query values:values error:&error];
            NSArray *resultArray = [self getArrWithFMResultSet:result];
            if (callBack) {
                callBack(resultArray,error);
            }
            [result close];
        }];
    } else {
        NSError *error = [NSError errorWithDomain:@"No Queue" code:0 userInfo:nil];
        if (callBack) {
            callBack(nil,error);
        }
    }
}

- (void)selectWithRawQuery:(NSString *)query values:(NSArray *)values dataBase:(FMDatabase *)dataBase withCallBack:(HWDataBaseCallBack)callBack {
    if (self.queue) {
        void (^callDatabase)(FMDatabase *db) = ^(FMDatabase *db){
            NSError *error = nil;
            FMResultSet *result =  [db executeQuery:query values:values error:&error];
            NSArray *resultArray = [self getArrWithFMResultSet:result];
            if (callBack) {
                callBack(resultArray,db,error);
            }
            [result close];
        };
        if (!dataBase) {
            [self.queue inDatabase:^(FMDatabase *db) {
                callDatabase(db);
            }];
        } else {
            callDatabase(dataBase);
        }
    } else {
        NSError *error = [NSError errorWithDomain:@"No Queue" code:0 userInfo:nil];
        if (callBack) {
            callBack(nil,nil,error);
        }
    }
}

#pragma mark --条件删除数据
-(void)deleteFromTable:(NSString *)tableName whereClause:(NSString *)whereClause whereArgs:(NSArray *)whereArgs withCallBack:(HWDBCallBack)callBack {
    if (self.queue) {
        [self.queue inDatabase:^(FMDatabase *db) {
            NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"DELETE FROM %@ ", tableName]];
            if (whereClause) {
                [sql appendFormat:@"WHERE %@",whereClause];
            }
            NSError *error = nil;
            BOOL result = [db executeUpdate:sql values:whereArgs error:&error];
            if (callBack) {
                callBack(nil, result ? nil : error);
            }
        }];
    } else {
        NSError *error = [NSError errorWithDomain:@"No Queue" code:0 userInfo:nil];
        if (callBack) {
            callBack(nil,error);
        }
    }
}

#pragma mark --CommonMethod
- (NSArray *)getArrWithFMResultSet:(FMResultSet *)result {
    NSMutableArray *tempArr = [NSMutableArray array];
    while ([result next]) {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        for (int i = 0; i < [result columnCount]; i++) {
            NSString * columnName = [result columnNameForIndex:i];
            id value = [result objectForColumnName:columnName];
            [tempDic setValue:value forKey:columnName];
        }
        [tempArr addObject:tempDic];
    }
    return tempArr;
}

#pragma mark -- 添加列
- (BOOL)database:(FMDatabase *)db alterTable:(NSString *)tableName addColumn:(NSString *)columnName type:(NSString *)type {
    NSMutableString *sql = [NSMutableString string];
    if (![db tableExists:tableName]) {
        NSString *column = [NSString stringWithFormat:@"%@ %@",columnName,type];
        [sql appendFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@)",tableName, column];
        
        NSError *error = nil;
        BOOL createTableResult = [db executeUpdate:sql values:nil error:&error];
        NSLog(@"Create Table %@ , result : %@", tableName, @(createTableResult));
        return YES;
    } else {
        if (![db columnExists:columnName inTableWithName:tableName]) {
            NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ %@",tableName,columnName,type];
            return [db executeUpdate:sql];
        }
    }
    return YES;
}

- (NSString *)getKeyTypeWithValue:(id)value {
    if ([value isKindOfClass:[NSString class]]) {
        return DataBaseColumnTypeText;
    } else if([value isKindOfClass:[NSData class]]) {
        return DataBaseColumnTypeBlob;
    } else if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber *num = value;
        if (num == (void*)kCFBooleanFalse || num == (void*)kCFBooleanTrue) {
            return DataBaseColumnTypeBoolean;
        } else {
            if(CFNumberIsFloatType((CFNumberRef)num)) {
                return DataBaseColumnTypeFloat;
            }
            else {
                return DataBaseColumnTypeInteger;
            }
        }
    }
    return nil;
}

- (void)dealloc {
    [self.queue close];
}

@end
