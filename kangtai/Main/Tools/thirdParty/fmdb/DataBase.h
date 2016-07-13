
#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface DataBase : NSObject

//关闭数据库
+ (void)closeDataBase;

//插入数据
+ (void)insertIntoDataBase:(Device *)model;

//+ (void)upDATEDataBaseWithHostTolocal:(NSString *)host where:(NSString *)mac;


//+ (void)updataKeyTolocal:(NSString *)key  where:(NSString *)mac;

////修改UDP链接状态
//+ (void)updataChangeUDPState:(Device *)device;


//更新设备锁定状态
//+ (void)updateFromLockType:(Device *)person;

//获得对象 并打开数据库，创建表
+ (DataBase *)shareInstance;

+ (void)updateFromLogo:(Device *)model;
//根据id删除数据
+ (void)deleteDataFromDataBase:(Device *)model;


//#pragma mark - 固件版本----- executeUpdate
//+ (void)updateSverDataBaseMAC:(Device *)device;
//查询数据

+ (NSMutableArray *)selectDataFromDataBaseWithId:(NSString *)model;

+ (NSMutableArray *)selectAllDataFromDataBase;

+ (NSMutableArray *)selectDataFromDataBaseWithMac:(NSString *)macString;


//+ (void)updateFromDataBase:(Device *)person;

//排序，正序，倒序
+ (NSMutableArray *)ascWithRFtableINOrderNumber;
+ (NSMutableArray *)descWithRFTableINorderNumber;

//通过mac地址删除设备
+ (void)deleteDataWithMacString:(Device *)model;


//修改名称
+ (void)updataName:(NSString *)Name where:(NSString *)mac;

#pragma mark - 更新排序----- executeUpdate
+ (void)updateOrderNumberDataBase:(Device *)device;

//更新imageName
+ (void)updataToDataBaseWithimageName:(NSString *)imageName where:(NSString *)mac;



@end
