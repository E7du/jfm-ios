//
//  Model.m
//  jfm
//
//  Created by Jobsz on 8/17/16.
//  Copyright © 2018 E7du. All rights reserved.
//

#import "Model.h"
#import "Consts.h"
#import "DefaultValueKit.h"
#import "Db.h"

@interface Model()
{
    NSMutableDictionary *_attrs;
}
@end

@implementation Model

#pragma mark - Init

- (id<ModelProcol>)initWithDictionary:(const NSDictionary *)dict
{
    return [[[[self class] alloc] init] setAttrs:dict];
}

#pragma mark - native

- (instancetype)init
{
    self = [super init];
    if (self) {
        _attrs = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSString *)description
{
	NSMutableString *desc = [NSMutableString string];
	[desc appendString:@"\n"];
	[desc appendString:[super description]];
	[desc appendString:@"\n{\n"];
	
	NSEnumerator *enumerator = [_attrs keyEnumerator];
	id key = nil;
	BOOL first = YES;
	while(key = [enumerator nextObject]) {
		if (first) {
			first = NO;
		} else {
			[desc appendString:@",\n"];
		}
		[desc appendFormat:@"\t%@: %@", key, [_attrs valueForKey:key]];
	}
	[desc appendString:@"\n}"];
	return desc;
}

#pragma mark - private logic

- (NSArray *)args:(const NSString *)key;//, ...
{
    if (nil == key) {
        return [NSArray array];
    }
    
    NSMutableArray *args = [NSMutableArray array];
    [args addObject:key];
//    va_list params;
//    va_start(params, key);
//    id arg = nil;
//    if (key) {
//        id prev = key;
//        [args addObject:prev];
//        while(nil != (arg = va_arg(params, id))) {
//            if (arg) {
//                [args addObject:arg];
//            }
//        }
//        va_end(params);
//    }
    return args;
}

- (BOOL)matchSysKey:(NSString *)key
{
    return [OUTPUT_KEY isEqualToString:key]
    || [AS_KEY isEqualToString:key]
    || [OUTPUT_COLUMN_KEY isEqualToString:key]
    || [ORDER_KEY isEqualToString:key]
    || [OPS_KEY isEqualToString:key]
    || [PARAMS_KEY isEqualToString:key]
    || [ATTR_KEY isEqualToString:key];
}

#pragma mark - public logic

- (id<ModelProcol>)set:(NSString *)key value:(const id)val
{
    [_attrs setValue:val forKey:key];
    return self;
}

- (id<ModelProcol>)put:(NSString *)key value:(const id)val
{
    return [self set:key value:val];
}

/**
 * data: NSDictionary or Model
 */
- (id<ModelProcol>)put:(const id)data
{
    NSDictionary *dict = nil;
    if ([data isKindOfClass:[Model class]]) {
        dict = [((id<ModelProcol>)data) getAttrs];
    } else if ([data isKindOfClass:[NSDictionary class]]) {
        dict = data;
    }
    [_attrs setDictionary:dict];
    return self;
}

- (id)get:(NSString *)key
{
    return [self get:key defaultValue:[DefaultValueKit defaultValue:[_attrs valueForKey:key]]];
}

- (id)get:(NSString *)key defaultValue:(const id)defalutValue
{
	id val = [_attrs valueForKey:key];
    return (nil == val ? defalutValue : val);
}

- (NSString *)getStr:(NSString *)key
{
    return [self get:key defaultValue:@""];
}

- (NSInteger)getInt:(NSString *)key
{
    return [[self get:key defaultValue:@0] integerValue];
}

- (NSUInteger)getUInt:(NSString *)key
{
    return [[self get:key defaultValue:@0] unsignedIntegerValue];
}

- (long)getLong:(NSString *)key
{
    return [[self get:key defaultValue:@0] longValue];
}

- (long long)getLongLong:(NSString *)key
{
    return [[self get:key defaultValue:@0] longLongValue];
}

- (NSDate *)getDate:(NSString *)key
{
    return [self get:key defaultValue:[NSDate date]];
}

- (double)getDouble:(NSString *)key
{
    return [[self get:key defaultValue:@0.0] doubleValue];
}

- (float)getFloat:(NSString *)key
{
    return [[self get:key defaultValue:@0.0] floatValue];
}

- (BOOL)getBool:(NSString *)key
{
    return [[self get:key defaultValue:@NO] boolValue];
}

- (Byte)getByte:(NSString *)key
{
    return [[self get:key defaultValue:@0.0] intValue];
}

- (NSMutableDictionary *)getAttrs
{
    return _attrs;
}

- (NSArray<NSString *> *)getAttrKeys
{
    return _attrs.allKeys;
}

- (NSArray<id> *)getAttrValues
{
    return _attrs.allValues;
}
/**
 * data: NSDictionary or Model
 */
- (id<ModelProcol>)setAttrs:(const id)data
{
    NSDictionary *dict = nil;
    if ([data isKindOfClass:[Model class]]) {
        dict = [((id<ModelProcol>)data) getAttrs];
    } else if ([data isKindOfClass:[NSDictionary class]]) {
        dict = data;
    }
    [_attrs addEntriesFromDictionary:dict];
    return self;
}

- (id<ModelProcol>)remove:(const NSString *)key;//, ...
{
    for (NSString* _key in [self args:key]) {
        [_attrs removeObjectForKey:_key];
    }
    return self;
}

- (id<ModelProcol>)keep:(const NSString *)key, ...
{
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    for (NSString *_key in [self args:key]) {
        [tempDict setValue:_key forKey:[_attrs valueForKey:_key]];
    }
    return [[self clear] put:tempDict];
}

- (id<ModelProcol>)clear
{
    return [self clear:nil];
}

- (id<ModelProcol>)clear:(const NSString *)key//, ...
{
    if (nil == key) {
        return [[[self class] alloc] init];
    }
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithDictionary:_attrs];
    for (NSString *_key in [self args:key]) {
        [attrs removeObjectForKey:_key];
    }
    return [[[self class] alloc] initWithDictionary:attrs];
}

