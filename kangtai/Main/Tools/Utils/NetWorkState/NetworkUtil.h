//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@protocol NetworkStatusObserver <NSObject>
@required
- (void)networkStatusChanged:(ReachabilityNetworkStatus)status;
@end

@interface NetworkUtil : NSObject

+ (void)initialize;
+ (BOOL)isNetworkEnabled;
+ (ReachabilityNetworkStatus)networkStatus;
+ (void)setNetworkStatusObserver:(id<NetworkStatusObserver>)observer;
+ (void)removeObserver;

@end
