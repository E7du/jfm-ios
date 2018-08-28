//
//  Db.h
//  jfm
//
//  Created by Jobsz on 8/19/16.
//  Copyright © 2018 E7du. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ModelProcol;
@class DbMeta;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Db
 */
@interface Db : NSObject

#define JFMDB [Db share]
+ (Db *)share;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Set Db Extesion
 *
 *  @param ext 
 */
- (void)dbExt:(NSString *)ext;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Open Db
 *
 *  @param dbMeta
 */
- (BOOL)open:(DbMeta *)dbMeta;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Db File Path
 */
- (NSString *)dbPath;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Transaction
 */
- (BOOL)transaction:(void (^)(void))tx;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Execute Sql, No Transaction
 *
 *  @param sql
 */
- (BOOL)executeSql:(const NSString *)sql;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Save Record, No Transaction
 *
 *  @param record data
 */
- (BOOL)saveRecord:(id<ModelProcol>)record;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Update record, No Transaction
 *
 *  @param record data
 */
- (BOOL)updateRecord:(id<ModelProcol>)record;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief delete record, No Transaction
 *
 *  @param record data
 */
- (BOOL)deleteRecord:(id<ModelProcol>)record;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief query record
 *
 *  @param record datas
 */
- (NSArray<id<ModelProcol>> *)queryRecord:(id<ModelProcol>)record;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Query Data , filter like Value
 *
 *  @param record ref table
 *  @param column name
 *  @param val like value
 */
- (NSArray<id<ModelProcol>> *)queryRecord:(id<ModelProcol>)record column:(const NSString *)column likeValue:(id)val;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Query Data , filter or Value
 *
 *  @param record ref table
 *  @param column name
 *  @param val like value
 */
- (NSArray<id<ModelProcol>> *)queryRecord:(id<ModelProcol>)record column:(const NSString *)column orValue:(id)val;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Query Data , filter != Value
 *
 *  @param record ref table
 *  @param column name
 *  @param val != value
 */
- (NSArray<id<ModelProcol>> *)queryRecord:(id<ModelProcol>)record column:(const NSString *)column neqValue:(id)val;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Query Data , filter <= Value
 *
 *  @param record ref table
 *  @param column name
 *  @param val <= value
 */
- (NSArray<id<ModelProcol>> *)queryRecord:(id<ModelProcol>)record column:(const NSString *)column leValue:(id)val;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Query Data , filter < Value
 *
 *  @param record ref table
 *  @param column name
 *  @param val < value
 */
- (NSArray<id<ModelProcol>> *)queryRecord:(id<ModelProcol>)record column:(const NSString *)column ltValue:(id)val;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Query Data , filter >= Value
 *
 *  @param record ref table
 *  @param column name
 *  @param val >= value
 */
- (NSArray<id<ModelProcol>> *)queryRecord:(id<ModelProcol>)record column:(const NSString *)column geValue:(id)val;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Query Data , filter > Value
 *
 *  @param record ref table
 *  @param column name
 *  @param val > value
 */
- (NSArray<id<ModelProcol>> *)queryRecord:(id<ModelProcol>)record column:(const NSString *)column gtValue:(id)val;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Query Data , filter between end
 *
 *  @param record  ref table
 *  @param column  name
 *  @param between
 *  @param end
 */
- (NSArray<id<ModelProcol>> *)queryRecord:(id<ModelProcol>)record column:(const NSString *)column between:(id)between end:(id)end;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Query All Record
 *
 *  @param record record
 *
 *  @return record datas
 */
- (NSArray<id<ModelProcol>> *)queryAllRecord:(id<ModelProcol>)record;

/*!
 *  @author kuangxiongfeng, 16-09-18 13:09:55
 *
 *  @brief migration tables
 */
- (void)migration;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Close Db
 */
- (BOOL)close;

@end
