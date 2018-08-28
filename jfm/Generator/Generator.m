//
//  Generator.m
//  jfm
//
//  Created by Jobsz on 8/18/16.
//  Copyright © 2018 E7du. All rights reserved.
//

#import "Generator.h"
#import "CodeTemplate.h"
#import "DbMeta.h"
#import "TableMeta.h"
#import "ColumnMeta.h"
#import "ColumnType.h"
#import "LogKit.h"

@implementation Generator

+ (BOOL)generatorModel:(DbMeta *)db path:(NSString *)path
{
    NSMutableString *_path = [NSMutableString stringWithString:path];
    if (![path hasSuffix:@"/"]) {
        [_path appendString:@"/"];
    }
	
    [[NSFileManager defaultManager] createDirectoryAtPath:_path withIntermediateDirectories:YES attributes:nil error:nil];
    
    for (TableMeta *table in db.tables) {
        //table.v = db.v;
        [self generatorTableModel:table path:_path];
        NSLog(@"\n😋=>TableModel \"%@\" Generated!\n", table.name);
    }
    return YES;
}

+ (BOOL)generatorTableModel:(TableMeta *)table path:(NSString *)path
{
    NSString *_path = [NSString stringWithFormat:@"%@%@", path, table.name];
    return [self generatorTableModelHeader:table path:_path] && [self generatorTableModelImplementation:table path:_path];
}

+ (BOOL)generatorTableModelHeader:(TableMeta *)table path:(NSString *)path
{
    NSLog(@"\n😋=>Generating TableModel \"%@\" 's Header!\n", table.name);
    NSMutableString *headerCode = [NSMutableString string];
    [headerCode appendString:[CodeTemplate comment]];
    [headerCode appendString:[CodeTemplate headerImport]];
    //property Extern Const
    for (ColumnMeta *column in table.columns) {
        [headerCode appendString:[CodeTemplate propertyExternConst:column.name model:table.name]];
    }
    [headerCode appendString:[CodeTemplate tableExternConst:table.name]];
    [headerCode appendString:[CodeTemplate interface:table.name]];
    //property
    for (ColumnMeta *column in table.columns) {
        [headerCode appendString:[CodeTemplate property:column.name type:column.type]];
    }
    [headerCode appendString:[CodeTemplate end]];
    return [self generatorWithContent:headerCode path:[path header]];
}

+ (BOOL)generatorTableModelImplementation:(TableMeta *)table path:(NSString *)path
{
    NSLog(@"\n😋=>Generating TableModel \"%@\" 's Implementation!\n", table.name);
    NSMutableString *implementCode = [NSMutableString string];
    [implementCode appendString:[CodeTemplate comment]];
    [implementCode appendString:[CodeTemplate implementationImport:table.name]];
    //property Const
    for (ColumnMeta *column in table.columns) {
        [implementCode appendString:[CodeTemplate propertyConst:column.name model:table.name]];
    }
    [implementCode appendString:[CodeTemplate tableConst:table.name version:table.v]];
    //private category
    [implementCode appendString:[CodeTemplate privateInterfaceCategory:table.name]];
    [implementCode appendString:@"{\n"];
    //property Const
    for (ColumnMeta *column in table.columns) {
        [implementCode appendString:[CodeTemplate privateInterfaceCategoryProperty:column.name type:column.type]];
    }
    [implementCode appendString:@"}\n"];
    [implementCode appendString:[CodeTemplate end]];
    [implementCode appendString:[CodeTemplate implementation:table.name]];
    //getter setter
    for (ColumnMeta *column in table.columns) {
        [implementCode appendString:[CodeTemplate setter:column.name type:column.type]];
        [implementCode appendString:[CodeTemplate getter:column.name type:column.type defaultVal:column.defaultValue]];
    }
    
    //primaryKey
    ColumnMeta *primaryKeyColumn = nil;
    if (nil == (primaryKeyColumn = table.primaryKey)) {
        @throw [NSException exceptionWithName:@"IllegalArgumentException" reason:[NSString stringWithFormat:@"%@'s PrimaryKey property Not Found!.", table.name] userInfo:nil];
    }
    
    [implementCode appendString:[CodeTemplate primaryKey:[primaryKeyColumn.name lowercaseString]]];
    [implementCode appendString:[CodeTemplate tableName:table.name]];
    [implementCode appendString:[CodeTemplate version:table.v]];
    [implementCode appendString:[CodeTemplate stmt:[self stmt:table]]];
    [implementCode appendString:[CodeTemplate end]];
    return [self generatorWithContent:implementCode path:[path source]];
}

+ (NSString *)stmt:(TableMeta *)table
{
    NSLog(@"\n😋=>Generating TableModel \"%@\" 's stmt!\n", table.name);
    NSMutableString *stmt = [NSMutableString stringWithFormat:@"CREATE TABLE \\\"%@\\\" (", [table tableNameRefVersion]];
    for (ColumnMeta *column in table.columns) {
        id defaultVal = column.defaultValue;
        defaultVal = defaultVal == nil ? [ColumnType defaultValueForObjcType:column.type]:defaultVal;
        [stmt appendFormat:@"\\\"%@\\\" %@ NOT NULL DEFAULT %@,", column.name, [ColumnType sqliteType:column.type], defaultVal];
    }
    ColumnMeta *primaryKeyColumn = nil;
    if (nil == (primaryKeyColumn = table.primaryKey)) {
        @throw [NSException exceptionWithName:@"IllegalArgumentException" reason:[NSString stringWithFormat:@"%@'s PrimaryKey property Not Found!.", table.name] userInfo:nil];
    }
    
    NSString *primaryKey = [NSString stringWithFormat:@"PRIMARY KEY(\\\"%@\\\" AUTOINCREMENT)", primaryKeyColumn.name];
    [stmt appendFormat:@"%@)", primaryKey];
    return stmt;
}

+ (BOOL)generatorWithContent:(NSString *)content path:(NSString *)path
{
    NSMutableData *writer = [[NSMutableData alloc] init];
    [writer appendData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    return [writer writeToFile:path atomically:YES];
}

@end