- (id<ModelProcol>)efficientAttrs
{
    NSArray<NSString *> *keys = [self getAttrKeys];
    
    for (id key in keys) {
        if([self matchSysKey:key]){
            [_attrs removeObjectForKey:key];
        }
    }
    return self;
}

#pragma mark - Db OPS

- (BOOL)save
{
    return [JFMDB saveRecord:self];
}

- (BOOL)update
{
    return [JFMDB updateRecord:self];
}

- (BOOL)del
{
    return [JFMDB deleteRecord:self];
}

- (NSArray<id<ModelProcol>> *)query
{
    return [JFMDB queryRecord:self];
}

- (NSArray<id<ModelProcol>> *)find:(NSString *)column value:(id)value
{
    [self set:column value:value];
    return [JFMDB queryRecord:self];
}

- (NSArray<id<ModelProcol>> *)find:(const NSString *)column neqValue:(id)value
{
    return [JFMDB queryRecord:self column:column neqValue:value];
}

- (NSArray<id<ModelProcol>> *)find:(const NSString *)column likeValue:(id)value
{
    return [JFMDB queryRecord:self column:column likeValue:value];
}

- (NSArray<id<ModelProcol>> *)find:(const NSString *)column orValue:(id)value
{
    return [JFMDB queryRecord:self column:column orValue:value];
}

- (NSArray<id<ModelProcol>> *)find:(const NSString *)column leValue:(id)value
{
    return [JFMDB queryRecord:self column:column leValue:value];
}

- (NSArray<id<ModelProcol>> *)find:(const NSString *)column ltValue:(id)value
{
    return [JFMDB queryRecord:self column:column ltValue:value];
}

- (NSArray<id<ModelProcol>> *)find:(const NSString *)column geValue:(id)value
{
    return [JFMDB queryRecord:self column:column geValue:value];
}

- (NSArray<id<ModelProcol>> *)find:(const NSString *)column gtValue:(id)value
{
    return [JFMDB queryRecord:self column:column gtValue:value];
}

- (NSArray<id<ModelProcol>> *)find:(const NSString *)column between:(id)between end:(id)end
{
    return [JFMDB queryRecord:self column:column between:between end:end];
}

- (NSArray<id<ModelProcol>> *)findAll
{
    return [JFMDB queryAllRecord:self];
}

+ (NSString *)primaryKey
{
    return DATA_ID;
}

+ (const NSString *)tableName
{
    return nil;
}

+ (const NSUInteger)v
{
    return 1;
}

+ (const NSString *)stmt
{
    return @"";
}

+ (NSArray<id<ModelProcol>> *)find:(const NSString *)column value:(id)value
{
    return [[[[self class] alloc] init] find:column value:value];
}

+ (NSArray<id<ModelProcol>> *)find:(const NSString *)column neqValue:(id)value
{
    return [[[[self class] alloc] init] find:column neqValue:value];
}

+ (NSArray <id<ModelProcol>> *)find:(const NSString *)column likeValue:(id)value
{
    return [[[[self class] alloc] init] find:column likeValue:value];
}

+ (NSArray <id<ModelProcol>> *)find:(const NSString *)column orValue:(id)value
{
    return [[[[self class] alloc] init] find:column orValue:value];
}

+ (NSArray <id<ModelProcol>> *)find:(const NSString *)column leValue:(id)value
{
    return [[[[self class] alloc] init] find:column leValue:value];
}

+ (NSArray <id<ModelProcol>> *)find:(const NSString *)column ltValue:(id)value
{
    return [[[[self class] alloc] init] find:column ltValue:value];
}

+ (NSArray <id<ModelProcol>> *)find:(const NSString *)column geValue:(id)value
{
    return [[[[self class] alloc] init] find:column geValue:value];
}

+ (NSArray <id<ModelProcol>> *)find:(const NSString *)column gtValue:(id)value
{
    return [[[[self class] alloc] init] find:column gtValue:value];
}

+ (NSArray<id<ModelProcol>> *)find:(const NSString *)column between:(id)between end:(id)end
{
    return [[[[self class] alloc] init] find:column between:between end:end];
}

+ (NSArray<id<ModelProcol>> *)findAll
{
    return [[[[self class] alloc] init] findAll];
}

+ (id<ModelProcol>)findById:(const NSString *)did
{
    NSArray<id<ModelProcol>> *data = [self find:[[self class] primaryKey] value:did];
    if (nil == data || [data count] == 0) {
        return [[[self class] alloc] init];
    }
    return [data objectAtIndex:0];
}

+ (BOOL)deleteById:(const NSString *)did
{
    id<ModelProcol> record = [[[self class] alloc] init];
    [record set:[[self class] primaryKey] value:did];
    return [JFMDB deleteRecord:record];
}

@end
