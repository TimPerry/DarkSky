
#import "cocos2d.h"
#import "HealthBar.h"
#import "SimpleAudioEngine.h"
#import "GameOverLayer.h"
#import "CCButton.h"

@interface HUDLayer : CCLayer
{
    CCSprite *menuTop;
    CCSprite *fireWallOverlay;

    HealthBar* healthBar, *firePowerBar;
    
    CCButton *btnMenu;
    
    int score;
    CCLabelAtlas *scoreLabel;
    BOOL hasFireWallSP;

}
@property(nonatomic, assign) HealthBar *healthBar;
@property(nonatomic, assign) HealthBar *firePowerBar;

-(void) incrementScoreBy: (int) amount;
-(void) incrementHealthBarBy:(float) amount;
-(void) decrementHealthBarBy:(float) amount;
-(void) incrementFirePowerBy:(float) amount;
-(void) decrementFirePowerBy:(float) amount;
-(void) enableFireWallSP;
-(void) disableFireWallSP;

-(BOOL) menuContainsPoint:(CGPoint) point;


@end
