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

- (id)init
{
    if( self = [super init] ) {
        
        self.isTouchEnabled = YES;
        [self setGameOver:NO];
        
        rightPond = [[NSMutableArray array] retain];
        onBelt = [[NSMutableArray array] retain];
        
        [self setBeltSpeed:5];
        [self setBeltInterval:1];
    }
    
    return self;
}

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

- (void)initializeDucks
{
    for( int i = 0; i < startingDucks; i++ ) {
        MNDuck *duck = [MNDuck newDuck];
        [rightPond addObject:duck];
        [duck addObserver:self forKeyPath:@"hasBeenShot" options:NSKeyValueChangeSetting context:nil];
        [self addChild:duck];
    }
    [self setDeadDucks:0];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // pass on every touch
	return YES;
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
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if( [keyPath isEqualToString:@"hasBeenShot"] ) {
        [self setDeadDucks:[self deadDucks] + 1];
        
        // get rid of duck
        [onBelt removeObject:object];
        [object removeObserver:self forKeyPath:@"hasBeenShot"];
        
        [duckStats setString:[NSString stringWithFormat:@"%d dead %d alive", deadDucks, (startingDucks - deadDucks)]];
        
        if( deadDucks  == (startingDucks) ) {
            [self setGameOver:kGAMEOVERWON];
        }
    }
}

- (void)returnDuck:(MNDuck *)sender
{
    [sender setPosition:ccp( self.contentSize.width + (sender.width / 2), sender.y )];
    [onBelt removeObject:sender];
    [rightPond addObject:sender];
}

- (void)resetWithLevel:(int)level
{
    [rightPond removeAllObjects];
    [onBelt removeAllObjects];
    startingDucks *= level;
    
    [self initializeDucks];
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

- (void)dealloc
{
    [rightPond release];
    [onBelt release];
    [super dealloc];
}

@end
