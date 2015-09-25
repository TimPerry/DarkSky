//
//  MenuLayer.h
//  DarkSky
//
//  Created by TIM PERRY on 30/09/2011.
//  Copyright 2011 TPN.Net. All rights reserved.
//

#import "SimpleAudioEngine.h"
#import "cocos2d.h"
#import "CCButton.h"

@interface MenuLayer : CCLayer
{
    CCButton *btnSave;
    CCButton *btnEnableVibrations;
    CCButton *btnDisableVibrations;
    CCButton *sliderBG1;
    CCButton *sliderBG2;
    CCButton *slider1;
    CCButton *slider2;
    
    BOOL vibrationsEnabled;
    BOOL userChangedEffectsVol;
    float effectsVol;
    float musicVol;
    
    int sliderMin, sliderMax;
}
+(CCScene *) scene;
-(void) saveToUserDefaults;
@end
