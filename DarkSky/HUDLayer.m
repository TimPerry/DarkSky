
#import "HUDLayer.h"

@implementation HUDLayer
@synthesize healthBar,firePowerBar;

- (id)init
{
    self = [super init];
    if (self) {
        // add the menu
        menuTop = [CCSprite spriteWithFile: @"menu.png"];
        menuTop.position = ccp( 240, 300 );
        [self addChild:menuTop];
        
        // add the health bar
        healthBar = [[HealthBar alloc] init];
        [self addChild:healthBar];
        healthBar.position = ccp( 72, 304 );
        
        // add the fire power bar
        firePowerBar = [[HealthBar alloc] init];
        [self addChild:firePowerBar];
        firePowerBar.position = ccp( 186, 304 );
        
        score = 0;
        scoreLabel = [CCLabelAtlas labelWithString:@"0" charMapFile:@"score_images.png" itemWidth:17 itemHeight:24 startCharMap:'0'];
        [scoreLabel setPosition:ccp(290, 296)];
        [self addChild:scoreLabel];
        
        btnMenu = [CCButton spriteWithFile:@"btnMenu.png"];
        btnMenu.position = ccp( 440, 300 );
        [self addChild:btnMenu];
        
        // regenerate the fire power
        [self schedule:@selector(regenFirePower:) interval:2.5];
        
        hasFireWallSP = false;
        
    }
    
    return self;
}

-(BOOL) menuContainsPoint:(CGPoint) point
{
    return [btnMenu containsPoint:point];
}

-(void) enableFireWallSP
{
    hasFireWallSP = true;
    fireWallOverlay = [CCSprite spriteWithFile:@"fireWallOverlay.png"];
    fireWallOverlay.position = ccp(128, 300);
    [self addChild: fireWallOverlay];
}

-(void) disableFireWallSP
{
    hasFireWallSP = false;
    [self removeChild:fireWallOverlay cleanup:YES];
}

-(void) regenFirePower: (ccTime)delta
{
    if ([firePowerBar percentage] < 100)
    {
        [firePowerBar setPercentage:firePowerBar.percentage+10.0f];
    }
}

-(void) incrementHealthBarBy:(float) amount
{
    [healthBar setPercentage:healthBar.percentage+amount];
}

-(void) decrementHealthBarBy:(float) amount
{
    [healthBar setPercentage:healthBar.percentage-amount];
    [[SimpleAudioEngine sharedEngine] playEffect:@"dragonhurt.mp3"];
    
    if (healthBar.percentage <= 0)
    {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:[GameOverLayer sceneWithScore:score]]];
    }
    
}

-(void) incrementFirePowerBy:(float) amount
{
    [firePowerBar setPercentage:firePowerBar.percentage-amount];
}

-(void) decrementFirePowerBy:(float) amount
{
    [firePowerBar setPercentage:firePowerBar.percentage-amount];
}

-(void) incrementScoreBy: (int) amount
{
    score += amount;
    [scoreLabel setString:[NSString stringWithFormat:@"%i", score]];
}

@end
