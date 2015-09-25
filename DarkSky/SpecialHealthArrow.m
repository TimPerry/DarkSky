//
//  SpecialHealthArrow.m
//  DarkSky
//
//  Created by TIM PERRY on 20/09/2011.
//  Copyright 2011 TPN.Net. All rights reserved.
//

#import "SpecialHealthArrow.h"

@implementation SpecialHealthArrow

- (id)init
{
    if (self = [super init]) {
        type_ = SPECIAL_TYPE_HEALTH;
    }
    
    return self;
}

@end
