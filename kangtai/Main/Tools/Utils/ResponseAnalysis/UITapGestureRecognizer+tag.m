//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "UITapGestureRecognizer+tag.h"

@implementation UITapGestureRecognizer(tag)

static char tagKey;

-(NSNumber *)tag
{
    return objc_getAssociatedObject(self, &tagKey);
}

-(void)setTag:(NSNumber *)tag
{
    objc_setAssociatedObject(self, &tagKey, tag, OBJC_ASSOCIATION_RETAIN);
}

@end
