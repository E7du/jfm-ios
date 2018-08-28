//
//  DbMeta.m
//  jfm
//
//  Created by Jobsz on 8/18/16.
//  Copyright © 2018 E7du. All rights reserved.
//

#import "DbMeta.h"
#import "TableMeta.h"

@implementation DbMeta

#pragma mark - Init

+ (DbMeta *)dbWithName:(NSString *)name version:(NSUInteger)version tables:(NSArray<TableMeta *> *)tables
{
    DbMeta *db = [[DbMeta alloc] init];
    db.name = name;
    db.v = version;
    db.tables = tables;
    return db;
}

#pragma mark - Accesser : sync version between tables and db

- (void)setV:(NSUInteger)v
{
    _v = v;
    if (0 == _v) {
        @throw [NSException exceptionWithName:@"IllegalArgumentException" reason:@"Db Version cannot set `0`." userInfo:nil];
        return;
    }
}

- (void)setTables:(NSArray<TableMeta *> *)tables
{
    if (0 == _v) {
        @throw [NSException exceptionWithName:@"IllegalArgumentException" reason:@"Db Version cannot set `0`." userInfo:nil];
        return;
    }
    // auto sync version to table
//    for (TableMeta *table in tables) {
//        table.v = _v;
//    }
    _tables = tables;
}

@end
