
#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "RFDataModel.h"

@interface RFDataBase : NSObject


//关闭数据库
+ (void)closeDataBase;

//插入数据
+ (void)insertIntoDataBase:(RFDataModel *)model;
//获得对象 并打开数据库，创建表
+ (RFDataBase *)shareInstance;

//根据id删除数据
+ (void)deleteDataFromDataBase:(RFDataModel *)model;

+ (NSMutableArray *)selectDataFromDataBaseWithAddress:(NSString *)address;
//查询数据
+ (NSMutableArray *)selectAllDataFromDataBase:(NSString *)data;

//更新数据库数据
+ (void)updateFromDataBase:(RFDataModel *)person;

// 排序
+ (NSMutableArray *)descWithRFTableINorderNumber;
+ (NSMutableArray *)ascWithRFTableINorderNumber;

@end
