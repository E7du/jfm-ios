# jfm-ios
jfm-ios: Just Fast Model For iOS, Reference `jfm` move to ios platform


### DB(Sqlite)操作
-	数据库创建

```objective-c
- (DbMeta *)db
{
    DbMeta *db = [[DbMeta alloc] init];
    
    db.name = @"jfm_demo_db";
    db.v = 1129;
    
    NSMutableArray *tables = [NSMutableArray array];
    
    for (int i = 0; i < 3; i++) {
        TableMeta *table = [TableMeta tableWithName:[NSString stringWithFormat:@"zcq%d",i]];
        NSMutableArray *columns = [NSMutableArray array];
        for (int j = 0; j < 4; j++) {
            NSString *name = [NSString stringWithFormat:@"columnNN%i",j];
            NSString *type = nil;
            if (j % 2) {
                type = [ColumnType objcReal];
            } else {
                type = [ColumnType objcText];
            }
            [columns addObject:[ColumnMeta columnWithName:name type:type]];
        }
        [columns addObject:[ColumnMeta columnWithName:@"addr" type:[ColumnType objcText]]];
        table.primaryKey = [ColumnMeta primaryKeyWithName:@"did"];
        table.columns = [NSArray arrayWithArray:columns];
        
        [tables addObject:table];
    }
    
    db.tables = [NSArray arrayWithArray:tables];
    return db;
}
```

- 生成 Model

```objective-c
NSString *companyMac = @"/Users/congqizhu/Projects/jfm/";
    [Generator generatorModel:[self db] path:[NSString stringWithFormat:@"%@jfmTests/Model", companyMac]];
```
- 数据库操作

```objective-c
 [JFMDB dbExt:@"sqlite"];
    
    BOOL ret = [JFMDB open:[self db]];
    
    NSAssert(ret == YES, @"ok");
    
    NSLog(@"path %@", [JFMDB dbPath]);
    
    [JFMDB createTables];
    
    for (int idx = 0; idx < 100; idx++) {
        zcq0 *z = [[zcq0 alloc] init];
        z.columnnn0 = [NSString stringWithFormat:@"zcq%d",idx];
        z.columnnn1 = 10.1 + idx;
        //[z save];
        [JFMDB saveRecord:z];
    }
    
    zcq0 *zz= [zcq0 new];
    zz.columnnn0 = @"zcq0";
    
    NSArray *datas = [JFMDB queryRecord:zz column:ZCQ0_COLUMNNN1 likeValue:@"11.1"];//[JFMDB queryRecord:zz column:ZCQ0_COLUMNNN1 between:@"10.1" end:@"15.1"];
    //findall use class 
    //datas = [zcq0 findAll];
    //findAll use class's instance
    //datas = [zz findALl]

    NSLog(@"datas %@", datas);
```
- 数据事务操作

```objective-c
[JFMDB transaction:^{
    zcq0 *z = [[zcq0 alloc] init];
    z.columnnn0 = @"zcq";
    z.columnnn1 = 10.1;
    z.did = 123;
    [JFMDB saveRecord:z];
    z.columnnn0 = @"zzzzzz";
    [JFMDB updateRecord:z];
    [JFMDB deleteRecord:z];
    [zcq0 deleteById:@"123"];
}];
```

### Features:

- 透明操作 Cache(TODO) 和 DB（sqlite）
- 自动生成 Model
- 数据升级迁移(TODO)
