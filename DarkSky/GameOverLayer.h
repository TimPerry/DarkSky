//
//  GameOverLayer.h
//  DarkSky
//
//  Created by TIM PERRY on 28/09/2011.
//  Copyright 2011 TPN.Net. All rights reserved.
//

#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "GameLayer.h"

@interface GameOverLayer : CCLayer
{
        
}
+(CCScene *) sceneWithScore:(int)s;

@end
