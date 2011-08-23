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


@implementation GameLayer

@synthesize clockValue;
@synthesize level;

#pragma mark Class

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

#pragma mark init/dealloc

- (id)init
{
    if( self = [super init] ) {
        self.isTouchEnabled = YES;
        
        [self setBackground:@"background.jpeg"];
        [self initLabels];
        
        [self performSelectorInBackground:@selector(loadSoundFilesInBackground) withObject:nil];
        [self resetAndIncrementLevel];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark Set Up

- (void)initConveyorBeltLayerWithStartingDucks:(int)ducks beltSpeed:(float)beltSpeed beltInterval:(float)beltInterval
{
    conveyorBeltLayer = [[ConveyorBelt alloc] init];
    [conveyorBeltLayer setStartingDucks:ducks];
    [conveyorBeltLayer setBeltSpeed:beltSpeed];
    [conveyorBeltLayer setBeltInterval:beltInterval];
    [self addChild:conveyorBeltLayer z:1];
    [conveyorBeltLayer addObserver:self forKeyPath:@"gameOver" options:NSKeyValueChangeSetting context:nil];
    [conveyorBeltLayer addObserver:self forKeyPath:@"deadDucks" options:NSKeyValueChangeSetting context:nil];
}

- (void)initLabels
{
    clockLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%04d", self.clockValue]
                                    fontName:@"Helvetica" fontSize:18];
    [clockLabel setColor:ccc3(0,0,0)];
    [clockLabel setPosition:ccp(25, 310)];
    [self addChild:clockLabel];
    
    levelLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level %d", self.level]
                                    fontName:@"Helvetica" fontSize:18];
    [levelLabel setColor:ccc3(0,0,0)];
    [levelLabel setPosition:ccp(240, 310)];
    [self addChild:levelLabel];
    
    duckStatsLabel = [CCLabelTTF labelWithString:
                      [NSString stringWithFormat:NSLocalizedString(@"%d dead %d alive", @"Duck Stats"), 0, 0]
                                        fontName:@"Helvetica"
                                        fontSize:18];
    [duckStatsLabel setPosition:ccp( 400, 310 )];
    [duckStatsLabel setColor:ccc3(0,0,0)];
    [self addChild:duckStatsLabel];
}

-(void)setBackground:(NSString *)newBackground
{
    [self removeChild:background cleanup:YES];
    [background release];
    
    background = [CCSprite spriteWithFile:newBackground];
    [background setPosition:ccp(240, 160)];
    [self addChild:background z:0];
}

# pragma mark Reset

- (void)resetAndIncrementLevel
{
    int startDucks = 15, timer = 20; float beltSpeed = 5, beltInterval = 1;
    
    level++;
    
    if ( level == 2 ) {
        timer = 40;
        startDucks = 40;
        beltSpeed = 4;
        beltInterval = 0.75;
    }
    else if( level == 3 || level == 0 ) {
        CCScene* menuScene = [MenuLayer scene];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:menuScene]];
        return;
    }
    
    [self removeChildByTag:2 cleanup:true];
    [self resetLabels];
    [self initConveyorBeltLayerWithStartingDucks:startDucks beltSpeed:beltSpeed beltInterval:beltInterval];
    [self setClockValue:timer];
    
    [self schedule:@selector(tick:) interval:1];
    [conveyorBeltLayer start];
}


- (void)resetLabels
{
    [clockLabel setColor:ccc3(0,0,0)];
    [clockLabel setString:[NSString stringWithFormat:@"%04d", self.clockValue]];
    [levelLabel setString:[NSString stringWithFormat:@"Level %d", self.level]];
    [duckStatsLabel setString:[NSString stringWithFormat:NSLocalizedString(@"%d dead %d alive", @"Duck Stats"), 0, 0]];
}

-(void)removeConveyorBeltObject
{
    [self removeChild:conveyorBeltLayer cleanup:YES];
    [conveyorBeltLayer release]; //also release its children
    conveyorBeltLayer = nil;
}

#pragma mark Game Play and Logic

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self resetAndIncrementLevel];
}

- (void)tick:(ccTime)dt
{
    self.clockValue -= 1;
    [clockLabel setString:[NSString stringWithFormat:@"%04d", self.clockValue]];
    
    if (self.clockValue > 15)
        [clockLabel setColor:ccc3(0, 0, 0)];
    else if ( self.clockValue == 15 )
        [clockLabel setColor:ccc3(255, 140, 0)];
    else if( self.clockValue == 10 )
        [clockLabel setColor:ccc3(255,0,0)];
    else if ( self.clockValue <= 0 )
        [self gameOver:kGAMEOVERLOST];
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
    
    // set level = -1 to prevent continued gameplay
    if( !status ) level = -1;
    
    // set up "Game Over" label + fade-in
    NSString *msg = status ? 
        NSLocalizedString(@"Game Over :) You Win!", @"Game Over - You Win Message") :
        NSLocalizedString(@"Game Over :( You Lose", @"Game Over - You Lost Message");
    [[SimpleAudioEngine sharedEngine] playEffect: status ? @"bell.wav" : @"buzz.wav" ];
    
    CCLabelTTF *label = [CCLabelTTF labelWithString:msg fontName:@"Futura-Medium" fontSize:20];
    [label setPosition:ccp( winSize.width / 2, winSize.height / 2)];
    [label setOpacity:0];
    [label setTag:2];
    [self addChild:label z:10];
    
    // fade in message; fade out ducks, ultimately remove and release
    // conveyor belt and its children.
    [label runAction:[CCFadeIn actionWithDuration:1]];
    [conveyorBeltLayer runAction:[CCSequence actions:[CCFadeOut actionWithDuration:1], [CCCallFunc actionWithTarget:self selector:@selector(removeConveyorBeltObject)], nil]];
}

-(void)updateDuckStats:(id)object withKeyPath:(NSString *)keyPath
{
    [duckStatsLabel setString:[NSString stringWithFormat: NSLocalizedString(@"%d dead %d alive", @"Duck Statistics Format String"),
                         [conveyorBeltLayer deadDucks],
                          ([conveyorBeltLayer startingDucks] - [conveyorBeltLayer deadDucks])]];
}


#pragma mark Background

-(void)loadSoundFilesInBackground
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
     
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"quack.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"bell.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"buzz.wav"];
    
    [pool release];
}

@end
