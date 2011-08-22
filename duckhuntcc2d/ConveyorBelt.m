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

- (id)init
{
    if( self = [super init] ) {
        
        self.isTouchEnabled = YES;
        [self setGameOver:NO];
        startingDucks = 8;
        
        rightPond = [[NSMutableArray array] retain];
        onBelt = [[NSMutableArray array] retain];
        deadDucks = 0;

        [self initializeDucks];
        
        duckStats = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d dead %d alive", deadDucks, (startingDucks - deadDucks)] fontName:@"Helvetica" fontSize:18];
        [duckStats setPosition:ccp( 400, 310 )];
        [duckStats setColor:ccc3(0,0,0)];
        [self addChild:duckStats];
        
        [self schedule:@selector(sendNextDuck:) interval:1];
    }
    
    return self;
}

- (void)initializeDucks
{
    for( int i = 0; i < startingDucks; i++ ) {
        MNDuck *duck = [MNDuck newDuck];
        [rightPond addObject:duck];
        [duck addObserver:self forKeyPath:@"hasBeenShot" options:NSKeyValueChangeSetting context:nil];
        [self addChild:duck];
    }
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // pass on every touch
	return YES;
}

- (void)sendNextDuck:(ccTime)dt
{
    NSLog(@"%d", [rightPond count]);
    
    if( [rightPond count] > 0 ) {
        NSUInteger randomIndex = arc4random() % [rightPond count];
        
        MNDuck *nextDuck = [rightPond objectAtIndex:randomIndex];
        [onBelt addObject:nextDuck];
        
        [rightPond removeObject:nextDuck];
        
        [nextDuck runAction:
         [CCSequence actions:
          [CCMoveTo actionWithDuration:5 position:ccp( 0 - nextDuck.width, nextDuck.y )],
          [CCCallFuncN actionWithTarget:self selector:@selector(returnDuck:)],
          nil]
        ];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if( [keyPath isEqualToString:@"hasBeenShot"] ) {
        deadDucks++;
        
        // get rid of duck
        [object quack];
        [onBelt removeObject:object];
        [object removeObserver:self forKeyPath:@"hasBeenShot"];
        [object release];
        
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

- (void)dealloc
{
    [rightPond release];
    [onBelt release];
    [super dealloc];
}

@end
