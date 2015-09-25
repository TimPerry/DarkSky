//
//  Fireball.m
//  DarkSky
//
//  Created by TIM PERRY on 20/09/2011.
//  Copyright 2011 TPN.Net. All rights reserved.
//

#import "Fireball.h"
#import "cocos2d.h"

@implementation Fireball

- (id)init
{
    self = [super init];
    
    id particleFireball = [CCParticleSystemQuad particleWithFile:@"fireball.plist"];
    [particleFireball setEmitterMode: kCCParticleModeGravity];
    [particleFireball setPositionType:kCCPositionTypeFree];

    return particleFireball;
}

@end
