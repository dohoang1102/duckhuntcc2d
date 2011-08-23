//
//  MNDuck.m
//  duckhuntcc2d
//
//  Created by Matthew on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MNDuck.h"
#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"

@implementation MNDuck

@synthesize hasBeenShot;

+(MNDuck *)newDuck
{
    MNDuck *duck = [MNDuck spriteWithFile:@"duck.png"];
    [duck setScale:0.5];
    [duck setRandomY];
    [duck setOffscreenRight];
    [duck setHasBeenShot:false];
    
    return duck;
}

-(void)setOffscreenRight
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    [self setPosition:ccp( winSize.width + self.width / 2, self.position.y )];
}

-(void)setRandomY
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    float bound = (self.height / 2);
    float newY = (arc4random() % (int)( winSize.height - bound - bound ) ) + bound;
    
    [self setPosition:ccp( self.position.x, newY)];
}

-(CGFloat)width
{
    return [self boundingBox].size.width;
}

-(CGFloat)height
{
    return [self boundingBox].size.height;
}

-(CGFloat)x
{
    return self.position.x;
}

-(CGFloat)y
{
    return self.position.y;
}

- (CGRect)rectInPixels
{
	CGSize s = [texture_ contentSizeInPixels];
	return CGRectMake(-s.width / 2, -s.height / 2, s.width, s.height);
}

- (CGRect)rect
{
	CGSize s = [texture_ contentSize];
	return CGRectMake(-s.width / 2, -s.height / 2, s.width, s.height);
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if( hasBeenShot ) return;
    [self shoot];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ( ![self containsTouchLocation:touch] ) return NO;
    return YES;
}

- (BOOL)containsTouchLocation:(UITouch *)touch
{
	CGPoint p = [self convertTouchToNodeSpaceAR:touch];
	CGRect r = [self rectInPixels];
	return CGRectContainsPoint(r, p);
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

- (void)shoot
{
    [self quack];
    [self setHasBeenShot:YES];
    [self stopAllActions];
    [self runAction:[CCMoveTo actionWithDuration:0.2 position:ccp([self x], -100)]];
}

- (void)quack
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"quack.wav"];
}

@end
