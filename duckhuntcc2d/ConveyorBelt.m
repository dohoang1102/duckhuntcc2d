//
//  ConveyorBelt.m
//  duckhuntcc2d
//
//  Created by Matthew on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConveyorBelt.h"
#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"

#define kGAMEOVERLOST NO
#define kGAMEOVERWON YES

@implementation ConveyorBelt

@synthesize gameOver;
@synthesize deadDucks;
@synthesize startingDucks;
@synthesize beltSpeed;
@synthesize beltInterval;

#pragma mark init/dealloc

- (id)init
{
    if( self = [super init] ) {
        
        self.isTouchEnabled = YES;
        
        [self setupDuckAnimation];
        [self setGameOver:NO];
        
        rightPond = [[NSMutableArray array] retain];
        onBelt = [[NSMutableArray array] retain];
        
        [self setBeltSpeed:5];
        [self setBeltInterval:1];
    }
    
    return self;
}

- (void)dealloc
{
    [duckAnimation release];
    [rightPond release];
    [onBelt release];
    
    [super dealloc];
}

- (void)setupDuckAnimation
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ducks_default.plist"];
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"ducks_default.png"];
    [self addChild:spriteSheet];
    
    NSMutableArray *duckFrames = [NSMutableArray array];
    for(int i = 0; i <= 8; i++) {
        [duckFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"duck%d.png", i]]];
    }
    for(int i = 7; i >= 0; i--) {
        [duckFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"duck%d.png", i]]];
    }
    
    CCAnimation* _animation = [CCAnimation animationWithFrames:duckFrames delay:0.1f];    
    duckAnimation = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:_animation restoreOriginalFrame:NO]] retain];
}

-(void)registerObserver:(id)object
{
    [self addObserver:object forKeyPath:@"gameOver" options:NSKeyValueChangeSetting context:nil];
    [self addObserver:object forKeyPath:@"deadDucks" options:NSKeyValueChangeSetting context:nil];
    [self addObserver:object forKeyPath:@"removeObserver" options:NSKeyValueChangeSetting context:nil];
}

-(void)unregisterObserver:(id)object
{
    [self removeObserver:object forKeyPath:@"gameOver"];
    [self removeObserver:object forKeyPath:@"deadDucks"];
    [self removeObserver:object forKeyPath:@"removeObserver"];
}

#pragma mark Belt Control

- (void)start
{
    winSize = [[CCDirector sharedDirector] winSize];
    [self initializeDucks];
    [self schedule:@selector(sendNextDuck:) interval:[self beltInterval]];
}

- (void)pause
{
    [self pauseSchedulerAndActions];
}

#pragma mark Set Up

- (void)initializeDucks
{
    for( int i = 0; i < startingDucks; i++ ) {
        MNDuck *duck = [MNDuck newDuck];
        [rightPond addObject:duck];
        [duck registerObserver:self];
        [duck setAnimation:[duckAnimation copy]];
        [self addChild:duck];
    }
    [self setDeadDucks:0];
}

#pragma mark Game Logic

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if( [keyPath isEqualToString:@"hasBeenShot"] ) {
        [self setDeadDucks:[self deadDucks] + 1];
        
        // get rid of duck
        [onBelt removeObject:object];
        [object unregisterObserver:self];
        
        [duckStats setString:[NSString stringWithFormat:
            NSLocalizedString(@"%d dead %d alive", @"Duck Statistics"), deadDucks, (startingDucks - deadDucks)]];
        
        if( deadDucks  == (startingDucks) ) {
            [self setGameOver:kGAMEOVERWON];
        }
    }
    if ( [keyPath isEqualToString:@"removeObservers"] ) {
        [object unregisterObserver:self];
    }
}

- (void)sendNextDuck:(ccTime)dt
{
    if( [rightPond count] > 0 ) {
        NSUInteger randomIndex = arc4random() % [rightPond count];
        NSUInteger randomY = (arc4random() % (int)( winSize.height ) );
        
        MNDuck *nextDuck = [rightPond objectAtIndex:randomIndex];
        [onBelt addObject:nextDuck];
        
        [rightPond removeObject:nextDuck];
        
        [nextDuck runAction:
         [CCSequence actions:
          [CCMoveTo actionWithDuration:[self beltSpeed] position:ccp( 0 - nextDuck.width, randomY )],
          [CCCallFuncN actionWithTarget:self selector:@selector(returnDuck:)],
          nil]
         ];
        [nextDuck playAnimation];
    }
}

- (void)returnDuck:(MNDuck *)sender
{
    [sender stopAnimation];
    [sender setPosition:ccp( self.contentSize.width + (sender.width / 2), sender.y )];
    [onBelt removeObject:sender];
    [rightPond addObject:sender];
}

#pragma mark Touch

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // pass on every touch
	return YES;
}

- (void)onEnter
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}

- (void)onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}

#pragma mark Utilities

// Set the opacity of all of our children that support it
-(void) setOpacity: (GLubyte) opacity
{
    for( CCNode *node in [self children] )
    {
        if( [node conformsToProtocol:@protocol( CCRGBAProtocol)] )
        {
            [(id<CCRGBAProtocol>) node setOpacity: opacity];
        }
    }
}

@end
