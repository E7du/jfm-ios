//
//  DbMeta.h
//  jfm
//
//  Created by Jobsz on 8/18/16.
//  Copyright © 2018 E7du. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TableMeta;

@interface DbMeta : NSObject

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief db name
 */
@property (nonatomic, copy) NSString *name;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief db version
 */
@property (nonatomic, assign) NSUInteger v;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief tables
 */
@property (nonatomic, copy) NSArray<TableMeta*> *tables;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Init Database
 *
 *  @param name    db's name
 *  @param version db's version
 *  @param tables  db's tables
 *
 *  @return a new Db
 */
+ (DbMeta *)dbWithName:(NSString *)name version:(NSUInteger)version tables:(NSArray<TableMeta *> *)tables;

@end
