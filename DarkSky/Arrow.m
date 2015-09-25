//
//  Arrow.m
//  DarkSky
//
//  Created by TIM PERRY on 20/09/2011.
//  Copyright 2011 TPN.Net. All rights reserved.
//

#import "Arrow.h"

@implementation Arrow

@synthesize type = type_;

-(id) init
{
    if( (self=[super init]) )
    {         
        type_ = 0;
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        int min = 50;
        int max = size.height-30;
        float r = 0;
        
        r = ((arc4random() % max) + min);
        
        [self setPosition: ccp(size.width+[self boundingBox].size.width, r)];
                
        id moveOffScreen = [CCMoveTo actionWithDuration:3.0f position:ccp(-50, r)];
        
        [self runAction:moveOffScreen]; 
        
    }
    return self;
}

@end
