//
//  SlideShowLayer.h
//  DarkSky
//
//  Created by TIM PERRY on 02/10/2011.
//  Copyright 2011 TPN.Net. All rights reserved.
//

#import "cocos2d.h"
#import "GameLayer.h"

@interface SlideShowLayer : CCLayer
{
    int currentImage;
    CCSprite *img1, *img2, *img3;
    CCSprite *storyHolder;
}
+(CCScene *) sceneWithLevelNo:(int) levelNo;
-(void)changeImage;
@end
