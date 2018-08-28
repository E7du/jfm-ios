//
//  TableMeta.h
//  jfm
//
//  Created by Jobsz on 8/18/16.
//  Copyright © 2018 E7du. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ColumnMeta;

@interface TableMeta : NSObject

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Table Version will auto sync from db version
 */
@property (nonatomic, assign) NSUInteger v;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Table Name
 */
@property (nonatomic, copy) NSString *name;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Table PrimaryKey
 */
@property (nonatomic, copy) ColumnMeta *primaryKey;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Table Columns
 */
@property (nonatomic, copy) NSArray<ColumnMeta *> *columns;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Db Table Cat Version's String
 *
 *  @return tableName_version
 */
- (NSString *)tableNameRefVersion;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Init Table With Name
 *
 *  @param name table's name
 *
 *  @return a new Table
 */
+ (TableMeta *)tableWithName:(NSString *)name;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Init Table With Name and PrimaryKey Coloumn
 *
 *  @param name       table's name
 *  @param primaryKey column
 *
 *  @return a new Table
 */
+ (TableMeta *)tableWithName:(NSString *)name primaryKey:(ColumnMeta *)primaryKey;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Init Table With Name, PrimaryKey column and columns
 *
 *  @param name       table's name
 *  @param primaryKey column
 *  @param columns
 *
 *  @return a new Table
 */
+ (TableMeta *)tableWithName:(NSString *)name primaryKey:(ColumnMeta *)primaryKey columns:(NSArray *)columns;
@end
