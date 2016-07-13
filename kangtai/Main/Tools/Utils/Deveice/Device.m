//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "Device.h"
#import "ResponseAnalysis.h"
#import "PanelSocket.h"

@interface Device()

@property (weak,nonatomic) id observer;

@end

@implementation Device


- (id)copyWithZone:(NSZone *)zone
{
    return (id)self;
 
}

//+ (id)copyWithZone:(NSZone *)zone
//{
//    return (id)self;
//}

+ (id)copy {
    return (id)self;
}


- (id)copy {
    return [(id)self copyWithZone:NULL];
}

- (id)init
{
    self = [super init];
    self.image = @"socket";
    return self;
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[self class]] && [[object pk] isEqualToString:_pk])
    {
        return YES;
    }
    return NO;
}

- (void)didConnect:(NSData *)response
{
    [ResponseAnalysis connectDevice:self response:response];
    if (!self.socketArray)
    {
        [self initSocketArray];
    }
    if (!_connected)
    {
        [self willChangeValueForKey:@"connected"];
        _connected = YES;
        [self didChangeValueForKey:@"connected"];
        [_observer statusChanged:self];
    }
}

- (void)initSocketArray
{
    int socketNumber = [self socketNumber];
    NSMutableArray * socketArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < socketNumber; i++)
    {
        PanelSocket * panelSocket = [[PanelSocket alloc] init];
        panelSocket.pinNum = i;
        panelSocket.name = [NSString stringWithFormat:@"Socket%d",i + 1];
        [socketArray addObject:panelSocket];
    }
    self.socketArray = socketArray;
}

- (void)disConnect
{
    if (_connected)
    {
        [self willChangeValueForKey:@"connected"];
        _connected = NO;
        [self didChangeValueForKey:@"connected"];
        [_observer statusChanged:self];
    }
}

- (int)socketNumber
{
    
    if (_type == 0)
    {
        return 0;
    }
    
    return _type - 0x10;
}

- (void)updateGPIOWithPinArray:(NSArray *)pinArray
{
    for (NSData * pin in pinArray)
    {
        [self updatePin:pin];
    }
    [self.gpioWatcher gpioChangedInDevice:self];
}

- (void)updatePin:(NSData *)pin
{
//    UInt8 * bytes = (UInt8 *)pin.bytes;
//    UInt8 pinNum = bytes[0];
//    UInt8 duty = bytes[2];
//    PanelSocket * socket = [_socketArray objectAtIndex:pinNum];
//    socket.open = duty == 0xff;
}

- (void)setName:(NSString *)name
{
    _name = name;
    [_observer statusChanged:self];
}

- (void)setImage:(NSString *)image
{
    _image = image;
    [_observer statusChanged:self];
}

- (void)setLocked:(BOOL)locked
{
    _locked = locked;
    [_observer statusChanged:self];
}

- (void)setObserver:(id)observer
{
    _observer = observer;
}

@end
