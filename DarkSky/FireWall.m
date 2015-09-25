//
//  FireWall.m
//  DarkSky
//
//  Created by TIM PERRY on 28/09/2011.
//  Copyright 2011 TPN.Net. All rights reserved.
//

#import "FireWall.h"

@implementation FireWall

- (id)init
{
    self = [super init];
    if (self) {
        CGSize size = [[CCDirector sharedDirector] winSize];

        for(int i=0; i <= size.height; i+= 30)
        {
            Fireball *fb = [[Fireball alloc] init];
            [fb setPosition:ccp(30, i)];
            [self addChild:fb];
        }
    }
    
    return self;
}

@end
