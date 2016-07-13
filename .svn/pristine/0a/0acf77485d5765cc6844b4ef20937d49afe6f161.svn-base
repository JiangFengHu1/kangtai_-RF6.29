//
//  LineChartView.m
//  DrawDemo
//
//  Created by 东子 Adam on 12-5-31.
//  Copyright (c) 2012年 热频科技. All rights reserved.
//

#import "LineChartView.h"
#import "PNPlot.h"
#import <math.h>
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
typedef void(^itemClickedBlock)(NSInteger index);
@interface LineChartView()
{
    CALayer *linesLayer;
    UIImageView *bgImgView;
    UILabel *energyLabel;
    
//    UIView *popView;
//    UILabel *disLabel;
}
@property (nonatomic, copy) itemClickedBlock clickedBlock;
@property (nonatomic, strong) UIView *popView;
@property (nonatomic, strong) UILabel *disLabel;
@end

@implementation LineChartView

@synthesize array;

@synthesize hInterval,vInterval,hIntervalData;

@synthesize hDesc,vDesc;

@synthesize maxHeight,maxWidth;

@synthesize verticalNameCalled;


- (void)addPlot:(PNPlot *)newPlot;
{
    if(nil == newPlot ) {
        return;
    }
    
    if (newPlot.plottingValues.count ==0) {
        return;
    }
    
    
    if(self.plots == nil){
        _plots = [NSMutableArray array];
    }
    
    [self.plots addObject:newPlot];
    
    [self layoutIfNeeded];
}

-(void)clearPlot{
    if (self.plots) {
        [self.plots removeAllObjects];
    }
}

- (id)initWithFrame:(CGRect)frame WithLabFrame:(CGRect)frame_lab WithName:(NSString *)name
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.infoLinesName = name;
        self.LabRectMake = frame_lab;
        linesLayer = [[CALayer alloc] init];
        linesLayer.masksToBounds = YES;
        linesLayer.contentsGravity = kCAGravityLeft;
        linesLayer.backgroundColor = [[UIColor whiteColor] CGColor];
        [self.layer addSublayer:linesLayer];
        
        // 点击时候的circle
        _popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_popView setBackgroundColor:RGBA(30, 190, 250, 1)];
        [_popView setAlpha:0.0f];
        [self addSubview:_popView];
        
        // 点击时候 对应数值label的背景图
        bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 35)];
        bgImgView.image = [UIImage imageNamed:@"tips_back.png"];
        bgImgView.hidden = YES;
        [self addSubview:bgImgView];
        
        // 点击时候 对应数值label
        energyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 30, 10)];
        energyLabel.backgroundColor = [UIColor clearColor];
        energyLabel.textColor = [UIColor whiteColor];
        energyLabel.textAlignment = NSTextAlignmentCenter;
        energyLabel.font = [UIFont systemFontOfSize:12.f];
        [bgImgView addSubview:energyLabel];
        
    }
    return self;
}

#define ZeroPoint CGPointMake(hInterval,maxHeight-vDesc)

- (void)drawRect:(CGRect)rect
{
    [self setClearsContextBeforeDrawing: YES];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2);//主线宽度
    //画背景线条------------------
//    CGColorRef backColorRef = [UIColor blueColor].CGColor;
//    CGFloat backLineWidth = 2.f;
//    CGFloat backMiterLimit = 10.f;
    
//    CGContextSetLineWidth(context, backLineWidth);//主线宽度
//    CGContextSetMiterLimit(context, backMiterLimit);//投影角度
    //
//    CGContextSetShadowWithColor(context, CGSizeMake(3, 5), 8, backColorRef);//设置双条线
    //
    CGContextSetLineJoin(context, kCGLineJoinRound);
    //
    CGContextSetLineCap(context, kCGLineCapRound);
    //
    CGContextSetBlendMode(context, kCGBlendModeNormal);

    float x = hDesc.count*40;
    int y = maxHeight;

    UIColor *color = RGBA(0, 160, 235, 1.f);

    //绘制水平坐标轴
    
    //垂直的点
    for (int i=0; i<vDesc.count; i++) {
        if (i== 0)
        {
            CGContextSetLineWidth(context, 1.4f);
            CGContextSetStrokeColorWithColor(context, color.CGColor);
        }
        else
        {
            CGContextSetLineWidth(context, 0.5f);
            CGContextSetStrokeColorWithColor(context, color.CGColor);
        }
        CGPoint bPoint = CGPointMake(hInterval, y);
        CGPoint ePoint = CGPointMake(x, y);
        

        //最后一条加千瓦时
        if(i==vDesc.count-1){
            if(![verticalNameCalled isEqualToString:@""])
            {}
//                [label setText:verticalNameCalled];
//            else
//                [label setText:@"w"];
//            [label setFont:[UIFont systemFontOfSize:11.f]];
        }else{
//            [label setText:[vDesc objectAtIndex:i]];
            CGContextMoveToPoint(context, bPoint.x, bPoint.y-vInterval);
            CGContextAddLineToPoint(context, ePoint.x, bPoint.y-vInterval);
        }
//        [self addSubview:label];
        y -=vInterval ;
        CGContextStrokePath(context);
    }
    
    x=hInterval;
    y=maxHeight-15;
    
    int index = 0;
    for (int i = 0; i < self.hDesc.count; i++) {
        if (self.chosenType == 0 && [[self.hDesc objectAtIndex:i] isEqualToString:@"1:00"]) {
            index = i;
        }
        if (self.chosenType == 1 && [[self.hDesc objectAtIndex:i] isEqualToString:@"Mon"]) {
            index = i;
        }
        if (self.chosenType == 2 && [[self.hDesc objectAtIndex:i] isEqualToString:@"2th"]) {
            
            if (([self.hDesc indexOfObject:@"1th"] == 2 || [self.hDesc indexOfObject:@"1th"] == 1) && [[self.hDesc lastObject] isEqualToString:@"1th"]) {
                index = (int)self.hDesc.count;
            } else if ([[self.hDesc lastObject] isEqualToString:@"31th"]) {
                index = 2;
            } else {
                index = i;
            }
        }
        if (self.chosenType == 3 && [[self.hDesc objectAtIndex:i] isEqualToString:@"Feb"]) {
            index = i;
        }
    }
    
    if (index == 1) {
        index = (int)self.hDesc.count;
    }

