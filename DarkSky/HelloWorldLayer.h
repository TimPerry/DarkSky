//
//  HelloWorldLayer.h
//  DarkSky
//
//  Created by TIM PERRY on 13/09/2011.
//  Copyright TPN.Net 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "CCTouchDispatcher.h"
#import "SpecialArrow.h"
#import "SpecialFireWallArrow.h"
#import "SpecialHealthArrow.h"
#import "FireBall.h"
#import "HealthBar.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    

    CCSprite *dragon;
    CCSprite *promptScreen;
        
    NSMutableArray *arrowList, *fireList;
    
    int score, dragonAnimStage;
    
    bool specialArrowType, hasFireWallSP;
    
    CCLabelAtlas *scoreLabel;

}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(void) incrementHealthBarBy:(float) amount;
-(void) decrementHealthBarBy:(float) amount;
-(void) incrementFirePowerBy:(float) amount;
-(void) decrementFirePowerBy:(float) amount;
-(void) enableFireWallSP
;
@end
