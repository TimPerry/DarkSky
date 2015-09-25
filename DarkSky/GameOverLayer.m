//
//  GameOverLayer.m
//  DarkSky
//
//  Created by TIM PERRY on 28/09/2011.
//  Copyright 2011 TPN.Net. All rights reserved.
//

#import "GameOverLayer.h"

@implementation GameOverLayer

static int score;

+(CCScene *) sceneWithScore:(int)s
{
    score = s;
    
    CCScene *scene = [CCScene node];

    GameOverLayer *layer = [GameOverLayer node];

    [scene addChild:layer];
    
    return scene;
    
}

- (id)init
{
    self = [super init];
    if (self) {

        CGSize size = [[CCDirector sharedDirector] winSize];
        
        // add the prompt
        CCSprite *promptScreen = [CCSprite spriteWithFile: @"gameover.png"];
        promptScreen.position = ccp(size.width/2, size.height/2);
        [self addChild:promptScreen];
        
        self.isTouchEnabled = true; 
        
        // play the sound
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"darksky.mp3"];
        
        CCLabelAtlas *scoreLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%i",score] charMapFile:@"fps_images.png" itemWidth:16 itemHeight:24 startCharMap:'.'];
        int labelWidth = [scoreLabel boundingBox].size.width;
        [scoreLabel setPosition:ccp((size.width/2)-(labelWidth/2), size.height/2-30)];
        [self addChild:scoreLabel];
    
    }
    
    return self;
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    int userLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"userLevel"];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:[GameLayer sceneWithLevelNo:userLevel]]];
    
    return YES;
}

@end