//    NSLog(@"=== %@ %d %d %d == zq", self.hDesc, index, self.hDesc.count, self.chosenType);
    
    //绘制垂直坐标轴
    
    for (int i=0; i<self.hDesc.count; i++) {
        if (i== 0)
        {
            CGContextSetLineWidth(context, .8f);
            CGContextSetStrokeColorWithColor(context, color.CGColor);
        }
        else
        {
            CGContextSetLineWidth(context, 0.5f);
            CGContextSetStrokeColorWithColor(context, color.CGColor);
        }
        CGPoint hMinPoint = CGPointMake(x,y);
        CGPoint hMaxPoint = CGPointMake(x,55);
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*hInterval, maxHeight-25, 40, 30)];
        if (self.hDesc.count == 24 && i == 0) {
            [label setCenter:CGPointMake(hMinPoint.x+7, hMinPoint.y+7)];
        } else
        [label setCenter:CGPointMake(hMinPoint.x+2, hMinPoint.y+7)];
        [label setBackgroundColor:[UIColor clearColor]];
        
        
        if (i < index - 1) {
            [label setTextColor:[UIColor grayColor]];
        } else {
            [label setTextColor:RGBA(0, 160, 230, 1)];
        }
        [label setFont:[UIFont systemFontOfSize:11.f]];
        label.numberOfLines = 0.1;
        label.adjustsFontSizeToFitWidth = YES;
