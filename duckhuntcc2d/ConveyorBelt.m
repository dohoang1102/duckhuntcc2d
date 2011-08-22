//
//  ConveyorBelt.m
//  duckhuntcc2d
//
//  Created by Matthew on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConveyorBelt.h"

#define kGAMEOVERLOST NO
#define kGAMEOVERWON YES

@implementation ConveyorBelt

@synthesize gameOver;

- (id)init
{
    if( self = [super init] ) {
        
        self.isTouchEnabled = YES;
        [self setGameOver:NO];
        startingDucks = 8;
        
        rightPond = [[NSMutableArray array] retain];
        onBelt = [[NSMutableArray array] retain];
        deadDucks = [[NSMutableArray array] retain];
        
        for( int i = 0; i < startingDucks; i++ ) {
            MNDuck *d = [MNDuck newDuck];
            [rightPond addObject:d];
            [d addObserver:self forKeyPath:@"hasBeenShot" options:NSKeyValueChangeSetting context:nil];
            [self addChild:d];
        }
        
        [self schedule:@selector(sendNextDuck:) interval:1];
        [self setGameOver:kGAMEOVERLOST];
    }
    return self;
}

- (void)sendNextDuck:(ccTime)dt
{
    NSLog(@"%d", [rightPond count]);
    
    if( [rightPond count] > 0 ) {
        NSUInteger randomIndex = arc4random() % [rightPond count];
        
        MNDuck *nextDuck = [rightPond objectAtIndex:randomIndex];
        [onBelt addObject:nextDuck];
        
        [rightPond removeObject:nextDuck];
        [nextDuck runAction:[CCSequence actions:
                             [CCMoveTo actionWithDuration:5 position:ccp( 0 - nextDuck.width, nextDuck.y )],
                             [CCCallFuncN actionWithTarget:self selector:@selector(returnDuck:)], nil]];
    }
}

- (void)returnDuck:(MNDuck *)sender
{
    [sender setPosition:ccp( self.contentSize.width + (sender.width / 2), sender.y )];
    [onBelt removeObject:sender];
    [rightPond addObject:sender];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
//    NSLog(@"TOUCH: %@", touch);
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // pass on every touch
	return YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if( [keyPath isEqualToString:@"hasBeenShot"] ) {
        [onBelt removeObject:object];
        [deadDucks addObject:object];
        
        if( [deadDucks count]  == (startingDucks - 1) ) {
            [self setGameOver:kGAMEOVERWON];
        }
    }
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

- (void)dealloc
{
    [rightPond release];
    [onBelt release];
    [super dealloc];
}

@end
