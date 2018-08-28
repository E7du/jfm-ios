//
//  Model.h
//  jfm
//
//  Created by Jobsz on 8/17/16.
//  Copyright © 2018 E7du. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ModelProcol <NSObject>

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief init Model
 *
 *  @param dict data
 *
 *  @return Model
 */
- (id<ModelProcol>)initWithDictionary:(const NSDictionary *)dict;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Set Value For Key
 *
 *  @param key data key
 *  @param val data value
 *
 *  @return implment ModelProcol's kind
 */
- (id<ModelProcol>)set:(NSString *)key value:(const id)val;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Put Value For Key @see set
 *
 *  @param key data key
 *  @param val data value
 *
 *  @return Model's kind
 */
- (id<ModelProcol>)put:(NSString *)key value:(const id)val;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Put Data to Model
 *
 *  @param data : NSDictionary or Model
 *
 *  @return implment ModelProcol's kind
 */
- (id<ModelProcol>)put:(const id)data;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Get Value For key
 *
 *  @param key data key
 *
 *  @return the value for key in model
 */
- (id)get:(NSString *)key;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Get Value For Key
 *
 *  @param key          data key
 *  @param defalutValue data default value while the value for key is nil.
 *
 *  @return the value for Key in model
 */
- (id)get:(NSString *)key defaultValue:(const id)defalutValue;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Get String Value For Key, if the value is nil, return @"".
 *
 *  @param key data key
 *
 *  @return the data key's string value.
 */
- (NSString *)getStr:(NSString *)key;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Get Int Value For Key, if the value is nil, return 0.
 *
 *  @param key data key
 *
 *  @return the data key's int value.
 */
- (NSInteger)getInt:(NSString *)key;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Get Unsigned Int Value For Key, if the value is nil, return 0.
 *
 *  @param key data key
 *
 *  @return the data key's unsigned int value.
 */
- (NSUInteger)getUInt:(NSString *)key;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Get Long Value For Key, if the value is nil, return 0.
 *
 *  @param key data key
 *
 *  @return the data key's long value.
 */
- (long)getLong:(NSString *)key;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Get LongLong Value For Key, if the value is nil, return 0.
 *
 *  @param key data key
 *
 *  @return the data key's longlong value.
 */
- (long long)getLongLong:(NSString *)key;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Get Date Value For Key, if the value is nil, return [NSDate date].
 *
 *  @param key data key
 *
 *  @return the data key's date value.
 */
- (NSDate *)getDate:(NSString *)key;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Get Double Value For Key, if the value is nil, return 0.0 .
 *
 *  @param key data key
 *
 *  @return the data key's double value.
 */
- (double)getDouble:(NSString *)key;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Get Float Value For Key, if the value is nil, return 0.0 .
 *
 *  @param key data key
 *
 *  @return the data key's float value.
 */
- (float)getFloat:(NSString *)key;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Get BOOL Value For Key, if the value is nil, return NO.
 *
 *  @param key data key
 *
 *  @return the data key's boolean value.
 */
- (BOOL)getBool:(NSString *)key;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Get Byte Value For Key, if the value is nil, return 0.
 *
 *  @param key data key
 *
 *  @return the data key's byte value.
 */
- (Byte)getByte:(NSString *)key;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Get Model Attrs
 *
 *  @return all attrs
 */
- (NSMutableDictionary *)getAttrs;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Get Model Attrs's All Keys
 *
 *  @return attrs's all keys
 */
- (NSArray<NSString *> *)getAttrKeys;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Get Model Attrs's All Values
 *
 *  @return attrs's all values
 */
- (NSArray<id> *)getAttrValues;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Set Model's Attrs
 *
 *  @param data : NSDictionary or Model
 *
 *  @return implment ModelProcol's kind
 */
- (id<ModelProcol>)setAttrs:(const id)data;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Remove Key[s]
 *
 *  @param key that is removing from model
 *
 *  @return implment ModelProcol's kind
 */
- (id<ModelProcol>)remove:(const NSString *)key;//, ...;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Keep Attr[s] in Model
 *
 *  @param key that is keeping from model
 *
 *  @return implment ModelProcol's kind, return new instance
 */
- (id<ModelProcol>)keep:(const NSString *)key, ...;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Clear All Attrs
 *
 *  @return Model, return new instance
 */
- (id<ModelProcol>)clear;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Clear Some Key[s] From Model
 *
 *  @param key that is removing from model
 *
 *  @return implment ModelProcol's kind, return new instance
 */
- (id<ModelProcol>)clear:(const NSString *)key;//, ...;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Get efficientAttrs
 *
 *  @return remove sys attrs
 */
- (id<ModelProcol>)efficientAttrs;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Save Data
 *
 *  @return YES: success; NO: failure
 */
- (BOOL)save;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Update Data
 *
 *  @return YES: success; NO: failure
 */
- (BOOL)update;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Delete Data
 *
 *  @return YES: success; NO: failure
 */
- (BOOL)del;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Query Data
 *
 *  @return datas
 */
