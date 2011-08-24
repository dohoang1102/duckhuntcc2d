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
@synthesize animation;
@synthesize removeObservers;

#pragma mark Class

+(MNDuck *)newDuck
{
    MNDuck *duck = [[MNDuck spriteWithFile:@"duck.png"] retain];
    [duck setRandomY];
    [duck setOffscreenRight];
    [duck setHasBeenShot:false];
    
    return duck;
}

#pragma mark init/dealloc

-(id)init
{
    if(self = [super init]){

    }
    return self;
}

-(void)dealloc
{
    [animation release];
    animation = nil;
    
    [self setRemoveObservers:true];
    
    [super dealloc];
}

-(void)registerObserver:(id)object
{
    [self addObserver:object forKeyPath:@"hasBeenShot" options:NSKeyValueChangeSetting context:nil];
    [self addObserver:object forKeyPath:@"removeObserver" options:NSKeyValueChangeSetting context:nil];
}

-(void)unregisterObserver:(id)object
{
    [self removeObserver:object forKeyPath:@"hasBeenShot"];
    [self removeObserver:object forKeyPath:@"removeObserver"];
}

-(void)playAnimation
{
    if ( [self animation] != nil ) {
        [self runAction:[self animation]];
    }
}

-(void)stopAnimation
{
    [self stopAction:animation];
}

#pragma mark Postioning

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

#pragma mark Size

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
	CGSize s = [self contentSizeInPixels];
	return CGRectMake(-s.width / 2, -s.height / 2, s.width, s.height);
}

- (CGRect)rect
{
	CGSize s = [self contentSize];
	return CGRectMake(-s.width / 2, -s.height / 2, s.width, s.height);
}

#pragma mark Touch

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

#pragma mark Logic/Actions

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
