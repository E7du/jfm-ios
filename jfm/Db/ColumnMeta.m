//
//  ColumnMeta.m
//  jfm
//
//  Created by Jobsz on 8/18/16.
//  Copyright © 2018 E7du. All rights reserved.
//

#import "ColumnMeta.h"
#import "ColumnType.h"

@implementation ColumnMeta

#pragma mark - Init

- (instancetype)initWithName:(NSString *)name type:(NSString *)type defaultVal:(id)defaultVal
{
    self = [super init];
    if (self) {
        self.name = name;
        self.type = type;
        self.defaultValue = defaultVal;
    }
    return self;
}

#pragma mark - Public

+ (ColumnMeta *)columnWithName:(NSString *)name type:(NSString *)type
{
    return [[self alloc] initWithName:name type:type defaultVal:[ColumnType defaultValueForObjcType:type]];
}

+ (ColumnMeta *)columnWithName:(NSString *)name type:(NSString *)type defaultVal:(id)defaultVal
{
    return [[self alloc] initWithName:name type:type defaultVal:defaultVal];
}

+ (ColumnMeta *)primaryKeyWithName:(NSString *)name
{
    return [[self alloc] initWithName:name type:[ColumnType objcUinteger] defaultVal:@0];
}

@end
