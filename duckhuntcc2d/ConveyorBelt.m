//
//  ConveyorBelt.m
//  duckhuntcc2d
//
//  Created by Matthew on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConveyorBelt.h"

@implementation ConveyorBelt

- (id)init
{
    if( self = [super init] ) {
        
        self.isTouchEnabled = YES;
        
        rightPond = [[NSMutableArray arrayWithObjects:[MNDuck newDuck], [MNDuck newDuck], [MNDuck newDuck], [MNDuck newDuck],
                      [MNDuck newDuck], [MNDuck newDuck], [MNDuck newDuck], nil] retain];
        onBelt = [[NSMutableArray array] retain];
        
        for( MNDuck* d in rightPond ) {
            [self addChild:d];
        }
        
        [self schedule:@selector(sendNextDuck:) interval:1];
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
    NSLog(@"TOUCH: %@", touch);
    for( MNDuck *d in onBelt ) {
        if( [d containsTouchLocation:touch] ) {
            NSLog(@"DON'T TOUCH ME");
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