//        label.minimumFontSize = 1.0f;
        [label setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:label];
        
        [label setText:[self.hDesc objectAtIndex:i]];
        CGContextMoveToPoint(context, hMinPoint.x, maxHeight-vInterval);
        CGContextAddLineToPoint(context, hMaxPoint.x, vInterval);
        
        x += hInterval;
        CGContextStrokePath(context);
    }
    
    for (int i=0; i<self.plots.count; i++)
    {
        
        PNPlot* plot = [self.plots objectAtIndex:i];
        
        [plot.lineColor set];
        CGContextSetLineWidth(context, plot.lineWidth);
        
        self.array = plot.plottingValues;

    //    //画点线条------------------
//        CGColorRef pointColorRef = [UIColor colorWithRed:24.0f/255.0f green:116.0f/255.0f blue:205.0f/255.0f alpha:1.0].CGColor;
        CGFloat pointLineWidth = 2.0f;
//        CGFloat pointMiterLimit = 5.0f;
    
        CGContextSetLineWidth(context, pointLineWidth);//主线宽度
//        CGContextSetMiterLimit(context, pointMiterLimit);//投影角度
    
    
//        CGContextSetShadowWithColor(context, CGSizeMake(3, 5), 8, pointColorRef);//设置双条线
    
        CGContextSetLineJoin(context, kCGLineJoinRound);
    
        CGContextSetLineCap(context, kCGLineCapRound);
    
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        
        NSLog(@"== %@ == %@", self.array, self.hDesc);
        
        
        //绘图
    	for (int i=1; i<index; i++)
    	{
            float aa;
            
            NSString *str = [self.array objectAtIndex:i-1];

            if (self.hDesc.count == 24) {
                if (i % 2 == 0) {
                    NSArray *arr = [[NSString stringWithFormat:@"%@",str] componentsSeparatedByString:@":"];
                    NSString *tempStr = arr[0];

                    aa = [tempStr floatValue];

                } else {
                    aa = [str floatValue];
                }
                NSLog(@"== %f ==", aa);

            } else {
                aa = [str floatValue];
            }

            //CGPoint goPoint = CGPointMake((i+1) * hInterval, maxHeight-(aa+1) * vInterval);
            CGPoint goPoint;
            if(hIntervalData == (float)0)
            {
                goPoint = CGPointMake((i+1) * hInterval, maxHeight- vInterval);
            }
            else
            {
                goPoint = CGPointMake((i+1) * hInterval, maxHeight- ((float)(aa / hIntervalData) + 1.0) * vInterval);
            }
            CGContextSetStrokeColorWithColor(context,  plot.lineColor.CGColor);// 给整个线条着色的方法

            if (i!=1) {
                CGContextAddLineToPoint(context, (i+1)*hInterval, goPoint.y);//画直线, x，y 为线条结束点的坐标
            }else{
                CGContextMoveToPoint(context, (i+1)*hInterval, goPoint.y); //开始画线, x，y 为开始点的坐标
            }
            
            UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
            circleView.layer.masksToBounds = YES;
            circleView.layer.cornerRadius = 4;
            circleView.backgroundColor = plot.lineColor;
            [circleView setCenter:goPoint];
            [self addSubview:circleView];
            
            //添加触摸点
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0, 0, 28, 28)];
            
            [button.layer setMasksToBounds:YES];
            button.layer.cornerRadius=7.f;
            [button setCenter:goPoint];
            [button setTag:i];
            //点击事件
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
    	}
        CGContextStrokePath(context);
        
        CGContextRef context2 = UIGraphicsGetCurrentContext(); //设置上下文
        //画一条线
        CGContextSetStrokeColorWithColor(context2,plot.heightLineColor.CGColor);//线条颜色
        //绘图
    	for (int i=index-1; i<self.hDesc.count ; i++)
    	{
            float aa;
            NSString *str = [self.array objectAtIndex:i-1];
            if (self.hDesc.count == 24) {
                if (i % 2 == 0) {
                    NSArray *arr = [[NSString stringWithFormat:@"%@",str] componentsSeparatedByString:@":"];
                    NSString *tempStr = arr[0];
                    
                    aa = [tempStr floatValue];
                } else {
                    aa = [str floatValue];
                }
            } else {
                aa = [str floatValue];
            }

            CGPoint goPoint;
            if(hIntervalData == (float)0)
            {
                goPoint = CGPointMake((i+1) * hInterval, maxHeight- vInterval);
            }
            else
            {
                goPoint = CGPointMake((i+1) * hInterval, maxHeight- ((float)(aa / hIntervalData) + 1.0) * vInterval);
            }
            if (i!=index-1) {
                CGContextAddLineToPoint(context2, (i+1)*hInterval, goPoint.y);
            }else{
                CGContextMoveToPoint(context2, (i+1)*hInterval, goPoint.y);
            }
            
            UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
            circleView.layer.masksToBounds = YES;
            circleView.layer.cornerRadius = 4;
            circleView.backgroundColor = plot.heightLineColor;
            [circleView setCenter:goPoint];
            [self addSubview:circleView];
            
            //添加触摸点
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0, 0, 28, 28)];
            [button.layer setMasksToBounds:YES];
            button.layer.cornerRadius=7.f;
            [button setCenter:goPoint];
            [button setTag:i];
            //点击事件
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
         
    	}
        
        CGContextStrokePath(context2);

        }
    [super drawRect:rect];
}

- (void)buttonClick:(UIButton *)button
{
    //按钮
    _popView.center = CGPointMake(button.center.x, button.center.y);
    _popView.layer.masksToBounds=YES;
    _popView.layer.cornerRadius=10;
    [_popView setAlpha:0.75f];
    [self bringSubviewToFront:_popView];

    //回传数据
    if (self.hDesc.count == 13) {
        self.monthValue = [self.hDesc objectAtIndex:button.tag];
    }
    if (self.hDesc.count == 31) {
        self.dayValue = [self.hDesc objectAtIndex:button.tag];
    }
    
    NSString *eneryValueStr;
    if (self.hDesc.count == 25) {
        eneryValueStr = [NSString stringWithFormat:@"%.2fW",[[self.array objectAtIndex:button.tag-1]floatValue]];
    } else {
        eneryValueStr = [NSString stringWithFormat:@"%.2fKWH",[[self.array objectAtIndex:button.tag-1]floatValue]];
    }
    
    UIFont *font = [UIFont systemFontOfSize:12];
    CGSize size = CGSizeMake(300, 300);
    CGSize tempSize = [eneryValueStr sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    
    [energyLabel setFrame:CGRectMake(12, 7, tempSize.width, tempSize.height)];
    [bgImgView setFrame:CGRectMake(0, 0, tempSize.width + 24, tempSize.height + 20)];
    
    energyLabel.text = eneryValueStr;
    bgImgView.center = CGPointMake(button.center.x, button.center.y - 30);

    bgImgView.hidden = NO;
    [self bringSubviewToFront:bgImgView];
}

- (void)setPointClickedBlock:(void (^)(NSInteger index))block
{

}

- (void)getPointClickEBLock:(void (^)(CGPoint point))point
{
    
}

@end
