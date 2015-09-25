//
//  CCButton.m
//  DarkSky
//
//  Created by TIM PERRY on 30/09/2011.
//  Copyright 2011 TPN.Net. All rights reserved.
//

#import "CCButton.h"

@implementation CCButton

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(BOOL) containsPoint:(CGPoint) point
{
    CGRect btnMenuRec = [self boundingBox];
    CGRect touchRec = CGRectMake(point.x, point.y, 1, 1);
    return CGRectIntersectsRect(touchRec, btnMenuRec);
}



@end
