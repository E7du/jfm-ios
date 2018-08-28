//
//  Db.m
//  jfm
//
//  Created by Jobsz on 8/19/16.
//  Copyright © 2018 E7du. All rights reserved.
//

#import <sqlite3.h>
#import "Db.h"
#import "DbMeta.h"
#import "TableMeta.h"
#import "ColumnMeta.h"
#import "ColumnType.h"
#import "Model.h"
#import "SqlKit.h"
#import "LogKit.h"

NSString *dbExt = @".bin";

@interface Db()
{
    sqlite3 *_db;
    DbMeta *_dbMeta;
}
@end

@implementation Db

+ (Db *)share
{
    static Db *db = nil;
    static dispatch_once_t single;
    dispatch_once(&single, ^{
        db = [[self alloc] init];
    });
    return db;
}

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        _db = NULL;
    }
    return self;
}

#pragma mark - Private Logic

- (BOOL)isTableExist:(TableMeta *)table
{
    int cnt = -1;
    sqlite3_stmt *statement;
    NSString *querySql = [NSString stringWithFormat:@"SELECT count(*) cnt FROM sqlite_master WHERE `type` = 'table' AND `name` = '%@'", [table tableNameRefVersion]];
    if (sqlite3_prepare_v2(_db, [querySql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            cnt = sqlite3_column_int(statement, 0);
        }
        sqlite3_finalize(statement);
    }
    return cnt == 1;
}

- (BOOL)isTableNameExist:(NSString *)tableName
{
    int cnt = -1;
    sqlite3_stmt *statement;
    NSString *querySql = [NSString stringWithFormat:@"SELECT count(*) cnt FROM sqlite_master WHERE `type` = 'table' AND `name` = '%@'", tableName];
    if (sqlite3_prepare_v2(_db, [querySql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            cnt = sqlite3_column_int(statement, 0);
        }
        sqlite3_finalize(statement);
    }
    return cnt == 1;
}


- (BOOL)executeSql:(const NSString *)sql
{
    NSAssert(sql, @"sql Can not be nil!");
    @synchronized (self){
        char *errmsg = NULL;
        if (sqlite3_exec(_db, [sql UTF8String], NULL, NULL, &errmsg) != SQLITE_OK) {
            NSLog(@"\n😭=>Execute \"%@\" ERROR, %s\n", sql, errmsg);
            if (errmsg) sqlite3_free(errmsg);
            @throw [NSException exceptionWithName:@"SQLException" reason:[NSString stringWithFormat:@"\n😭=>Execute \"%@\" ERROR, %s\n", sql, errmsg] userInfo:nil];
            return NO;
        }
        NSLog(@"\n😋=>Execute \"%@\"\n", sql);
    }
    return YES;
}

- (NSArray *)queryTableVersionSql:(const NSString *)sql {
    NSAssert(sql, @"sql Can not be nil!");
    if (NULL == _db) {
        @throw [NSException exceptionWithName:@"RunTimeException" reason:[NSString stringWithFormat:@"Execute \"%@\" ERROR,Please Call `[JFMDB open]`, open the Db.\n", sql] userInfo:nil];
        return nil;
    }
    
    NSLog(@"\n😋=>Execute \"%@\"\n", sql);
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
           char *table_Name = (char *)sqlite3_column_text(statement, 0);
           unsigned long origin_version = sqlite3_column_int(statement, 1);
           unsigned long current_version = sqlite3_column_int(statement, 2);
           NSString *tableName = [[NSString alloc] initWithUTF8String:table_Name];
           NSInteger originVersion = origin_version;
           NSInteger currentVersion = current_version;
            if (tableName.length>0) {
                NSDictionary *dic = @{
                                      @"tableName":tableName,
                                      @"originVersion":@(originVersion),
                                      @"currentVersion":@(currentVersion),
                                      };
                [dataArray addObject:dic];
            }
        }
        sqlite3_finalize(statement);
    }
    return dataArray;
}

