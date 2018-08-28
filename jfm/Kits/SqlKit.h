//
//  SqlKit.h
//  jfm
//
//  Created by Jobsz on 8/19/16.
//  Copyright © 2018 E7du. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ModelProcol;

@interface SqlKit : NSObject

+ (const NSString *)saveSql:(id<ModelProcol>)record;

+ (const NSString *)updateSql:(id<ModelProcol>)record;

+ (const NSString *)deleteSql:(id<ModelProcol>)record;

+ (const NSString *)querySql:(id<ModelProcol>)record;

/**
 * column like value
 */
+ (const NSString *)querySql:(id<ModelProcol>)record column:(const NSString *)column likeValue:(id)val;

/**
 * or column = value
 */
+ (const NSString *)querySql:(id<ModelProcol>)record column:(const NSString *)column orValue:(id)val;

/**
 * column != val
 */
+ (const NSString *)querySql:(id<ModelProcol>)record column:(const NSString *)column neqValue:(id)val;

/**
 * column <= val
 */
+ (const NSString *)querySql:(id<ModelProcol>)record column:(const NSString *)column leValue:(id)val;

/**
 * column < val
 */
+ (const NSString *)querySql:(id<ModelProcol>)record column:(const NSString *)column ltValue:(id)val;

/**
 * column >= val
 */
+ (const NSString *)querySql:(id<ModelProcol>)record column:(const NSString *)column geValue:(id)val;

/**
 *  column > val
 */
+ (const NSString *)querySql:(id<ModelProcol>)record column:(const NSString *)column gtValue:(id)val;

/**
 *  column BETWEEN between AND end
 */
+ (const NSString *)querySql:(id<ModelProcol>)record column:(const NSString *)column between:(id)between end:(id)end;

/**
 * Query all data
 */
+ (const NSString *)queryAllSql:(id<ModelProcol>)record;

@end
