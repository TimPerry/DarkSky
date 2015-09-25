//
//  SlideShowLayer.m
//  DarkSky
//
//  Created by TIM PERRY on 02/10/2011.
//  Copyright 2011 TPN.Net. All rights reserved.
//

#import "SlideShowLayer.h"

@implementation SlideShowLayer

static int currentLevel;

- (id)init
{
    self = [super init];
    if (self) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        img1 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%i_1.png", currentLevel]];
        img2 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%i_2.png", currentLevel]];
        img3 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%i_3.png", currentLevel]];

        img1.position = ccp(size.width/2, size.height/2);
        img2.position = ccp(size.width+(size.width/2), size.height/2); 
        img3.position = ccp((size.width*2)+(size.width/2), size.height/2);
        
        storyHolder = [[CCSprite alloc] init];
        
        [storyHolder addChild:img1];
        [storyHolder addChild:img2];
        [storyHolder addChild:img3];
        
        [self addChild:storyHolder];
        
        [self schedule:@selector(changeImage) interval:10.0];
        
        self.isTouchEnabled = true;
        
    }
    
    return self;
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self changeImage];
    return YES;
}

-(void)changeImage
{
    currentImage ++;
    CGSize size = [[CCDirector sharedDirector] winSize];

    id moveImg = [CCMoveBy actionWithDuration:0.4f position:ccp(-size.width,0)];
    
    [storyHolder runAction:moveImg];
    if (currentImage > 2)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:currentLevel++ forKey:@"userLevel"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:[GameLayer sceneWithLevelNo:currentLevel++]]];
    }
}

+(CCScene *) sceneWithLevelNo:(int) levelNo
{
    CCScene *scene = [CCScene node];
    
    currentLevel = levelNo;
    
    [scene addChild:[SlideShowLayer node]];
    
    return scene;
}

@end
