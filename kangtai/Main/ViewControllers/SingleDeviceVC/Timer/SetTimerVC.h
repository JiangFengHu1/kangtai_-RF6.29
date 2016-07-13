//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "MainVC.h"

@interface SetTimerVC : MainVC

@property(nonatomic, copy) NSString *deviceId;
@property(nonatomic, assign) int taskNumber;
@property(nonatomic, copy) NSString *typeStr;
@property(nonatomic, copy) NSString *macString;
@property(nonatomic, copy) NSString *rfAddress;
@property(nonatomic, copy) NSString *rfType;
@property(nonatomic, strong) NSMutableArray *indexArray;

@end
