//
//  HWDataBaseManager.h
//  TestDB
//
//  Created by Honeywell on 2017/4/11.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

typedef void (^HWDBCallBack)(id object, NSError *error);
typedef void (^HWDataBaseCallBack)(id object, FMDatabase *db, NSError *error);

extern NSString *const DB_ROWID;

extern NSString *const DataBaseColumnTypeText;
extern NSString *const DataBaseColumnTypeInteger;
extern NSString *const DataBaseColumnTypeFloat;
extern NSString *const DataBaseColumnTypeBlob;
extern NSString *const DataBaseColumnTypeBoolean;

@interface HWDataBaseManager : NSObject

/**
 *  创建数据库
 *
 *  @param dbName 数据库名称(带后缀.sqlite)
 */
- (id)initWithDBName:(NSString *)dbName;

/**
 *  打开数据库
 *
 *  @param dbPath 数据库名称(带后缀.sqlite)
 */
- (id)initAndOpenWithDBPath:(NSString *)dbPath;

/**
 *  给指定数据库建表
 *
 *  @param tableName 表的名称
 *  @param keyTypes   所含字段以及对应字段类型 字典
 */
-(void)createTable:(NSString *)tableName keyTypes:(NSDictionary *)keyTypes withCallBack:(HWDBCallBack)callBack;

/**
 *  给指定数据库的表添加值
 *
 *  @param tableName 表名
 *  @param keyValues 字段及对应的值
 */
-(void)insertIntoTable:(NSString *)tableName KeyValues:(NSDictionary *)keyValues withCallBack:(HWDBCallBack)callBack;

/**
 *  给指定数据库的表批量添加值
 *
 *  @param tableName      表名
 *  @param keyValuesArray 字段及对应的值的数组
 */
-(void)insertIntoTable:(NSString *)tableName KeyValuesArray:(NSArray *)keyValuesArray withCallBack:(HWDBCallBack)callBack;

/**
 *  条件更新
 *
 *  @param tableName 表名称
 *  @param keyValues 要更新的字段及对应值
 */
-(void)updateTable:(NSString *)tableName keyValues:(NSDictionary *)keyValues whereClause:(NSString *)whereClause whereArgs:(NSArray *)whereArgs withCallBack:(HWDBCallBack)callBack;

/**
 *  条件查询数据库中的数据
 *
 *  @param tableName 表名称
 *  @param callBack  查询回调
 */
-(void)selectFromTable:(NSString *)tableName columns:(NSArray *)columns selection:(NSString *)selection selectionArgs:(NSArray *)selectionArgs groupBy:(NSString *)groupBy having:(NSString *)having orderBy:(NSString *)orderBy limit:(NSString *)limit withCallBack:(HWDBCallBack)callBack;

-(void)selectWithRawQuery:(NSString *)query values:(NSArray *)values withCallBack:(HWDBCallBack)callBack;

- (void)selectWithRawQuery:(NSString *)query values:(NSArray *)values dataBase:(FMDatabase *)dataBase withCallBack:(HWDataBaseCallBack)callBack;

/**
 *  条件删除数据
 *
 *  @param tableName 表名称
 *
 */
-(void)deleteFromTable:(NSString *)tableName whereClause:(NSString *)whereClause  whereArgs:(NSArray *)whereArgs withCallBack:(HWDBCallBack)callBack;

@end
