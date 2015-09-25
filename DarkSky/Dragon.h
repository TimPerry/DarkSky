//
//  Dragon.h
//  DarkSky
//
//  Created by TIM PERRY on 27/09/2011.
//  Copyright 2011 TPN.Net. All rights reserved.
//

#import "cocos2d.h"

#define POWERUP_TYPE_FIRE_WALL 1
#define POWERUP_TYPE_LIGHT_SHIELD 2

@interface Dragon : CCSprite
{
    int dragonPowerUpType;
}
@property (nonatomic, readonly) int dragonPowerUpType;

-(void) enableFireWall;
-(void) enableLightShield;

-(void) disableFireWall;
-(void) disableLightShield;

@end
