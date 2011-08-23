//
//  MNDuck.h
//  duckhuntcc2d
//
//  Created by Matthew on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MNDuck : CCSprite<CCTargetedTouchDelegate> {
    
}

#pragma mark Class
+(MNDuck *)newDuck;

-(void)playAnimation;
-(void)stopAnimation;

#pragma mark Positioning
-(void)setOffscreenRight;
-(void)setRandomY;

#pragma mark Size
-(CGFloat)width;
-(CGFloat)height;
-(CGFloat)x;
-(CGFloat)y;
-(CGRect)rect;
-(CGRect)rectInPixels;
-(BOOL)containsTouchLocation:(UITouch *)touch;

#pragma mark Touch
-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
-(void)onEnter;
-(void)onExit;

#pragma mark Logic/Action
-(void)shoot;
-(void)quack;

#pragma mark Background
-(void)setupAnimation;

#pragma mark -
#pragma mark Properties
@property(nonatomic) BOOL hasBeenShot;
@property(nonatomic, retain) CCAction *animation;

@end
