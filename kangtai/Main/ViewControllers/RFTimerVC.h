//
//  RFTimerVC.h
//  kangtai
//
//  Created by 张群 on 15/9/23.
//
//

#import "MainVC.h"

@interface RFTimerVC : MainVC

@property(nonatomic, copy) NSString *deviceId;
@property(nonatomic, assign) int taskNumber;
@property(nonatomic, copy) NSString *typeStr;
@property(nonatomic, copy) NSString *macString;
@property(nonatomic, copy) NSString *rfAddress;
@property(nonatomic, copy) NSString *rfType;
@property(nonatomic, strong) NSMutableArray *indexArray;

@end
