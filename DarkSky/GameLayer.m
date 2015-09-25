
#import "GameLayer.h"

@implementation GameLayer

static HUDLayer *HUDlayer;

- (id)init
{
    self = [super init];
    if (self) {
        self.isTouchEnabled = true; 
        //[self makeItRain];
        
        if( (dragon = [[Dragon alloc] initWithFile:@"dragon.png"]) ) {
            [self addChild:dragon];
        }
        
        // shoot an arrow every 0.5 seconds
        [self schedule:@selector(fireArrow) interval:0.5];
        
        specialArrowType = false;
        // shoot a speical arrow every 5 seconds
        [self schedule:@selector(shootSpeicalArrow:) interval:5.0];

        //check for collisions    
        [self schedule:@selector(checkForCollisions:) interval:1.0/60];
        
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];

        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Dragon_wings.wav"];
                         
        [self flashLightening];
        [self schedule:@selector(flashLightening) interval:17.0];
        
    }
    
    return self;
}


-(void) flashLightening
{
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"thunder.mp3"];

    CGSize size = [[CCDirector sharedDirector] winSize];

    CCSprite *lightening = [CCSprite spriteWithFile:@"lightening.png"];
    lightening.position = ccp(size.width/2, size.height/2);
    [self addChild:lightening];
    
    id fadeOut = [CCFadeTo actionWithDuration:.7f opacity:0.0];
    [lightening runAction:fadeOut];
}


-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void) makeItRain
{
    
    id rain = [CCParticleSystemQuad particleWithFile:@"rain.plist"];
    [rain setEmitterMode: kCCParticleModeGravity];
    [self addChild:rain];
    
}

-(void) fireArrow
{
    
    if (arrowList == nil)
        arrowList = [[NSMutableArray alloc] initWithCapacity:0];
        
    Arrow *arrow = [[Arrow alloc] initWithFile:@"arrow.png"];
    
    [self addChild:arrow];
    [arrowList addObject:arrow];
    
}

-(void) shoot
{
    
    if ([HUDlayer firePowerBar].percentage > 0)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"fire.mp3"];

        if (fireList == nil)
            fireList = [[NSMutableArray alloc]initWithCapacity:0];
        
        if ([dragon dragonPowerUpType] == POWERUP_TYPE_FIRE_WALL)
        {
            FireWall *firewall = [[FireWall alloc] init];
            [self addChild:firewall];
            [fireList addObject:firewall];
            
            [dragon disableFireWall];
            [HUDlayer disableFireWallSP];
            
            id moveOffScreen = [CCMoveBy actionWithDuration:2.0f position:ccp(600, 0)];
            
            [firewall runAction:moveOffScreen];
        }
        else
        {
            Fireball *fireball = [[Fireball alloc] init];
            [self addChild:fireball];
            
            fireball.position = dragon.position;
            fireball.position = ccpAdd(ccp( 50 ,0), fireball.position);
            [fireList addObject:fireball];
            
            id moveOffScreen = [CCMoveBy actionWithDuration:2.0f position:ccp(600, 0)];
            
            [fireball runAction:moveOffScreen];
            
        }
        [HUDlayer decrementFirePowerBy: 10.0f];        
    }
}

