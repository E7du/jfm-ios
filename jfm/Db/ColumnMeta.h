//
//  ColumnMeta.h
//  jfm
//
//  Created by Jobsz on 8/18/16.
//  Copyright © 2018 E7du. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColumnMeta : NSObject

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Column name
 */
@property (nonatomic, copy) NSString *name;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Column Type, use [ColumnType objcText]...
 */
@property (nonatomic, copy) NSString *type;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Column Default Value
 */
@property (nonatomic, copy) id defaultValue;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Init Lite Column With Name and Type
 *
 *  @param name column's name
 *  @param type column's type , use [ColumnType objcText]...
 *
 *  @return a new Column
 */
+ (ColumnMeta *)columnWithName:(NSString *)name type:(NSString *)type;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Init Lite Column With Name, Type and DefaultValu
 *
 *  @param name       column's name
 *  @param type       column's type, use [ColumnType objcText]...
 *  @param defaultVal column's defalut value
 *
 *  @return a new column
 */
+ (ColumnMeta *)columnWithName:(NSString *)name type:(NSString *)type defaultVal:(id)defaultVal;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Init PrimaryKey Column With Name
 *
 *  @param name primaryKey Column's name
 *
 *  @return a new PrimaryKey
 */
+ (ColumnMeta *)primaryKeyWithName:(NSString *)name;

@end
