//
//  HealthBar.m
//  DarkSky
//
//  Created by TIM PERRY on 20/09/2011.
//  Copyright 2011 TPN.Net. All rights reserved.
//

#import "HealthBar.h"

@implementation HealthBar

- (id)init
{
    self = [super init];
    
    CCProgressTimer *healthBar = [CCProgressTimer progressWithFile:@"healthbar.png"];
    healthBar.type = kCCProgressTimerTypeHorizontalBarLR;
    healthBar.percentage = 100.0f;
     
    return (HealthBar*)healthBar;
}

@end