- (NSArray<id<ModelProcol>> *)querySql:(const NSString *)sql record:(id<ModelProcol>)record
{
    NSAssert(sql, @"sql Can not be nil!");
    NSAssert(record, @"Record Can not be nil!");
    
    if (NULL == _db) {
        @throw [NSException exceptionWithName:@"RunTimeException" reason:[NSString stringWithFormat:@"Execute \"%@\" ERROR,Please Call `[JFMDB open]`, open the Db.\n", sql] userInfo:nil];
        return nil;
    }
    
    NSLog(@"\n😋=>Execute \"%@\"\n", sql);
    
    NSMutableArray *datas = [NSMutableArray array];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int cnt = sqlite3_column_count(statement);
            id<ModelProcol> data = [[[record class] alloc] init];
            for (int idx = 0; idx < cnt; idx++) {
                int type = sqlite3_column_type(statement, idx);
                const char *col = sqlite3_column_name(statement, idx);
                NSString *columnName = [NSString stringWithUTF8String:col];
                switch (type) {
                    case SQLITE_INTEGER: {
                        sqlite3_int64 val = sqlite3_column_int64(statement, idx);
                        [data set:columnName value:[NSNumber numberWithInteger:val]];
                    }
                        break;
                        
                    case SQLITE_FLOAT: {
                        double val = sqlite3_column_double(statement, idx);
                        [data set:columnName value:[NSNumber numberWithDouble:val]];
                    }
                        break;
                        
                    case SQLITE_TEXT: {
                        const unsigned char *val = sqlite3_column_text(statement, idx);
                        [data set:columnName value:[NSString stringWithUTF8String:(const char*)val]];
                    }
                        break;
                        
                        //                    case SQLITE_BLOB: {
                        //                    }
                        //                        break;
                }
            }
            [datas addObject:data];
        }
        sqlite3_finalize(statement);
    }
    datas = (NSMutableArray *)[[datas reverseObjectEnumerator] allObjects];
    return [NSArray arrayWithArray:datas];
}

#pragma mark - Public Logic

- (void)dbExt:(NSString *)ext
{
    NSMutableString *_ext = [NSMutableString string];
    if (![ext hasPrefix:@"."]) {
        [_ext appendString:@"."];
    }
    [_ext appendString:ext];
    dbExt = _ext;
}

- (BOOL)open:(DbMeta *)dbMeta
{
    _dbMeta = dbMeta;
    if (sqlite3_open([[self dbPath] UTF8String], &_db) != SQLITE_OK) {
        sqlite3_close(_db);
        return NO;
    }
    return [self createTables];
}

- (NSString *)dbPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    return [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",_dbMeta.name, dbExt]];
}

- (BOOL)createTables
{
    if (NULL == _db) {
        @throw [NSException exceptionWithName:@"RunTimeException" reason:[NSString stringWithFormat:@"CREATE TABLE ERROR,Please Call `[JFMDB open]`, open the Db.\n"] userInfo:nil];
        return NO;
    }
   
    if (![self isTableNameExist:@"table_version"]) {
        NSString *sql = @"CREATE TABLE \"table_version\" (\"table_name\" TEXT NOT NULL DEFAULT \"\",\"origin_version\" INTEGER NOT NULL DEFAULT 0,\"current_version\"INTEGER NOT NULL DEFAULT 0 ,PRIMARY KEY(\"table_name\"))";
       [self transaction:^{
            [self executeSql:sql];
        }];
    }

    BOOL ret = YES;
    for (TableMeta *table in _dbMeta.tables) {
        if ([self isTableExist:table]) {
             NSLog(@"\n😋=>Table \"%@\" Existed. Nothing Chanaged!\n", [table tableNameRefVersion]);
            continue;
        }
        
        Class clazz = NSClassFromString(table.name);
        NSLog(@"😁😁😁😁%@",[clazz stmt]);
        if (clazz) {
            ret = [self transaction:^{
                [self executeSql:[clazz stmt]];
            }];
            if (ret) {
                NSLog(@"\n😋=>Table \"%@\" Created!\n", [table tableNameRefVersion]);
            } else {
                NSLog(@"\n😭=>Table \"%@\" Create Error!\n", [table tableNameRefVersion]);
                break;
            }
        }
     
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM table_version WHERE table_name = '%@'",table.name];
        NSArray *qArray = [self queryTableVersionSql:querySql];
        if (qArray.count>0) {
            NSDictionary *dic = [qArray objectAtIndex:0];
            NSString *updateSql = [NSString stringWithFormat:@"UPDATE table_version SET origin_version = %lu,current_version = %lu WHERE table_name = '%@'",[dic[@"currentVersion"] integerValue],table.v,table.name];
            [self executeSql:updateSql];
        }else {
             NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO table_version(table_name, origin_version, current_version) VALUES('%@', '%d', '%lu')",table.name,0,table.v];
            [self executeSql:insertSql];
        }
        //---------------------------------
        
    }
    
    return ret;
}