-(void) shootSpeicalArrow:(ccTime)delta
{
    if (arrowList == nil) {
        arrowList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    Arrow *specialArrow;
    if (specialArrowType)
    {
        specialArrow = [[SpecialFireWallArrow alloc ] initWithFile:@"arrow_red.png"];
    }
    else
    {        
        specialArrow = [[SpecialHealthArrow alloc ] initWithFile:@"arrow_green.png"];
    }
    specialArrowType = !specialArrowType;
    
    [self addChild:specialArrow];
    [arrowList addObject:specialArrow];

}


-(void) checkForCollisions:(ccTime)delta
{
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGRect viewport = CGRectMake(0,0, winSize.width, winSize.height);
    CGRect dragonRecs = [dragon boundingBox];
    
    // check for collisions
    for(int i=0; i<[arrowList count]; i++)
    {
        Arrow *arrow = [arrowList objectAtIndex:i];
        CCSprite *arrowSprite = [arrowList objectAtIndex:i];

        CGRect arrowRects = [arrow boundingBox];
        
        //first check if it is off screen
        if (!CGRectIntersectsRect(viewport, arrowRects))
        {
            [self removeChild:arrow cleanup:YES];
            [arrowList removeObjectAtIndex:i];
            arrow = nil;
        }
        
        // check for arrows hitting the dragon
        else if (CGRectIntersectsRect(dragonRecs, arrowRects))
        {
            [self removeChild:arrow cleanup:YES];
            [arrowList removeObjectAtIndex:i];
            arrow = nil;
            
            [HUDlayer decrementHealthBarBy:5.0f];
            [self vibateIfEnabled];
            
        }
        
        // if we have not removed the arrow (off screen or hit dragon)
        // then lets see if a fireball has hit it
        if (arrow != nil)
        {
            for (int j=0; j < [fireList count]; j++)
            {
                // get the fireballs area rect
                CCSprite *fireball = [fireList objectAtIndex:j];
                CGRect fireRecs = [fireball boundingBox];
                
                if([fireball isKindOfClass:FireWall.class])
                {
                    fireRecs.size.height = winSize.height*2;
                    fireRecs.size.width = arrowRects.size.width;
                    fireRecs.origin.y -= winSize.height/2;
                }
                else
                {
                    fireRecs.size.height = 40;
                    fireRecs.size.width = arrowRects.size.width;
                    fireRecs.origin.y -= 20; 
                }
                                
                // again check if the fireball has gone off screen
                if (!CGRectIntersectsRect(viewport, fireRecs))
                {
                    [self removeChild:fireball cleanup:YES];
                    [fireList removeObjectAtIndex:j];  
                    //NSLog(@"fireball off screen");
                }
                // check for fireballs hitting arrows
                else if (CGRectIntersectsRect(arrowRects, fireRecs))
                {
                    [self removeChild:arrow cleanup:YES];
                    [arrowList removeObjectAtIndex:i];
                    arrow = nil;
                    
                    [HUDlayer incrementScoreBy:1.0f];
                    
                    //NSLog(@"Type: %i", [arrow type]);
                                                            
                    if ([arrowSprite isKindOfClass:SpecialHealthArrow.class] || [arrow type] == SPECIAL_TYPE_HEALTH)
                    {
                        [HUDlayer incrementHealthBarBy: 10.0f];
                        
                        [[SimpleAudioEngine sharedEngine] playEffect:@"powerup.mp3"];
                    }
                    else if ([arrowSprite isKindOfClass:SpecialFireWallArrow.class] || [arrow type] == SPECIAL_TYPE_FIRE)
                    {
                        [HUDlayer enableFireWallSP];
                        [dragon enableFireWall];
                        
                        [[SimpleAudioEngine sharedEngine] playEffect:@"powerup.mp3"];

                    }
                                        
                    break;
                    
                    
                }
            }
        }
    }
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    CGPoint location = [self convertTouchToNodeSpace: touch];
    if (location.x < size.width/2)
    {
        if(location.y > 30 && location.y < 265)
            [dragon setPosition:ccp(dragon.position.x, location.y)];
    }
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event 
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    CGPoint location = [self convertTouchToNodeSpace: touch];
        
    if ([HUDlayer menuContainsPoint:location])
    {
        [[CCDirector sharedDirector] pushScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:[MenuLayer scene]]];
    }
    // right hand side, shoot 
    else if (location.x > size.width/2)
    {
        [self shoot];
    }
    else
    {
        if(location.y > 30 && location.y < 265)
            [dragon setPosition:ccp(dragon.position.x, location.y)];  
    }
    
    return YES;
}

-(void) vibateIfEnabled
{
    if( [[NSUserDefaults standardUserDefaults] boolForKey:@"usevibrations"])
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate); 
    }
}

+(CCScene *) sceneWithLevelNo:(int)level;
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	BackgroundLayer *backgroundLayer = [BackgroundLayer node];
    GameLayer *gameLayer = [GameLayer node];
    HUDlayer = [HUDLayer node];
	
	// add layer as a child to scene
	[scene addChild: backgroundLayer];
    [scene addChild: gameLayer];
    [scene addChild: HUDlayer];
	
	// return the scene
	return scene;
}

@end
