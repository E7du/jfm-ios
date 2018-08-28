//
//  TableMeta.m
//  jfm
//
//  Created by Jobsz on 8/18/16.
//  Copyright © 2018 E7du. All rights reserved.
//

#import "TableMeta.h"

@implementation TableMeta

#pragma mark - Init

- (instancetype)initWithName:(NSString *)name primaryKey:(ColumnMeta *)primaryKey columns:(NSArray *)columns
{
    self = [super init];
    if (self) {
        self.name = name;
        self.primaryKey = primaryKey;
        self.columns = columns;
    }
    return self;
}

- (void)setV:(NSUInteger)v
{
    _v = v;
    if (0 == _v) {
        @throw [NSException exceptionWithName:@"IllegalArgumentException" reason:@"table Version cannot set `0`." userInfo:nil];
        return;
    }
}


#pragma mark - Accesser

- (void)setPrimaryKey:(ColumnMeta *)primaryKey
{
    _primaryKey = primaryKey;
    if (nil != self.columns && ![self.columns containsObject:_primaryKey]) {
        NSMutableArray *cols = [NSMutableArray arrayWithArray:self.columns];
        [cols addObject:_primaryKey];
        self.columns = cols;
    }
}

- (void)setColumns:(NSArray<ColumnMeta *> *)columns
{
    _columns = columns;
    
    if (![_columns containsObject:self.primaryKey] && nil != self.primaryKey) {
        NSMutableArray *cols = [NSMutableArray arrayWithArray:_columns];
        [cols addObject:self.primaryKey];
        _columns = cols;
    }
}

#pragma mark - Public Logic

- (NSString *)tableNameRefVersion
{
    return [NSString stringWithFormat:@"%@_%@", self.name, [NSNumber numberWithUnsignedInteger:self.v]];
}

+ (TableMeta *)tableWithName:(NSString *)name
{
    return [[self alloc] initWithName:name primaryKey:nil columns:nil];
}

+ (TableMeta *)tableWithName:(NSString *)name primaryKey:(ColumnMeta *)primaryKey
{
    return [[self alloc] initWithName:name primaryKey:primaryKey columns:nil];
}

+ (TableMeta *)tableWithName:(NSString *)name primaryKey:(ColumnMeta *)primaryKey columns:(NSArray *)columns
{
    return [[self alloc] initWithName:name primaryKey:primaryKey columns:columns];
}

@end
