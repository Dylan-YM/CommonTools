//
//  NSObject+SDSKeyValue.m
//  SFShopDistributionSystem
//
//  Created by 春香焦 on 2017/6/22.
//  Copyright © 2017年 SFBest. All rights reserved.
//

#import "NSObject+SDSKeyValue.h"

@implementation NSObject (SDSKeyValue)

#pragma mark - 模型 -> 字典
- (NSMutableDictionary *)sds_keyValues
{
    return [self mj_keyValues];
}

/**
 *  通过字典来创建一个模型
 *  @param keyValues 字典(可以是NSDictionary、NSData、NSString)
 *  @return 新建的对象
 */
+ (instancetype)sds_objectWithKeyValues:(id)keyValues {
    return [self mj_objectWithKeyValues:keyValues];
}

/**
 *  通过字典来创建一个CoreData模型
 *  @param keyValues 字典(可以是NSDictionary、NSData、NSString)
 *  @param context   CoreData上下文
 *  @return 新建的对象
 */
+ (instancetype)sds_objectWithKeyValues:(id)keyValues context:(NSManagedObjectContext *)context {
    return [self mj_objectWithKeyValues:keyValues context:context];
}

/**
 *  通过plist来创建一个模型
 *  @param filename 文件名(仅限于mainBundle中的文件)
 *  @return 新建的对象
 */
+ (instancetype)sds_objectWithFilename:(NSString *)filename {
    
    return [self mj_objectWithFilename:filename];
}

/**
 *  通过plist来创建一个模型
 *  @param file 文件全路径
 *  @return 新建的对象
 */
+ (instancetype)sds_objectWithFile:(NSString *)file {
    return [self mj_objectWithFile:file];
}

#pragma mark - 字典数组转模型数组
/**
 *  通过字典数组来创建一个模型数组
 *  @param keyValuesArray 字典数组(可以是NSDictionary、NSData、NSString)
 *  @return 模型数组
 */
+ (NSMutableArray *)sds_objectArrayWithKeyValuesArray:(id)keyValuesArray {
    return [self mj_objectArrayWithKeyValuesArray:keyValuesArray];
}

/**
 *  通过字典数组来创建一个模型数组
 *  @param keyValuesArray 字典数组(可以是NSDictionary、NSData、NSString)
 *  @param context        CoreData上下文
 *  @return 模型数组
 */
+ (NSMutableArray *)sds_objectArrayWithKeyValuesArray:(id)keyValuesArray context:(NSManagedObjectContext *)context {
    return [self mj_objectArrayWithKeyValuesArray:keyValuesArray context:context];
}


@end
