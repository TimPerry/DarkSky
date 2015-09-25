//
//  Arrow.h
//  DarkSky
//
//  Created by TIM PERRY on 20/09/2011.
//  Copyright 2011 TPN.Net. All rights reserved.
//

#import "cocos2d.h"
#include <stdlib.h>

#define SPECIAL_TYPE_FIRE 1
#define SPECIAL_TYPE_HEALTH 2

@interface Arrow : CCSprite
{
@protected
    int type_;
}

@property (nonatomic, readonly) int type;
@end
