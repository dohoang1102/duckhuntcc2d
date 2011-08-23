//
//  GameLayer.m
//  duckhuntcc2d
//
//  Created by Matthew on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "MenuLayer.h"
#import "ConveyorBelt.h"

#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"

#define kGAMEOVERLOST NO
#define kGAMEOVERWON YES
#define kDUCKSTATS @"%d dead %d alive"


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
        level = 1;
        [self setClockValue:30];
        
        background = [CCSprite spriteWithFile:@"background.jpeg"];
        [background setPosition:ccp(240, 160)];
        [self addChild:background z:0];
        
        clock = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%04d", self.clockValue]
                                   fontName:@"Helvetica" fontSize:18];
        [clock setColor:ccc3(0,0,0)];
        [clock setPosition:ccp(25, 310)];
        [self addChild:clock z:10];
        
        conveyorBeltLayer = [[ConveyorBelt alloc] init];
        [conveyorBeltLayer setStartingDucks:30];
        [conveyorBeltLayer setBeltSpeed:3];
        [conveyorBeltLayer setBeltInterval:0.5];
        [self addChild:conveyorBeltLayer z:1];
        [conveyorBeltLayer addObserver:self forKeyPath:@"gameOver" options:NSKeyValueChangeSetting context:nil];
        [conveyorBeltLayer addObserver:self forKeyPath:@"deadDucks" options:NSKeyValueChangeSetting context:nil];
        
        duckStats = [CCLabelTTF labelWithString:
                     [NSString stringWithFormat:@"%d dead %d alive", [conveyorBeltLayer deadDucks],
                      ([conveyorBeltLayer startingDucks] - [conveyorBeltLayer deadDucks])] 
                                       fontName:@"Helvetica"
                                       fontSize:18];
        [duckStats setPosition:ccp( 400, 310 )];
        [duckStats setColor:ccc3(0,0,0)];
        [self addChild:duckStats];
        
        [self performSelectorInBackground:@selector(loadSoundFilesInBackground) withObject:nil];
        [self schedule:@selector(tick:) interval:1];
        [conveyorBeltLayer start];
    }
    
    return self;
}

- (void)resetAndIncrementLevel
{
    level++;
    [conveyorBeltLayer resetWithLevel:level];
}

- (void)tick:(ccTime)dt
{
    self.clockValue -= 1;
    [clock setString:[NSString stringWithFormat:@"%04d", self.clockValue]];
    
    if ( self.clockValue == 15 )
        [clock setColor:ccc3(255, 140, 0)];
    else if( self.clockValue == 10 )
        [clock setColor:ccc3(255,0,0)];
    else if ( self.clockValue <= 0 )
        [self gameOver:kGAMEOVERLOST];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CCScene* menuScene = [MenuLayer scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:menuScene]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object change:(NSDictionary *)change 
                       context:(void *)context
{
    if( [keyPath isEqualToString:@"gameOver"] ) {
        [self gameOver:(BOOL)[object valueForKey:keyPath]];
    }
    else if( [keyPath isEqualToString:@"deadDucks"] ) {
        [self updateDuckStats:object withKeyPath:keyPath];
    }
}

-(void)gameOver:(BOOL)status
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // stop clock
    [self unschedule:@selector(tick:)];
    
    // stop conveyor belt; avoid multiple messages being sent
    [conveyorBeltLayer pause];
    
    // set up "Game Over" label + fade-in
    NSString *msg = status ? 
        NSLocalizedString(@"Game Over :) You Win!", @"Game Over - You Win Message") :
        NSLocalizedString(@"Game Over :( You Lose", @"Game Over - You Lost Message");
    [[SimpleAudioEngine sharedEngine] playEffect: status ? @"bell.wav" : @"buzz.wav" ];
    
    CCLabelTTF *label = [CCLabelTTF labelWithString:msg fontName:@"Futura-Medium" fontSize:20];
    [label setPosition:ccp( winSize.width / 2, winSize.height / 2)];
    [label setOpacity:0];
    [self addChild:label z:10];
    
    // fade in message; fade out ducks, ultimately remove and release
    // conveyor belt and its children.
    [label runAction:[CCFadeIn actionWithDuration:1]];
    [conveyorBeltLayer runAction:[CCSequence actions:[CCFadeOut actionWithDuration:1], [CCCallFunc actionWithTarget:self selector:@selector(removeConveyorBeltObject)], nil]];
}

-(void)updateDuckStats:(id)object withKeyPath:(NSString *)keyPath
{
    [duckStats setString:[NSString stringWithFormat: NSLocalizedString(@"%d dead %d alive", @"Duck Statistics Format String"),
                         [conveyorBeltLayer deadDucks],
                          ([conveyorBeltLayer startingDucks] - [conveyorBeltLayer deadDucks])]];
}

-(void)removeConveyorBeltObject
{
    [self removeChild:conveyorBeltLayer cleanup:YES];
    [conveyorBeltLayer release]; //also release its children
}

-(void)loadSoundFilesInBackground
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
     
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"quack.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"bell.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"buzz.wav"];
    
    [pool release];
}

- (void)dealloc
{
    [super dealloc];
}

@end
