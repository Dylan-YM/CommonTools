//
//  AppConnector.m
//  iOSCommonAppPlatform
//
//  Created by Liu, Carl on 23/03/2017.
//  Copyright © 2017 Honeywell. All rights reserved.
//

#import "AppConnector.h"
#import "LogUtil.h"
#import <UIKit/UIKit.h>




//Common
static NSString * const COMMAND             = @"command";
static NSString * const CALLBACK_ID         = @"callbackId";
static NSString * const PARAM               = @"param";

static NSString * const RESULT              = @"result";
static NSString * const RESPONSE            = @"response";

static NSString * const ERROR               = @"error";
static NSString * const CODE                = @"code";
static NSString * const MESSAGE             = @"message";

//Database
static NSString * const DATABASE            = @"cmd_database_execute";

static NSString * const DB_SAVE             = @"save";
static NSString * const DB_DELETE           = @"delete";
static NSString * const DB_SELECT           = @"select";
static NSString * const DB_SELECT_SQL       = @"select_sql";
static NSString * const DB_UPDATE           = @"update";

static NSString * const DB_QUERY_TYPE       = @"query_type";
static NSString * const DB_TABLE            = @"table";
static NSString * const DB_VALUES           = @"values";
static NSString * const DB_SQL              = @"sql";
static NSString * const DB_SELECTION        = @"selection";
static NSString * const DB_SELECTION_ARGS   = @"selectionArgs";
static NSString * const DB_COLUMNS          = @"columns";
static NSString * const DB_GROUPBY          = @"groupBy";
static NSString * const DB_HAVING           = @"having";
static NSString * const DB_ORDERBY          = @"orderby";
static NSString * const DB_LIMIT            = @"limit";
static NSString * const DB_WHERE_CLAUSE     = @"whereClause";
static NSString * const DB_WHERE_ARGS       = @"whereArgs";

static NSString * const H5_LOG              = @"cmd_log_record";
static NSString * const LOG_TAG             = @"tag";
static NSString * const LOG_MESSAGE         = @"msg";

static NSString * const CMD_URL_OPEN        = @"cmd_url_open";
static NSString * const URL                 = @"url";

@interface AppConnector ()

@property (strong, nonatomic) HWDataBaseManager *dbManager;

@end

static AppConnector *service = nil;

@implementation AppConnector

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[AppConnector alloc] init];
    });
}

+ (AppConnector *)sharedInstance {
    return service;
}

- (void)setDBManager:(HWDataBaseManager *)manager {
    _dbManager = manager;
}



- (void)receiveCommandStart:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSString *command = userInfo[COMMAND];
    NSString *callbackId = userInfo[CALLBACK_ID];
    NSDictionary *param = userInfo[PARAM];
    
    NSMutableDictionary *res = [NSMutableDictionary dictionary];
    res[RESULT] = @(YES);
    res[RESPONSE] = @{};
    res[CALLBACK_ID] = callbackId;
    
    if ([command isEqualToString:DATABASE]) {
        NSString *queryType = param[DB_QUERY_TYPE];
        NSString *table = param[DB_TABLE];
        NSString *rowid = param[DB_ROWID];
        NSDictionary *values = param[DB_VALUES];
        
        NSString *sql = param[DB_SQL];
        NSString *selection = param[DB_SELECTION];
        NSArray *selectionArgs = param[DB_SELECTION_ARGS];
        NSArray *columns = param[DB_COLUMNS];
        NSString *groupBy = param[DB_GROUPBY];
        NSString *having = param[DB_HAVING];
        NSString *orderBy = param[DB_ORDERBY];
        NSString *limit = param[DB_LIMIT];
        NSString *whereClause = param[DB_WHERE_CLAUSE];
        NSArray *whereArgs = param[DB_WHERE_ARGS];

        HWDBCallBack executeCallback = ^(id object, NSError *error) {
            res[RESULT] = @(error == nil);
            res[RESPONSE] = object != nil ? object: @{};
            if (error) {
                res[ERROR] = @{CODE:@(error.code),
                               MESSAGE:error.domain};
            }
            
          
        };
        
        HWDBCallBack selectCallback = ^(id object, NSError *error) {
            res[RESULT] = @(error == nil);
            res[RESPONSE] = object != nil ? object: @{};
            if (error) {
                res[ERROR] = @{CODE:@(error.code),
                               MESSAGE:error.domain};
            }
            
           
        };
        
        if (table == nil) {
            executeCallback(nil, [NSError errorWithDomain:[NSString stringWithFormat:@"%@ : %@ is invalid", DB_TABLE, table] code:400 userInfo:nil]);
        } else {
            if ([queryType isEqualToString:DB_SAVE]) {
                if (rowid == nil) {
                    [self.dbManager insertIntoTable:table KeyValues:values withCallBack:executeCallback];
                } else {
                    whereClause = [NSString stringWithFormat:@"%@ = ?", DB_ROWID];
                    whereArgs = @[rowid];
                    [self.dbManager updateTable:table keyValues:values whereClause:whereClause whereArgs:whereArgs withCallBack:executeCallback];
                }
            } else if ([queryType isEqualToString:DB_SELECT]) {
                [self.dbManager selectFromTable:table columns:columns selection:selection selectionArgs:selectionArgs groupBy:groupBy having:having orderBy:orderBy limit:limit withCallBack:selectCallback];
            } else if ([queryType isEqualToString:DB_SELECT_SQL]) {
                [self.dbManager selectWithRawQuery:sql values:selectionArgs withCallBack:selectCallback];
            } else if ([queryType isEqualToString:DB_UPDATE]) {
                [self.dbManager updateTable:table keyValues:values whereClause:whereClause whereArgs:whereArgs withCallBack:executeCallback];
            } else if ([queryType isEqualToString:DB_DELETE]) {
                if (whereClause == nil) {
                    executeCallback(nil, [NSError errorWithDomain:[NSString stringWithFormat:@"%@ should not be nil", DB_WHERE_CLAUSE] code:400 userInfo:nil]);
                } else {
                    [self.dbManager deleteFromTable:table whereClause:whereClause whereArgs:whereArgs withCallBack:executeCallback];
                }
            } else {
                executeCallback(nil, [NSError errorWithDomain:[NSString stringWithFormat:@"%@ : %@ is invalid", DB_QUERY_TYPE,queryType] code:400 userInfo:nil]);
            }
        }
    } else if ([command isEqualToString:H5_LOG]) {
        NSString *tag = param[LOG_TAG];
        NSString *message = param[LOG_MESSAGE];
        [LogUtil log:LogError tag:tag message:message];
    
    } else if ([command isEqualToString:CMD_URL_OPEN]) {
        NSString *url = param[URL];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
    } else {
        //Just ignore other command
    }
}

@end
