
#import "cocos2d.h"
#import "BackgroundLayer.h"
#import "HUDLayer.h"
#import "CCTouchDispatcher.h"
#import "SpecialFireWallArrow.h"
#import "SpecialHealthArrow.h"
#import "FireBall.h"
#import "FireWall.h"
#import "HealthBar.h"
#import "SimpleAudioEngine.h"
#import "Dragon.h"
#import "MenuLayer.h"
#import <AudioToolbox/AudioServices.h>

@interface GameLayer : CCLayer
{
    NSMutableArray *arrowList, *fireList;

    Dragon *dragon;
        
    bool specialArrowType, hasFireWallSP;
    
}

+(CCScene *) sceneWithLevelNo:(int)level;
-(void) makeItRain;
-(void) flashLightening;
-(void) vibateIfEnabled;

@end
