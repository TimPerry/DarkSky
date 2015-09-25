//
//  Dragon.m
//  DarkSky
//
//  Created by TIM PERRY on 27/09/2011.
//  Copyright 2011 TPN.Net. All rights reserved.
//

#import "Dragon.h"

@implementation Dragon
@synthesize dragonPowerUpType;

- (id)init
{
    self = [super init];
    if (self) {
        
        dragonPowerUpType = 0;
        
        //Initializing a sprite with the first frame from plist
        self.position = ccp( 55, 150 );
        
        CCAnimation *dragonAnim = [CCAnimation animation];
        CCTexture2D *dragonSheet = [[CCTexture2D alloc] initWithImage: [UIImage imageNamed:@"dragon.png"]];
        
        for(int i=0; i < 8; i++)
        {
            [dragonAnim addFrameWithTexture:dragonSheet rect:CGRectMake(i*75, 0, 75, 78)];
        }
        
        id dragonAnimationAction = [CCAnimate actionWithDuration:1.0f animation:dragonAnim restoreOriginalFrame:NO];
        id repeatDragonAnimation = [CCRepeatForever actionWithAction:dragonAnimationAction];
        [self runAction:repeatDragonAnimation];    
    }
    
    return self;
}

-(void) enableFireWall
{
    dragonPowerUpType = POWERUP_TYPE_FIRE_WALL;
}

-(void) enableLightShield
{
    dragonPowerUpType = POWERUP_TYPE_LIGHT_SHIELD;
}

-(void) disableFireWall
{
    dragonPowerUpType = 0;
}

-(void) disableLightShield
{
    dragonPowerUpType = 0;
}
@end
