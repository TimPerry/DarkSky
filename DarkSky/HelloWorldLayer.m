//
//  HelloWorldLayer.m
//  DarkSky
//
//  Created by TIM PERRY on 13/09/2011.
//  Copyright TPN.Net 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];

        // add the prompt
        promptScreen = [CCSprite spriteWithFile: @"promptstart.png"];
        promptScreen.position = ccp(size.width/2, size.height/2);
        [self addChild:promptScreen];
        
        self.isTouchEnabled = true;

    }
	return self;
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
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    int min = 50;
    int max = size.height-10;
    int r = 0;
    
    r = ((arc4random() % max) + min);
    
    Arrow *arrow = [[Arrow alloc] init];
    arrow.position = ccp(size.width, r);
    
    [self addChild:arrow];
    [arrowList addObject:arrow];
    
    id moveOffScreen = [CCMoveTo actionWithDuration:3.0f position:ccp(-50, r)];
    
    [arrow runAction:moveOffScreen];
    
}

-(void) shoot
{
    
    if (firepower.percentage > 0)
    {
        
        if (fireList == nil)
            fireList = [[NSMutableArray alloc]initWithCapacity:0];
        
        Fireball *fireball = [[Fireball alloc] init];

        [self addChild:fireball];
        [self decrementFirePowerBy: 10.0f];
        
        fireball.position = dragon.position;
        fireball.position = ccpAdd(ccp( 50 ,0), fireball.position);
        [fireList addObject:fireball];

        id moveOffScreen = [CCMoveBy actionWithDuration:2.0f position:ccp(600, 0)];
        
        [fireball runAction:moveOffScreen];
    }
    
}

-(void) incrementScoreBy: (int) amount
{
    score += amount;
    [scoreLabel setString:[NSString stringWithFormat:@"%i", score]];
}

-(void) decrementHealthBarBy:(float) amount
{
    healthBar.percentage -= amount; 
}

-(void) incrementHealthBarBy:(float) amount
{
    healthBar.percentage += amount; 
}

-(void) decrementFirePowerBy:(float) amount
{
    firepower.percentage -= amount; 
}

-(void) incrementFirePowerBy:(float) amount
{
    firepower.percentage += amount; 
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (void) setupScene
{    
    
    [self makeItRain];
    
    //Initializing a sprite with the first frame from plist
    dragon = [CCSprite spriteWithFile:@"dragon.png" rect:CGRectMake(0, 0, 78, 78)];
    dragon.position = ccp( 55, 150 );
    [self addChild:dragon];
    dragonAnimStage = 0;

    [promptScreen setVisible:NO];
    
    
    // shoot an arrow every 0.5 seconds
    [self schedule:@selector(step:) interval:0.5];
    
    /*
    specialArrowType = false;
    // shoot a speical arrow every 5 seconds
    [self schedule:@selector(shootSpeicalArrow:) interval:5.0];
    
    //check for collisions    
    [self schedule:@selector(checkForCollisions:) interval:1.0/60];
        
    // regenerate the fire power
    [self schedule:@selector(regenFirePower:) interval:2.5];
    */
    
    // add the menu
    menuTop = [CCSprite spriteWithFile: @"menu.png"];
    menuTop.position = ccp( 185, 300 );
    [self addChild:menuTop];
    
    // add the health bar
    healthBar = [[HealthBar alloc] init];
    [self addChild:healthBar];
    healthBar.position = ccp( 72, 304 );
    
    // add the fire power bar
    firepower = [CCProgressTimer progressWithFile:@"healthbar.png"];
    firepower.type = kCCProgressTimerTypeHorizontalBarLR;
    firepower.percentage = 100.0f;
    [self addChild:firepower];
    firepower.position = ccp( 186, 304 );
      
    score = 0;
    scoreLabel = [CCLabelAtlas labelWithString:@"0" charMapFile:@"fps_images.png" itemWidth:16 itemHeight:24 startCharMap:'.'];
    [scoreLabel setPosition:ccp(300, 294)];
    [self addChild:scoreLabel];

}

// Main loop of the application
-(void) step:(ccTime)delta
{
    [self fireArrow];
}

-(void) shootSpeicalArrow:(ccTime)delta
{
    if (arrowList == nil)
        arrowList = [[NSMutableArray alloc] initWithCapacity:0];

    SpecialArrow *specialArrow;
    if (specialArrowType)
    {
        specialArrow = [[SpecialFireWallArrow alloc ] init];
    }
    else
    {        
        specialArrow = [[SpecialHealthArrow alloc ] init];
    }
    specialArrowType = !specialArrowType;
    
    [self addChild:specialArrow];
    [arrowList addObject:specialArrow];
    
    id moveOffScreen = [CCMoveTo actionWithDuration:3.0f position:ccp(-50, specialArrow.position.y)];
    
    [specialArrow runAction:moveOffScreen];
}

-(void) regenFirePower: (ccTime)delta
{
    if ([firepower percentage] < 100)
    {
        [firepower setPercentage:firepower.percentage+10.0f];
    }
}

-(void) checkForCollisions:(ccTime)delta
{
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGRect viewport = CGRectMake(0,0, winSize.width, winSize.height);
    CGRect dragonRecs = [dragon boundingBox];

    // check for collisions
    for(int i=0; i<[arrowList count]; i++)
    {
        CCSprite *arrow = [arrowList objectAtIndex:i];
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
            
            [self decrementHealthBarBy:5.0f];
            
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
                
                fireRecs.size.height = 40;
                fireRecs.size.width = 60;
                
                //NSLog(@"FIREBALL - H: %f W: %f X: %f Y: %f ", fireRecs.size.height, fireRecs.size.width,  fireRecs.origin.x, fireRecs.origin.y);
                //NSLog(@"ARROW - H: %f W: %f X: %f Y: %f ", arrowRects.size.height, arrowRects.size.width,  arrowRects.origin.x, arrowRects.origin.y);
                
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
                    
                    [self incrementScoreBy:1.0f];
                    
                    NSLog(@"TAG: %i", [arrow tag]);
                    
                    if (arrow.tag == 1)
                    {
                        [self incrementHealthBarBy: 10.0f];
                    }
                    else if (arrow.tag == 2)
                    {
                        [self enableFireWallSP];
                    }
                    
                    //NSLog(@"fireball hit arrow");
                    
                    break;
                    
                    
                }
            }
        }
    }
}

-(void) enableFireWallSP
{
    hasFireWallSP = true;
    if (fireWallOverlay == nil)
    {
        fireWallOverlay = [CCSprite spriteWithFile:@"fireWallOverlay.png"];
        fireWallOverlay.position = ccp(128, 300);
    }
    [self addChild: fireWallOverlay];
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [self convertTouchToNodeSpace: touch];
    [dragon setPosition:ccp(dragon.position.x, location.y)];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    if (![promptScreen visible])
    {
        CGSize size = [[CCDirector sharedDirector] winSize];
        CGPoint location = [self convertTouchToNodeSpace: touch];
        
        // right hand side, shoot 
        if (location.x > size.width/2)
        {
            [self shoot];
        }
        else
        {
            //id moveToTouch = [CCMoveTo actionWithDuration:1.0f position:ccp(dragon.position.x, location.y)];
            //[dragon runAction:moveToTouch];
        }
    }
    else
    {
        [self setupScene];
    }
    
    return YES;
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
