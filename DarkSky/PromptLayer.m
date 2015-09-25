//
//  PromptLayer.m
//  DarkSky
//
//  Created by TIM PERRY on 26/09/2011.
//  Copyright 2011 TPN.Net. All rights reserved.
//

#import "PromptLayer.h"
#import "cocos2d.h"
#import "SlideShowLayer.h"

@implementation PromptLayer

- (id)init
{
    self = [super init];
    if (self) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        // add the prompt
        CCSprite *promptScreen = [CCSprite spriteWithFile: @"promptstart.png"];
        promptScreen.position = ccp(size.width/2, size.height/2);
        [self addChild:promptScreen];
        
        self.isTouchEnabled = true; 
        
        // play the sound
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"darksky.mp3"];
        
        float musicVol = [[NSUserDefaults standardUserDefaults] floatForKey:@"volmusic"];
        
        if (musicVol >= 0 && musicVol <= 1)
            [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:musicVol];
        
        float effectsVol = [[NSUserDefaults standardUserDefaults] floatForKey:@"volfx"];
        
        if (effectsVol >= 0 && effectsVol <= 1)
            [[SimpleAudioEngine sharedEngine] setEffectsVolume:effectsVol];
        
    }
    
    return self;
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint location = [self convertTouchToNodeSpace:touch];
    CGSize size = [[CCDirector sharedDirector] winSize];

    if (location.x < size.width/2)
    {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:[SlideShowLayer sceneWithLevelNo:0]]];
    }
    else
    {
        int userLevel = 0;
       [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:[GameLayer sceneWithLevelNo:userLevel]]]; 
    }
    return YES;
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
		
	// add layer as a child to scene
	[scene addChild: [PromptLayer node]];
	
	// return the scene
	return scene;
}

@end
