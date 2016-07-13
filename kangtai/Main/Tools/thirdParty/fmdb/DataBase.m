
#import "DataBase.h"
@implementation DataBase

static DataBase * _db = nil;

static FMDatabase * database = nil;

+ (DataBase *)shareInstance{
    
    @synchronized(self){
        
        if (!_db) {
            
            _db = [[DataBase alloc]init];
            
            [self openDataBase];
//
            [self createTable];
        }
    }
    
    return _db;
}

+ (NSString *)getPath
{
    NSArray *documentPath =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [documentPath objectAtIndex:0];
    NSString *myPath = [path stringByAppendingPathComponent:@"myTest.sqlite"];
    
    return myPath;
}

+ (void)openDataBase
{
    if (database) {
        
        return;
    }
    database = [FMDatabase databaseWithPath:[self getPath]];
    if (![database open]) {
//        NSLog(@"open cancel打开失败");
        return;
    }else{
//        NSLog(@"open OK 成功");
    }
    // 为数据库设置缓存,提高查询效率
    database.shouldCacheStatements = YES;

    
}
#pragma mark - 关闭数据库操作
+ (void)closeDataBase{
    
    if (![database close]) {
//        NSLog(@"关闭数据库失败");
        return;
    }
    
    database = nil;
//    NSLog(@"关闭数据库成功");
    
}

#pragma mark - 管理创建表的操作
+ (void)createTable//Name:(NSString *)userTable
{
    
    [self openDataBase];
    
    // 判断表是否存在,不存在就创建------ tableExists
    if (![database tableExists:@"DataTable"]) {
        
        [database executeUpdate:@"CREATE TABLE DataTable(id INTEGER PRIMARY KEY AUTOINCREMENT,MAC TEXT, name TEXT, logo TEXT,companyCode TEXT,deviceType TEXT,authCode TEXT,orderNumber INTEGER,username TEXT)"];
        
        NSLog(@"创建表成功");
    }
    
    [self closeDataBase];
}
#pragma mark - 增加数据操作----- executeUpdate
+ (void)insertIntoDataBase:(Device *)model
{
    
    [self openDataBase];
    
    NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_USERMODEL];

    [database executeUpdate:@" INSERT INTO DataTable (MAC,name,logo,companyCode,deviceType,authCode,orderNumber,username) VALUES (?,?,?,?,?,?,?,?)",model.macString,model.name,model.image,model.codeString,model.deviceType,model.authCodeString,[NSNumber numberWithInt:(int)model.orderNumber],userName];
    
    [self closeDataBase];
}



//修改图片
+ (void)updataToDataBaseWithimageName:(NSString *)imageName where:(NSString *)mac {
    
    [self openDataBase];
    NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_USERMODEL];
    
    [database executeUpdate:@"UPDATE DataTable SET logo =? WHERE username =? AND MAC =?",imageName,userName,mac];
    [self closeDataBase];
    
}


//修改名称
+ (void)updataName:(NSString *)Name where:(NSString *)mac
{
    
    [self openDataBase];
    NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_USERMODEL];
    
    [database executeUpdate:@"UPDATE DataTable SET name =? WHERE username =? AND MAC =?",Name,userName,mac];
    [self closeDataBase];
    
}




#pragma mark - 删除数据操作----- executeUpdate
+ (void)deleteDataFromDataBase:(Device *)model
{
    
    [self openDataBase];
    
    
    [database executeUpdate:[NSString stringWithFormat:@" DELETE FROM DataTable WHERE id = '%@'",model.deviceId] ];
    
    [self closeDataBase];
}

//通过mac地址删除设备
+ (void)deleteDataWithMacString:(Device *)model
{
    
    [self openDataBase];
    NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_USERMODEL];

    
    [database executeUpdate:@" DELETE FROM DataTable WHERE username=? AND MAC =?",userName,model.macString] ;
    
    [self closeDataBase];
}


+ (NSMutableArray *)selectDataFromDataBaseWithId:(NSString *)deviceId {
    
    [self openDataBase];
    
    FMResultSet * resultSet = [database executeQuery:[NSString stringWithFormat:@"SELECT * FROM DataTable WHERE id IN ('%@')",deviceId]];
    
    NSMutableArray *murableArray = [[NSMutableArray alloc] initWithCapacity:0];
    while ([resultSet next]) {
        Device *model = [[Device alloc] init];
        model.deviceId = [resultSet stringForColumn:@"id"];
        model.macString = [resultSet stringForColumn:@"MAC"];
        model.name = [resultSet stringForColumn:@"name"];
        model.image = [resultSet stringForColumn:@"logo"];
        
        model.codeString = [resultSet stringForColumn:@"companyCode"];
        model.deviceType = [resultSet stringForColumn:@"deviceType"];
        model.authCodeString = [resultSet stringForColumn:@"authCode"];
        model.orderNumber = [resultSet intForColumn:@"orderNumber"];
        
        [murableArray addObject:model];
    }
    
    
    [self closeDataBase];
    return murableArray;

}

