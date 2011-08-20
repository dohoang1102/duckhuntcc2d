//
//  MNDuck.m
//  duckhuntcc2d
//
//  Created by Matthew on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MNDuck.h"


@implementation MNDuck

+(MNDuck *)newDuck
{
    MNDuck *duck = [MNDuck spriteWithFile:@"duck.png"];
    [duck setScale:0.5];
    [duck setRandomY];
    [duck setOffscreenRight];
    
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

- (CGRect)rect
{
    CGSize s = [self contentSizeInPixels];
    return CGRectMake(-s.width / 2, -s.height / 2, s.width, s.height);
}

- (BOOL)containsTouchLocation:(UITouch *)touch
{
    NSLog(@"%@", [self convertTouchToNodeSpace:touch]);
    return CGRectContainsPoint(self.rect, [self convertTouchToNodeSpace:touch]);
}

@end
