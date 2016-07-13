//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "MainVC.h"

@interface EditAbsenceVC : MainVC

@property (nonatomic, assign) NSInteger nowdYear;
@property (nonatomic, assign) NSInteger nowMonth;
@property (nonatomic, assign) NSInteger nowDay;
@property (nonatomic, assign) NSInteger nowHour;
@property (nonatomic, assign) NSInteger nowMinute;
@property (nonatomic, strong) NSString *nowDateStr;
@property (nonatomic, strong) NSString *nowTimeStr;

@property (nonatomic,copy)NSString *databaseId;
@property(nonatomic,strong)NSString *macString;

@end