+ (NSMutableArray *)selectDataFromDataBaseWithMac:(NSString *)macString{
    
    [self openDataBase];
    
    NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_USERMODEL];

    FMResultSet * resultSet = [database executeQuery:[NSString stringWithFormat:@" SELECT * FROM DataTable WHERE username ='%@' AND MAC IN ('%@')",userName,macString]];
    
    NSMutableArray *murableArray = [[NSMutableArray alloc] initWithCapacity:0];
    while ([resultSet next]) {
        Device *model = [[Device alloc] init];
        model.deviceId = [resultSet stringForColumn:@"id"];
        model.macString = [resultSet stringForColumn:@"MAC"];
        model.name = [resultSet stringForColumn:@"name"];
        model.image = [resultSet stringForColumn:@"logo"];
        model.codeString = [resultSet stringForColumn:@"companyCode"];
        model.deviceType = [resultSet stringForColumn:@"deviceType"];
        model.authCodeString = [resultSet stringForColumn:@"authCode"];
        model.orderNumber = [resultSet intForColumn:@"orderNumber"];

        
      
        [murableArray addObject:model];
    }
    [self closeDataBase];
    return murableArray;
    
}


#pragma mark - 查询数据操作(与其他的都不一样,查询是调用executeQuery,切记切记!!!!!!)
 + (NSMutableArray *)selectAllDataFromDataBase
{
    
    [self openDataBase];
    
    NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_USERMODEL];

    FMResultSet * resultSet = [database executeQuery:[NSString stringWithFormat:@"SELECT * FROM DataTable WHERE username IN ('%@')",userName]];
     
     NSMutableArray *murableArray = [[NSMutableArray alloc] initWithCapacity:0];
    while ([resultSet next]) {
        Device *model = [[Device alloc] init];
        
        model.deviceId = [resultSet stringForColumn:@"id"];
        model.macString = [resultSet stringForColumn:@"MAC"];
        model.name = [resultSet stringForColumn:@"name"];
        model.image = [resultSet stringForColumn:@"logo"];
        
        model.codeString = [resultSet stringForColumn:@"companyCode"];
        model.deviceType = [resultSet stringForColumn:@"deviceType"];
        model.authCodeString = [resultSet stringForColumn:@"authCode"];
        model.orderNumber = [resultSet intForColumn:@"orderNumber"];
    
        [murableArray addObject:model];
    }
     
    
    [self closeDataBase];
     return murableArray;
}





+ (void)updateFromLogo:(Device *)model
{
    
    [self openDataBase];
    
    
    [database executeUpdate:[NSString stringWithFormat:@"UPDATE DataTable SET logo ='%@' WHERE id = '%@' ",model.image,model.deviceId]];
    
    [self closeDataBase];
}


#pragma mark - 更新排序----- executeUpdate
+ (void)updateOrderNumberDataBase:(Device *)device

{
    
    NSLog(@"device===%@==order=%ld",device.deviceId,(long)device.orderNumber);
    [self openDataBase];
    [database executeUpdate:[NSString stringWithFormat:@"UPDATE DataTable SET orderNumber ='%ld'  WHERE id = '%@' ",(long)device.orderNumber,device.deviceId]];
    
    
    [self closeDataBase];
}




+ (NSMutableArray *)ascWithRFtableINOrderNumber
{
    [self openDataBase];
    
    NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_USERMODEL];
//@"SELECT * FROM  DataTable order by orderNumber ASC"
//    [NSString stringWithFormat:@" SELECT * FROM DataTable WHERE MAC IN ('%@')",data]]
    FMResultSet * resultSet = [database  executeQuery:@" SELECT * FROM DataTable WHERE username=?order by orderNumber ASC",userName];
    NSMutableArray *murableArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    while ([resultSet next])
    {
        Device *model = [[Device alloc] init];
        
        model.deviceId = [resultSet stringForColumn:@"id"];
        model.macString = [resultSet stringForColumn:@"MAC"];
        model.name = [resultSet stringForColumn:@"name"];
        model.image = [resultSet stringForColumn:@"logo"];
        model.codeString = [resultSet stringForColumn:@"companyCode"];
        model.deviceType = [resultSet stringForColumn:@"deviceType"];
        model.authCodeString = [resultSet stringForColumn:@"authCode"];
        model.orderNumber = [resultSet intForColumn:@"orderNumber"];
      
        [murableArray addObject:model];
        
    }
    
    
    [self closeDataBase];
    
    return murableArray;
}


+ (NSMutableArray *)descWithRFTableINorderNumber
{
    [self openDataBase];
    NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_USERMODEL];

    FMResultSet * resultSet  = [database executeQuery:@"SELECT * FROM DataTable WHERE username=? ORDER BY orderNumber DESC",userName];
    NSMutableArray *murableArray = [[NSMutableArray alloc] initWithCapacity:0];
    while ([resultSet next])
    {
        
        Device *model = [[Device alloc] init];
        
        model.deviceId = [resultSet stringForColumn:@"id"];
        model.macString = [resultSet stringForColumn:@"MAC"];
        model.name = [resultSet stringForColumn:@"name"];
        model.image = [resultSet stringForColumn:@"logo"];
        model.codeString = [resultSet stringForColumn:@"companyCode"];
        model.deviceType = [resultSet stringForColumn:@"deviceType"];
        model.authCodeString = [resultSet stringForColumn:@"authCode"];
        model.orderNumber = [resultSet intForColumn:@"orderNumber"];
       
        [murableArray addObject:model];
        
    }
    
    
    [self closeDataBase];
    
    return murableArray;
    
}




@end
