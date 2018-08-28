//
//  jfmTests.m
//  jfmTests
//
//  Created by Jobsz on 8/17/16.
//  Copyright © 2018 E7du. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "jfm.h"
#import "SubModel.h"

#import "MatchInfo.h"

@interface NSString(cc)
-(NSString*) camelCaseString;
@end

@implementation NSString(cc)

-(NSString*) camelCaseString
{
    //调用NSString的内部方法获取驼峰字符串。
    //self指向被添加分类的类。
    NSString *castr = [self capitalizedString];
    
    //创建数组来过滤掉空格, 通过分隔符对字符进行组合。
    NSArray *array = [castr componentsSeparatedByCharactersInSet:
                      [NSCharacterSet whitespaceCharacterSet]];
    
    //把数组的字符输出
    NSString *output = @"";
    for(NSString *word in array)
    {
        output = [output stringByAppendingString:word];
    }
    
    return output;
    
}

@end

@interface jfmTests : XCTestCase
{
    SubModel *_model;
}
@end

@implementation jfmTests

- (void)setUp {
    [super setUp];
	_model = [[SubModel alloc] init];
}

- (void)testModel
{
	[_model put:@"name" value:@"Jobsz"];
	[_model set:@"addr" value:@"北京"];
	
	[_model clear:@"addr"];
    
    [_model clear];
    
    [_model setName:@"Jobsz"];
    _model.name = @"asdas";
    [_model setAge:12];
    [_model setIcon:@"icon"];
    
    SubModel* __model = [_model clear:@"age"];
    
    [_model setIcon:nil];
    
	NSLog(@"put Data_model %@ \n__model %@\n efficientAttrs %@", _model, __model, [__model efficientAttrs]);
    
    SubModel *subModel = [[SubModel alloc] initWithDictionary:@{@"name":@"Jobsz",@"addr":@"BeijIng"}];
    
    NSLog(@"submodel %@",subModel);
}


- (DbMeta *)db
{
    DbMeta *db = [[DbMeta alloc] init];
    
    db.name = @"jfm_demo_db";
    db.v = 1;
    
    NSMutableArray *tables = [NSMutableArray array];
    
//    for (int i = 0; i < 3; i++) {
//        TableMeta *table = [TableMeta tableWithName:[NSString stringWithFormat:@"zcq%d",i]];
//        table.v = 2;
//        NSMutableArray *columns = [NSMutableArray array];
//        for (int j = 0; j < 4; j++) {
//            NSString *name = [NSString stringWithFormat:@"columnnn%i",j];
//            NSString *type = nil;
//            id defval = nil;
//            if (j % 2) {
//                type = [ColumnType objcReal];
//                defval = @10.0;
//            } else {
//                type = [ColumnType objcText];
//                defval = @"defValasdfadsfads";
//            }
//            [columns addObject:[ColumnMeta columnWithName:name type:type defaultVal:defval]];
//        }
//        [columns addObject:[ColumnMeta columnWithName:@"addr" type:[ColumnType objcText] defaultVal:@"addr"]];
//        table.primaryKey = [ColumnMeta primaryKeyWithName:@"did"];
//        table.columns = [NSArray arrayWithArray:columns];
//        
//        [tables addObject:table];
//    }
    
    [tables addObject:[self matchInfoTable]];
    db.tables = [NSArray arrayWithArray:tables];
    return db;
}

//- (void)testNewSave
//{
//    zcq0 *zcq = [[zcq0 alloc] init];
//    zcq.columnnn0 = @"col0";
//    
//    [JFMDB dbExt:@"sqlite"];
//    [JFMDB open:[self db]];
//    
//    
//    NSLog(@"path %@", [JFMDB dbPath]);
//    
//    [JFMDB transaction:^{
//        for (int i = 0; i < 100; i++)
//        [zcq save];
//    }];
//    
//    [JFMDB close];
//}