- (BOOL)transaction:(void(^)(void))tx
{
    BOOL ret = YES;
    @try {
        @synchronized (self) {
            [self beginTransaction];
            tx();
            [self commitTransaction];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"\n---RunTx Exception---\n Info:%@", exception);
        [self rollbackTransaction];
        ret = NO;
    }
    @finally {
        ;
    }
    return ret;
}

- (BOOL)beginTransaction
{
    return [self executeSql:@"BEGIN"];
}

- (BOOL)commitTransaction
{
    return [self executeSql:@"COMMIT"];
}

- (BOOL)rollbackTransaction
{
    return [self executeSql:@"ROLLBACK"];
}

- (BOOL)saveRecord:(id<ModelProcol>)record
{
    return [self executeSql:[SqlKit saveSql:record]];
}

- (BOOL)updateRecord:(id<ModelProcol>)record
{
    return [self executeSql:[SqlKit updateSql:record]];
}

- (BOOL)deleteRecord:(id<ModelProcol>)record
{
    return [self executeSql:[SqlKit deleteSql:record]];
}

- (NSArray<id<ModelProcol>> *)queryRecord:(id<ModelProcol>)record
{
    return [self querySql:[SqlKit querySql:record] record:record];
}

- (NSArray<id<ModelProcol>> *)queryRecord:(id<ModelProcol>)record column:(const NSString *)column likeValue:(id)val
{
    return [self querySql:[SqlKit querySql:record column:column likeValue:val] record:record];
}

- (NSArray<id<ModelProcol>> *)queryRecord:(id<ModelProcol>)record column:(const NSString *)column orValue:(id)val
{
    return [self querySql:[SqlKit querySql:record column:column orValue:val] record:record];
}

- (NSArray<id<ModelProcol>> *)queryRecord:(id<ModelProcol>)record column:(const NSString *)column neqValue:(id)val
{
    return [self querySql:[SqlKit querySql:record column:column neqValue:val] record:record];
}

- (NSArray<id<ModelProcol>> *)queryRecord:(id<ModelProcol>)record column:(const NSString *)column leValue:(id)val
{
    return [self querySql:[SqlKit querySql:record column:column leValue:val] record:record];
}

- (NSArray<id<ModelProcol>> *)queryRecord:(id<ModelProcol>)record column:(const NSString *)column ltValue:(id)val
{
    return [self querySql:[SqlKit querySql:record column:column ltValue:val] record:record];
}

- (NSArray<id<ModelProcol>> *)queryRecord:(id<ModelProcol>)record column:(const NSString *)column geValue:(id)val
{
    return [self querySql:[SqlKit querySql:record column:column geValue:val] record:record];
}

- (NSArray<id<ModelProcol>> *)queryRecord:(id<ModelProcol>)record column:(const NSString *)column gtValue:(id)val
{
    return [self querySql:[SqlKit querySql:record column:column gtValue:val] record:record];
}

- (NSArray<id<ModelProcol>> *)queryRecord:(id<ModelProcol>)record column:(const NSString *)column between:(id)between end:(id)end
{
    return [self querySql:[SqlKit querySql:record column:column between:between end:end] record:record];
}

- (NSArray<id<ModelProcol>> *)queryAllRecord:(id<ModelProcol>)record
{
    return [self querySql:[SqlKit queryAllSql:record] record:record];
}

