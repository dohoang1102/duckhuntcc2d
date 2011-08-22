//
//  GameLayer.m
//  duckhuntcc2d
//
//  Created by Matthew on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "ConveyorBelt.h"

#define kGAMEOVERLOST NO
#define kGAMEOVERWON YES


@implementation GameLayer

@synthesize clockValue;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id)init
{
    if( self = [super init] ) {
        self.isTouchEnabled = YES;
        [self setClockValue:16];
        
        background = [CCSprite spriteWithFile:@"background.jpeg"];
        [background setPosition:ccp(240, 160)];
        [self addChild:background z:0];
        
        clock = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%04d", self.clockValue]
                                   fontName:@"Helvetica" fontSize:18];
        [clock setColor:ccc3(0,0,0)];
        [clock setPosition:ccp(25, 310)];
        [self addChild:clock z:10];
        
        conveyorBeltLayer = [[ConveyorBelt alloc] init];
        [self addChild:conveyorBeltLayer z:1];
        [conveyorBeltLayer addObserver:self forKeyPath:@"gameOver" options:NSKeyValueChangeSetting context:nil];
        
        [self schedule:@selector(tick:) interval:1];
    }
    
    return self;
}

- (void)tick:(ccTime)dt
{
    self.clockValue -= 1;
    [clock setString:[NSString stringWithFormat:@"%04d", self.clockValue]];
    
    if ( self.clockValue == 15 )
        [clock setColor:ccc3(255, 140, 0)];
    else if( self.clockValue == 10 )
        [clock setColor:ccc3(255,0,0)];
    
    if ( self.clockValue <= 0 )
        [self gameOver:kGAMEOVERLOST];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touch Layer");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if( [keyPath isEqualToString:@"gameOver"] ) {
        [self gameOver:[object valueForKey:keyPath]];
    }
}

-(void)gameOver:(BOOL)status
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // stop clock
    [self unschedule:@selector(tick:)];
    
    // stop conveyor belt; avoid multiple messages being sent
    [conveyorBeltLayer unscheduleAllSelectors];
    [conveyorBeltLayer stopAllActions];
    
    // set up "Game Over" label + fade-in
    NSString *msg = status ? @"Game Over :) You Win!" : @"Game Over :( You Lose";
    
    CCLabelTTF *label = [CCLabelTTF labelWithString:msg fontName:@"Futura-Medium" fontSize:20];
    [label setPosition:ccp( winSize.width / 2, winSize.height / 2)];
    [label setOpacity:0];
    [self addChild:label];
    
    [label runAction:[CCFadeIn actionWithDuration:1.0]];
}

- (void)dealloc
{
    [super dealloc];
}

@end