- (TableMeta *)matchInfoTable {
    TableMeta *matchInfoTable = [TableMeta tableWithName:@"MatchInfo"];
    matchInfoTable.v = 1;
    NSMutableArray *columns = [NSMutableArray array];
    matchInfoTable.primaryKey = [ColumnMeta primaryKeyWithName:@"noid"];
    [columns addObject:[ColumnMeta columnWithName:@"matchid" type:[ColumnType objcText]]];
    [columns addObject:[ColumnMeta columnWithName:@"userid" type:[ColumnType objcText]]];
    [columns addObject:[ColumnMeta columnWithName:@"homecolor" type:[ColumnType objcText]]];
    [columns addObject:[ColumnMeta columnWithName:@"homescore" type:[ColumnType objcInteger]]];
    [columns addObject:[ColumnMeta columnWithName:@"guestcolor" type:[ColumnType objcText]]];
    [columns addObject:[ColumnMeta columnWithName:@"guestscore" type:[ColumnType objcInteger]]];
    [columns addObject:[ColumnMeta columnWithName:@"status" type:[ColumnType objcInteger]]];
    [columns addObject:[ColumnMeta columnWithName:@"stage" type:[ColumnType objcInteger]]];
    [columns addObject:[ColumnMeta columnWithName:@"min" type:[ColumnType objcInteger]]];
    [columns addObject:[ColumnMeta columnWithName:@"sec" type:[ColumnType objcInteger]]];
    [columns addObject:[ColumnMeta columnWithName:@"homepausecount" type:[ColumnType objcInteger]]];
    [columns addObject:[ColumnMeta columnWithName:@"guestpausecount" type:[ColumnType objcInteger]]];
    [columns addObject:[ColumnMeta columnWithName:@"homefoulcount" type:[ColumnType objcInteger]]];
    [columns addObject:[ColumnMeta columnWithName:@"guestfoulcount" type:[ColumnType objcInteger]]];
    [columns addObject:[ColumnMeta columnWithName:@"bhomeballctrl" type:[ColumnType objcInteger]]];
    matchInfoTable.columns = [NSArray arrayWithArray:columns];
    return matchInfoTable;
}


- (void)testGeneratorModel
{
	//NSString *homeMac = @"/Users/Jobsz/Projects/E7du/justfastmodel/jfm/";
	NSString *companyMac = @"/Users/kuang/Desktop/jfm-ios/jfmTests/Model";
   // NSString *zcqDir = @"/Users/Jobsz/Projects/E7du_ios_withball3.x/jfm/jfmTests/Model";
    [Generator generatorModel:[self db] path:companyMac];
    
}

- (void)testMkdir
{
    NSString *dir = @"/Users/Jobsz/Desktop/E7du_ios_withball3.x/jfm/jfmTests/Model//";
    
    [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];

}

- (void)testDB
{
    [JFMDB dbExt:@"sqlite"];
    
    BOOL ret = [JFMDB open:[self db]];
    
    NSAssert(ret == YES, @"ok");
    
    
    
    NSLog(@"path %@", [JFMDB dbPath]);
    
  //  [JFMDB createTables];
    
//    for (int idx = 0; idx < 100; idx++) {
//        zcq0 *z = [[zcq0 alloc] init];
//        z.columnnn0 = [NSString stringWithFormat:@"zcq%d",idx];
//        z.columnnn1 = 10.1 + idx;
//        
//        [JFMDB saveRecord:z];
//    }
  
    
    //[[NSRunLoop mainRunLoop] run];
}

- (void)testSqlkit
{
    MatchInfo *m = [[MatchInfo alloc] init];
    m.userid = @"12233";
    m.matchid = @"12";
    [m clear:MATCHINFO_USERID];
    
    
    
    [m remove:MATCHINFO_USERID];
    
}

- (NSArray *)args:(const NSString *)key, ...
{
    if (nil == key) {
        return [NSArray array];
    }
    
    NSMutableArray *args = [NSMutableArray array];
    va_list params;
    va_start(params, key);
    id arg = nil;
    if (key) {
        id prev = key;
        [args addObject:prev];
        while(nil != (arg = va_arg(params, id))) {
            if (arg) {
                [args addObject:arg];
            }
        }
        va_end(params);
    }
    return args;
}


- (void)testSqlKit1
{
    [JFMDB dbExt:@"sqlite"];
    
    [JFMDB open:[self db]];
    
    //DbMigration *dbM = [DbMigration managerWithDatabase:[self db]dbPath:JFMDB.dbPath];
    
    NSLog(@"path %@", [JFMDB dbPath]);
    
    [JFMDB close];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