- (void)migration
{
    for (NSInteger i = 0; i < _dbMeta.tables.count; i++) {
        TableMeta *table = _dbMeta.tables[i];
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM `table_version` WHERE `table_name` = '%@'",table.name];
        NSArray *queryArray = [self queryTableVersionSql:querySql];
        if (queryArray.count > 0) {
            NSDictionary *dic = queryArray[0];
            NSInteger ov = [dic[@"originVersion"] integerValue];
            if (ov == 0 || ov == table.v) {
                continue;
            }
            //版本不一致迁移
            NSString *originTableName = [NSString stringWithFormat:@"%@_%@",table.name,dic[@"originVersion"]];
            NSString *qtcnSql = [NSString stringWithFormat:@"PRAGMA table_info(%@)",originTableName];
            NSArray *originColumnNameArray = [self queryTableColumnNameSql:qtcnSql];
            NSArray *array = [self queryArrayIntersection:table.columns andArray:originColumnNameArray];
           // NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@(",table.tableNameRefVersion];
           // NSString *selectSql =  [NSString stringWithFormat:@"SELECT "];
            NSString *columnSql = nil;
            for (NSInteger i = 0; i < array.count; i++) {
                ColumnMeta *column = array[i];
                if (i == array.count - 1) {
                    columnSql = [NSString stringWithFormat:@"%@%@",columnSql,column.name];
                   // insertSql = [NSString stringWithFormat:@"%@%@)",insertSql,column.name];
                    //selectSql = [NSString stringWithFormat:@"%@%@ FROM %@",selectSql,column.name,originTableName];
                } else {
                    columnSql = [NSString stringWithFormat:@"%@%@,",columnSql,column.name];
                    //insertSql = [NSString stringWithFormat:@"%@%@,",insertSql,column.name];
                    //selectSql = [NSString stringWithFormat:@"%@%@,",selectSql,column.name];
                }
            }
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) SELECT %@ FROM %@",table.tableNameRefVersion,columnSql,columnSql,originTableName];
           // NSString *sql = [NSString stringWithFormat:@"%@ %@",insertSql,selectSql];
            BOOL ret = [self executeSql:sql];
            if (ret) {
                NSString *updateSql = [NSString stringWithFormat:@"UPDATE `table_version` SET `origin_version` = '%lu',`current_version` = '%lu' WHERE `table_name` = '%@'",table.v,table.v,table.name];
                [self executeSql:updateSql];
                
                //在此删除旧表
                NSString* deleteSQL = [NSString stringWithFormat:@"DROP TABLE `%@`;",originTableName];
                [self executeSql:deleteSQL];
            }
        }
    }

}

- (NSArray *)queryArrayIntersection:(NSArray *)arrayA andArray:(NSArray *)arrayB
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0;i < arrayA.count;i++){
        ColumnMeta *columnA = arrayA[i];
        for (int i = 0; i < arrayB.count; i++) {
            NSString *nameB = arrayB[i];
            if ([columnA.name isEqualToString:nameB]) {
                [array addObject:columnA];
            }
        }
    }
    return array;
}

- (NSArray *)queryTableColumnNameSql:(const NSString *)sql
{
    NSAssert(sql, @"sql Can not be nil!");
    if (NULL == _db) {
        @throw [NSException exceptionWithName:@"RunTimeException" reason:[NSString stringWithFormat:@"Execute \"%@\" ERROR,Please Call `[JFMDB open]`, open the Db.\n", sql] userInfo:nil];
        return nil;
    }
    
    NSLog(@"\n😋=>Execute \"%@\"\n", sql);
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *nameData = (char *)sqlite3_column_text(statement, 1);
            NSString *columnName = [[NSString alloc] initWithUTF8String:nameData];
            NSLog(@"columnName:%@",columnName);
            [dataArray addObject:columnName];
        }
        sqlite3_finalize(statement);
    }
    return dataArray;
}

- (BOOL)close
{
    if (_db) {
        sqlite3_close(_db);
    }
    return YES;
}

@end
