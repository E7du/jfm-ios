//
//  CodeTemplate.h
//  jfm
//
//  Created by Jobsz on 8/18/16.
//  Copyright © 2018 E7du. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Cat)

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief append "\n"
 */
- (NSString *)catReturn;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief .m File
 *
 *  @return
 */
- (NSString *)source;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief .h File
 *
 *  @return 
 */
- (NSString *)header;

@end

@interface CodeTemplate : NSObject

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Code Comment
 *
 *  @return
 */
+ (NSString *)comment;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Header import code
 *
 *  @return
 */
+ (NSString *)headerImport;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief implementation import code
 *
 *  @param name Model name
 *
 *  @return
 */
+ (NSString *)implementationImport:(NSString *)name;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief interface code
 *
 *  @param name Model name
 *
 *  @return
 */
+ (NSString *)interface:(NSString *)name;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Private Category
 *
 *  @param name
 */
+ (NSString *)privateInterfaceCategory:(NSString *)name;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Private Category Property
 *
 *  @param name
 *  @param type
 */
+ (NSString *)privateInterfaceCategoryProperty:(NSString *)name type:(NSString *)type;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief implementation code
 *
 *  @param name Model name
 *
 *  @return
 */
+ (NSString *)implementation:(NSString *)name;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Property Extern Const
 *
 *  @param name property name
 *  @param model name
 *
 *  @return extern const NSString *name;
 */
+ (NSString *)propertyExternConst:(NSString *)name model:(NSString *)model;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Property Const
 *
 *  @param name property name
 *  @param model name
 *
 *  @return NSString *name = @"name";
 */
+ (NSString *)propertyConst:(NSString *)name model:(NSString *)model;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Table Extern Const
 *
 *  @param table name
 *
 *  @return extern const NSString *model_TABLE;
 */
+ (NSString *)tableExternConst:(NSString *)table;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Table Const
 *
 *  @param table name
 *
 *  @return NSString *modelname_TABLE = "modelname_version";
 */
+ (NSString *)tableConst:(NSString *)table version:(NSUInteger)version;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Model property code
 *
 *  @param name property name
 *
 *  @return @property...
 */
+ (NSString *)property:(NSString *)name type:(NSString *)type;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Setter
 *
 *  @param name property name
 *  @param type property type
 *
 *  @return setter template
 */
+ (NSString *)setter:(NSString *)name type:(NSString *)type;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Getter
 *
 *  @param name property name
 *  @param type property type
 *  @param defaultVal
 *
 *  @return getter template
 */
+ (NSString *)getter:(NSString *)name type:(NSString *)type defaultVal:(id)defaultVal;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief End code
 *
 *  @return @end
 */
+ (NSString *)end;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Primary Key Code
 *
 *  @param key column name
 */
+ (NSString *)primaryKey:(NSString *)key;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Table Name Code
 *
 *  @param table name
 *
 *  @return table name code
 */
+ (NSString *)tableName:(NSString *)table;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Version Code
 *
 *  @param version
 */
+ (NSString *)version:(NSUInteger)version;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Sql Stmt Templation
 *
 *  @param sql
 *
 *  @return CREATE ...
 */
+ (NSString *)stmt:(NSString *)sql;

@end