- (NSArray<id<ModelProcol>> *)query;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Instance Query Datas
 *
 *  @param column name
 *  @param value
 *
 *  @return query out datas
 */
- (NSArray<id<ModelProcol>> *)find:(const NSString *)column value:(id)value;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Instance Query Datas While column value != value
 *
 *  @param column name
 *  @param value
 *
 *  @return query out datas
 */
- (NSArray<id<ModelProcol>> *)find:(const NSString *)column neqValue:(id)value;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Instance Query Datas While column value LIKE value
 *
 *  @param column name
 *  @param value
 *
 *  @return query out datas
 */
- (NSArray<id<ModelProcol>> *)find:(const NSString *)column likeValue:(id)value;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Instance Query Datas While column value OR value
 *
 *  @param column name
 *  @param value
 *
 *  @return query out datas
 */
- (NSArray<id<ModelProcol>> *)find:(const NSString *)column orValue:(id)value;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Instance Query Datas While column value <= value
 *
 *  @param column name
 *  @param value
 *
 *  @return query out datas
 */
- (NSArray<id<ModelProcol>> *)find:(const NSString *)column leValue:(id)value;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Instance Query Datas While column value < value
 *
 *  @param column name
 *  @param value
 *
 *  @return query out datas
 */
- (NSArray<id<ModelProcol>> *)find:(const NSString *)column ltValue:(id)value;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Instance Query Datas While column value >= value
 *
 *  @param column name
 *  @param value
 *
 *  @return query out datas
 */
- (NSArray<id<ModelProcol>> *)find:(const NSString *)column geValue:(id)value;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Instance Query Datas While column value > value
 *
 *  @param column name
 *  @param value
 *
 *  @return query out datas
 */
- (NSArray<id<ModelProcol>> *)find:(const NSString *)column gtValue:(id)value;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Instance Query Datas While column value Between between and end
 *
 *  @param column name
 *  @param value
 *
 *  @return query out datas
 */
- (NSArray<id<ModelProcol>> *)find:(const NSString *)column between:(id)between end:(id)end;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Instace FindAll
 *
 *  @return query out datas
 */
- (NSArray<id<ModelProcol>> *)findAll;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Table PrimaryKey
 */
+ (NSString *)primaryKey;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Table name
 *
 *  @return table's name
 */
+ (const NSString *)tableName;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief DB or Table Version
 */
+ (const NSUInteger)v;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Sqlite Stmt
 *
 */
+ (const NSString *)stmt;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Query Datas
 *
 *  @param column name
 *  @param value
 *
 *  @return query out datas
 */
+ (NSArray<id<ModelProcol>> *)find:(const NSString *)column value:(id)value;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Query Datas While column value != value
 *
 *  @param column name
 *  @param value
 *
 *  @return query out datas
 */
+ (NSArray<id<ModelProcol>> *)find:(const NSString *)column neqValue:(id)value;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Query Datas While column value LIKE value
 *
 *  @param column name
 *  @param value
 *
 *  @return query out datas
 */
+ (NSArray<id<ModelProcol>> *)find:(const NSString *)column likeValue:(id)value;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Query Datas While column value OR value
 *
 *  @param column name
 *  @param value
 *
 *  @return query out datas
 */
+ (NSArray<id<ModelProcol>> *)find:(const NSString *)column orValue:(id)value;

/**
*  @author Jobsz(zcq@zhucongqi.cn)
*
*  @brief Query Datas While column value <= value
*
*  @param column name
*  @param value
*
*  @return query out datas
*/
+ (NSArray<id<ModelProcol>> *)find:(const NSString *)column leValue:(id)value;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Query Datas While column value < value
 *
 *  @param column name
 *  @param value
 *
 *  @return query out datas
 */
+ (NSArray<id<ModelProcol>> *)find:(const NSString *)column ltValue:(id)value;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Query Datas While column value >= value
 *
 *  @param column name
 *  @param value
 *
 *  @return query out datas
 */
+ (NSArray<id<ModelProcol>> *)find:(const NSString *)column geValue:(id)value;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Query Datas While column value > value
 *
 *  @param column name
 *  @param value
 *
 *  @return query out datas
 */
+ (NSArray<id<ModelProcol>> *)find:(const NSString *)column gtValue:(id)value;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Query Datas While column value Between between and end
 *
 *  @param column name
 *  @param value
 *
 *  @return query out datas
 */
+ (NSArray<id<ModelProcol>> *)find:(const NSString *)column between:(id)between end:(id)end;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Query All Data
 *
 *  @return query out datas
 */
+ (NSArray<id<ModelProcol>> *)findAll;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Query Data by Id
 *
 *  @param did value
 *
 *  @return find the data ref id
 */
+ (id<ModelProcol>)findById:(const NSString *)did;

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief Delete Data by Id
 *
 *  @param did value
 *
 *  @return delete the data ref id
 */
+ (BOOL)deleteById:(const NSString *)did;

@end

/**
 *  @author Jobsz(zcq@zhucongqi.cn)
 *
 *  @brief JFM model
 */
@interface Model : NSObject<ModelProcol>


@end
