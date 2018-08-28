//
//  ColumnType.m
//  jfm
//
//  Created by Jobsz on 8/18/16.
//  Copyright © 2018 E7du. All rights reserved.
//

#import "ColumnType.h"

NSString *SQLITE_TEXT  = @"TEXT";
NSString *SQLITE_INTEGER = @"INTEGER";
NSString *SQLITE_REAL = @"REAL";

NSString *SQLITE_TEXT_DEFAULT_VALUE = @"\\\"\\\"";
NSString *SQLITE_INT_DEFALUT_VALUE = @"0";
NSString *SQLITE_REAL_DEFAULT_VALUE = @"0.0";

NSString *OBJC_TEXT = @"NSString *";
NSString *OBJC_INTEGER = @"NSInteger";
NSString *OBJC_UINTEGER = @"NSUInteger";
NSString *OBJC_REAL = @"double";

@implementation ColumnType

+ (NSString *)objcText
{
    return OBJC_TEXT;
}

+ (NSString *)objcInteger
{
    return OBJC_INTEGER;
}

+ (NSString *)objcUinteger
{
    return OBJC_UINTEGER;
}

+ (NSString *)objcReal
{
    return OBJC_REAL;
}

+ (const NSString *)sqliteType:(NSString *)objcType
{
    if ([objcType isEqualToString:[self objcReal]]) {
        return SQLITE_REAL;
    } else if ([objcType isEqualToString:[self objcInteger]]
               || [objcType isEqualToString:[self objcUinteger]]) {
        return SQLITE_INTEGER;
    }
    return SQLITE_TEXT;
}

+ (NSString *)defaultValueForSqliteType:(NSString *)sqliteType
{
    if ([SQLITE_REAL isEqualToString:sqliteType]) {
        return SQLITE_REAL_DEFAULT_VALUE;
    } else if ([SQLITE_INTEGER isEqualToString:sqliteType]) {
        return SQLITE_INT_DEFALUT_VALUE;
    }
    return SQLITE_TEXT_DEFAULT_VALUE;
}

+ (NSString *)defaultValueForObjcType:(NSString *)objcType
{
    return [self defaultValueForSqliteType:[self sqliteType:objcType]];
}

@end
