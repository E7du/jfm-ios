//
//  SqlKit.m
//  jfm
//
//  Created by Jobsz on 8/19/16.
//  Copyright © 2018 E7du. All rights reserved.
//

#import "SqlKit.h"
#import "Model.h"
#import "Consts.h"

@implementation SqlKit

+ (const NSString *)saveSql:(id<ModelProcol>)record
{
    NSAssert(record, @"Record Can not be nil!");
    
    NSMutableString *columns = [NSMutableString string];
    NSMutableString *values = [NSMutableString string];
    id<ModelProcol> effientAttr = [record efficientAttrs];
    NSArray<NSString *> *keys = [effientAttr getAttrKeys];
    for (id key in keys) {
        [columns appendFormat:@"`%@`, ", key];
        [values appendFormat:@"'%@', ", [effientAttr get:key]];
    }
    [columns deleteCharactersInRange:NSMakeRange(columns.length-2, 2)];
    [values deleteCharactersInRange:NSMakeRange(values.length-2, 2)];
    
    return [NSString stringWithFormat:@"INSERT INTO `%@` (%@) VALUES(%@)", [[record class] tableName], columns, values];
}

+ (const NSString *)updateSql:(id<ModelProcol>)record
{
    NSAssert(record, @"Record Can not be nil!");
    
    NSMutableString *setColumns = [NSMutableString string];
    id<ModelProcol> effientAttr = [record efficientAttrs];
    NSString *primaryKey = [[record class] primaryKey];
    id dataId = [[effientAttr getAttrs] valueForKey:primaryKey];
    if (nil == dataId) {
        @throw [NSException exceptionWithName:@"IllegalArgumentException" reason:[NSString stringWithFormat:@"%@'s \"%@\" property Not Found!.", [record class], primaryKey] userInfo:nil];
    }
    NSArray<NSString *> *keys = [effientAttr getAttrKeys];
    for (id key in keys) {
        [setColumns appendFormat:@"`%@` = '%@', ", key, [effientAttr get:key]];
    }
    [setColumns deleteCharactersInRange:NSMakeRange(setColumns.length-2, 2)];
    return [NSString stringWithFormat:@"UPDATE `%@` SET %@ WHERE `%@` = '%@'", [[record class] tableName], setColumns, primaryKey, dataId];
}

+ (const NSString *)deleteSql:(id<ModelProcol>)record
{
    NSAssert(record, @"Record Can not be nil!");
    
    id<ModelProcol> effientAttr = [record efficientAttrs];
    NSString *primaryKey = [[record class] primaryKey];
    id dataId = [[effientAttr getAttrs] valueForKey:primaryKey];
    if (nil == dataId) {
        @throw [NSException exceptionWithName:@"IllegalArgumentException" reason:[NSString stringWithFormat:@"%@'s \"%@\" property Not Found!.", [record class], primaryKey] userInfo:nil];
    }
    return [NSString stringWithFormat:@"DELETE FROM `%@` WHERE `%@` = '%@'", [[record class] tableName], primaryKey, dataId];
}

+ (const NSString *)querySql:(id<ModelProcol>)record
{
    NSAssert(record, @"Record Can not be nil!");
    
    id<ModelProcol> effientAttr = [record efficientAttrs];
    NSString *primaryKey = [[record class] primaryKey];
    id dataId = [[effientAttr getAttrs] valueForKey:primaryKey];
    if (nil != dataId) {
        return [NSString stringWithFormat:@"SELECT * FROM `%@` WHERE `%@` = '%@' LIMIT 1", [[record class] tableName], primaryKey, dataId];
    }
    
    NSMutableString *columns = [NSMutableString string];
    NSArray<NSString *> *keys = [effientAttr getAttrKeys];
    if (nil == keys || keys.count == 0) {
        return [self queryAllSql:record];
    }
    for (NSString *key in keys) {
        [columns appendFormat:@" `%@` = '%@' AND", key, [effientAttr get:key]];
    }
    [columns deleteCharactersInRange:NSMakeRange(columns.length-4, 4)];
    return [NSString stringWithFormat:@"SELECT * FROM `%@` WHERE%@",[[record class] tableName], columns];
}

+ (const NSString *)queryRecord:(id<ModelProcol>)record column:(const NSString *)column filter:(NSString *)filter value:(id)val
{
    id<ModelProcol> effientAttr = [record efficientAttrs];
    NSArray<NSString *> *keys = [effientAttr getAttrKeys];
    NSString *where = @"";
    NSString *ops = @" AND ";
    if (nil == keys || keys.count == 0) {
        where = @" WHERE ";
        ops = @"";
    } else if ([@"OR" isEqualToString:filter]) {
        ops = @" OR ";
        filter = @"=";
    }
    return [NSString stringWithFormat:@"%@%@%@`%@` %@ '%@'", [self querySql:record], where, ops, column, filter, val];
}

+ (const NSString *)querySql:(id<ModelProcol>)record column:(const NSString *)column likeValue:(id)val
{
    return [self queryRecord:record column:column filter:@"LIKE" value:[NSString stringWithFormat:@"%%%@%%", val]];
}

+ (const NSString *)querySql:(id<ModelProcol>)record column:(const NSString *)column orValue:(id)val
{
    return [self queryRecord:record column:column filter:@"OR" value:val];
}

+ (const NSString *)querySql:(id<ModelProcol>)record column:(const NSString *)column neqValue:(id)val
{
    return [self queryRecord:record column:column filter:@"!=" value:val];
}

+ (const NSString *)querySql:(id<ModelProcol>)record column:(const NSString *)column leValue:(id)val
{
    return [self queryRecord:record column:column filter:@"<=" value:val];
}

+ (const NSString *)querySql:(id<ModelProcol>)record column:(const NSString *)column ltValue:(id)val
{
    return [self queryRecord:record column:column filter:@"<" value:val];
}

+ (const NSString *)querySql:(id<ModelProcol>)record column:(const NSString *)column geValue:(id)val
{
    return [self queryRecord:record column:column filter:@">=" value:val];
}

+ (const NSString *)querySql:(id<ModelProcol>)record column:(const NSString *)column gtValue:(id)val
{
    return [self queryRecord:record column:column filter:@">" value:val];
}

+ (const NSString *)querySql:(id<ModelProcol>)record column:(const NSString *)column between:(id)between end:(id)end
{
    id<ModelProcol> effientAttr = [record efficientAttrs];
    NSArray<NSString *> *keys = [effientAttr getAttrKeys];
    NSString *where = @"";
    NSString *ops = @" AND ";
    if (nil == keys || keys.count == 0) {
        where = @" WHERE ";
        ops = @"";
    }
    return [NSString stringWithFormat:@"%@%@%@`%@` BETWEEN '%@' AND '%@'", [self querySql:record], where, ops, column, between, end];
}

+ (const NSString *)queryAllSql:(id<ModelProcol>)record
{
    NSAssert(record, @"Record Can not be nil!");
    
    return [NSString stringWithFormat:@"SELECT * FROM `%@`", [[record class] tableName]];
}

@end
