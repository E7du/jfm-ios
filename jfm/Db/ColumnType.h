//
//  ColumnType.h
//  jfm
//
//  Created by Jobsz on 8/18/16.
//  Copyright © 2018 E7du. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColumnType : NSObject

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Objc NSString Type
 */
+ (NSString *)objcText;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Objc NSInteger
 */
+ (NSString *)objcInteger;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Objc NSUInteger
 */
+ (NSString *)objcUinteger;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Objc double
 */
+ (NSString *)objcReal;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief sqlite Type
 */
+ (NSString *)sqliteType:(NSString *)objcType;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Sqlite Type default value
 *
 *  @param sqliteType
 */
+ (NSString *)defaultValueForSqliteType:(NSString *)sqliteType;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Object Type default value
 *
 *  @param objcType
 */
+ (NSString *)defaultValueForObjcType:(NSString *)objcType;

@end
