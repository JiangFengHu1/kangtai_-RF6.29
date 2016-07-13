//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "NetworkUtil.h"

#define BaiduURL @"www.baidu.com"
#define ReachabilityInstance [[NetworkUtil instance] reachability]

static NetworkUtil* singleton = nil;

@interface NetworkUtil()

@property (strong,nonatomic) Reachability * reachability;
@property (assign,nonatomic) id<NetworkStatusObserver> observer;

@end

@implementation NetworkUtil

+ (void)initialize
{
    [NetworkUtil instance];
}

+ (NetworkUtil *)instance
{
    @synchronized(self)
    {
        if (singleton == nil)
        {
            singleton = [[self alloc] init];
            singleton.reachability = [Reachability reachabilityWithHostname:BaiduURL];
        }
    }
    return  singleton;
}

+ (void)setNetworkStatusObserver:(id<NetworkStatusObserver>)observer
{
    [NetworkUtil instance].observer = observer;
    if (observer)
    {
        [[NSNotificationCenter defaultCenter] addObserver:singleton selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        [ReachabilityInstance startNotifier];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:singleton];
        [ReachabilityInstance stopNotifier];
    }
}

+ (void)removeObserver
{
    id observer = [NetworkUtil instance].observer;
    if (observer)
    {
        [self setNetworkStatusObserver:nil];
    }
}

- (void)reachabilityChanged:(NSNotification *)note
{
    [self.observer networkStatusChanged:singleton.reachability.currentReachabilityStatus];
}

+ (ReachabilityNetworkStatus)networkStatus
{
    return ReachabilityInstance.currentReachabilityStatus;
}

+ (SCNetworkReachabilityFlags)networkFlags
{
    return ReachabilityInstance.reachabilityFlags;
}

+ (BOOL)isNetworkEnabled
{
    return ReachabilityInstance.currentReachabilityStatus != NotReachable;
}

@end
