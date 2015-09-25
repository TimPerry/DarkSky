//
//  MenuLayer.m
//  DarkSky
//
//  Created by TIM PERRY on 30/09/2011.
//  Copyright 2011 TPN.Net. All rights reserved.
//

#import "MenuLayer.h"

@implementation MenuLayer

- (id)init
{
    self = [super init];
    if (self) {

        CGSize size = [[CCDirector sharedDirector] winSize];

        CCSprite *background = [[CCSprite alloc] initWithFile:@"settingsbg.png"];        
        btnSave = [[CCButton alloc] initWithFile:@"save.png"];
        btnEnableVibrations = [[CCButton alloc] initWithFile:@"enablevibrations.png"];
        btnDisableVibrations = [[CCButton alloc] initWithFile:@"disablevibrations.png"];
        sliderBG1 = [[CCButton alloc] initWithFile:@"sliderBG.png"];
        sliderBG2 = [[CCButton alloc] initWithFile:@"sliderBG.png"];
        slider1 = [[CCButton alloc] initWithFile:@"sliderBtn.png"];
        slider2 = [[CCButton alloc] initWithFile:@"sliderBtn.png"];

        [self addChild:background];        
        [self addChild:btnSave];
        [self addChild:btnEnableVibrations];
        [self addChild:btnDisableVibrations];
        [self addChild:sliderBG1];
        [self addChild:sliderBG2];
        [self addChild:slider1];
        [self addChild:slider2];
        
        background.position = ccp(size.width/2, size.height/2);
        btnSave.position = ccp(size.width/2, size.height-50);
        btnEnableVibrations.position = ccp(size.width/4, size.height-120);
        btnDisableVibrations.position = ccp(size.width/4*3, size.height-120);
        sliderBG1.position = ccp(300, 75);
        sliderBG2.position = ccp(300, 150);
                
        sliderMin = 160;
        sliderMax = 440;
        
        slider1.position = ccp(sliderMax, 75);
        slider2.position = ccp(sliderMax, 150);
                
        self.isTouchEnabled = true; 
        userChangedEffectsVol = false;
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"darksky.mp3"];
        
        float slider1Pos = [[NSUserDefaults standardUserDefaults] floatForKey:@"effectssliderpos"];
        if (slider1Pos >=sliderMin && slider1Pos <= sliderMax)
        {    
            slider1.position = ccp(slider1Pos, slider1.position.y);
        }
        
        float slider2Pos = [[NSUserDefaults standardUserDefaults] floatForKey:@"musicsliderpos"];
        if (slider2Pos >=sliderMin && slider2Pos <= sliderMax)
        {
            slider2.position = ccp(slider2Pos, slider2.position.y);
        }
        
    }
    
    return self;
}

-(void) saveToUserDefaults
{
    [[NSUserDefaults standardUserDefaults] setFloat:effectsVol forKey:@"volfx"];
    [[NSUserDefaults standardUserDefaults] setFloat:musicVol forKey:@"volmusic"];
    [[NSUserDefaults standardUserDefaults] setFloat:slider2.position.x forKey:@"musicsliderpos"];
    [[NSUserDefaults standardUserDefaults] setFloat:slider1.position.x forKey:@"effectssliderpos"];
    [[NSUserDefaults standardUserDefaults] setBool:vibrationsEnabled forKey:@"usevibrations"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Dragon_wings.wav"];
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (userChangedEffectsVol)
    {
        userChangedEffectsVol = false;
        [[SimpleAudioEngine sharedEngine] playEffect:@"powerup.mp3"];
    }
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [self convertTouchToNodeSpace: touch];

    if (location.x > sliderMin && location.x < sliderMax)
    {
        if([sliderBG1 containsPoint:location])
        {
            userChangedEffectsVol = true;
            slider1.position = ccp(location.x, slider1.position.y);
            float tmpVol = slider1.position.x-sliderMin;
            
            // conver to  0 - 1 range
            effectsVol = ((((tmpVol - sliderMin) * (100 - 0)) / (sliderMax - sliderMin)) + 56.7) /100;
            
            if (effectsVol < 0)
                effectsVol = 0;
            else if (effectsVol > 1)
                effectsVol = 1;
            
            [[SimpleAudioEngine sharedEngine] setEffectsVolume:effectsVol];
            
            //NSLog(@"tmp: %f, musicV: %f", tmpVol, effectsVol );
        }
        else if([sliderBG2 containsPoint:location])
        {
            slider2.position = ccp(location.x, slider2.position.y);
            
            float tmpVol = slider2.position.x-sliderMin;
            
            // conver to  0 - 1 range
            musicVol = ((((tmpVol - sliderMin) * (100 - 0)) / (sliderMax - sliderMin)) + 56.7) /100;
            
            if (musicVol < 0)
                musicVol = 0;
            else if (musicVol > 1)
                musicVol = 1;
            
            [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:musicVol];

        }
    }
    
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event 
{
    CGPoint location = [self convertTouchToNodeSpace: touch];
    
    if ([btnSave containsPoint:location])
    {
        [self saveToUserDefaults];
        [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionZoomFlipX class] duration:0.5];
    }
    else if ([btnEnableVibrations containsPoint:location])
    {
        vibrationsEnabled = true;
    }
    else if ([btnDisableVibrations containsPoint:location])
    {
        vibrationsEnabled = false;
    }
    
    return YES;
}

+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    
    [scene addChild:[MenuLayer node]];
    
    return scene;
    
}

@end
