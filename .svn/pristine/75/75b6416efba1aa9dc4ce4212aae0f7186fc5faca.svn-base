//
//  LineChartView.h
//  DrawDemo
//
//  Created by 东子 Adam on 12-5-31.
//  Copyright (c) 2012年 热频科技. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>
typedef void(^pointIndex)(CGPoint point);

typedef enum chosenType {
    dayType = 0,
    weekType,
    monthType,
    yearType,
}chosenType;

@class PNPlot;


@interface LineChartView : UIView

@property (nonatomic) chosenType chosenType;

//纵竖轴数据
@property (assign) float hIntervalData;

@property(nonatomic,strong) UILabel *upPointPowerLab;
@property (nonatomic, strong) NSString *dayValue;
@property (nonatomic, strong) NSString *monthValue;

//横竖轴距离间隔
@property (assign) float hInterval;
@property (assign) float vInterval;

//横竖轴显示标签
@property (nonatomic, strong) NSArray *hDesc;
@property (nonatomic, strong) NSArray *vDesc;


@property (nonatomic)CGRect LabRectMake;
//横坐标长度
@property (assign) float maxWidth;
//纵坐标长度
@property (assign) float maxHeight;

//点信息
@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, copy) NSString *infoLinesName;
//纵坐标
@property (nonatomic, strong) NSString *verticalNameCalled;


- (void)getPointClickEBLock:(void (^)(CGPoint point))point;

- (void)setPointClickedBlock:(void (^)(NSInteger index))block;
@property (nonatomic, readonly, strong) NSMutableArray *plots;


- (id)initWithFrame:(CGRect)frame WithLabFrame:(CGRect)frame_lab WithName:(NSString *)name;

- (void)addPlot:(PNPlot *)newPlot;

@end
