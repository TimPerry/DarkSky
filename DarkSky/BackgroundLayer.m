
#import "BackgroundLayer.h"

@implementation BackgroundLayer

-(id)init {
    self = [super init];
    if (self) {
        
        // add the background and loop it
        CGSize size = [[CCDirector sharedDirector] winSize];
        size.width *= 2;
        
        CCTexture2D *bg = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:@"darkbg.png"]];
        
        CCSprite *staticBackground0 = [CCSprite spriteWithTexture:bg];
        staticBackground0.position = ccp(size.width+479,size.height/2);
        CCSprite *staticBackground1 = [CCSprite spriteWithTexture:bg];
        staticBackground1.position = ccp(size.width/2+1,size.height/2);
        
        CCSprite *staticBackground = [[CCSprite alloc] init];
        [staticBackground addChild:staticBackground0];
        [staticBackground addChild:staticBackground1];
        [self addChild:staticBackground];
        
        id a1 = [CCMoveBy actionWithDuration:3.0f position:ccp(-size.width,0)];
        id a2 = [CCPlace actionWithPosition:ccp(0,0)];
        id seq = [CCSequence actions:a1, a2, nil];
        [staticBackground runAction:[CCRepeatForever actionWithAction: seq]];

    
    }
    return self;
     
}

@end
