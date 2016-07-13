//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import <Foundation/Foundation.h>
#import "SocketTime.h"
#import "NSCodingUtil.h"

@interface PanelSocket : NSCodingObject

@property (strong,nonatomic) NSString * image;
@property (strong,nonatomic) NSString * name;
@property (nonatomic,getter = isOpen) BOOL open;
@property (nonatomic) UInt8 pinNum;

@property (strong,nonatomic) NSArray * timeArray;

@end
