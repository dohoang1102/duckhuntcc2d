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

+(MNDuck *)newDuck;

-(void)setOffscreenRight;
-(void)setRandomY;

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;

-(CGRect)rect;
-(CGRect)rectInPixels;
-(BOOL)containsTouchLocation:(UITouch *)touch;
-(void)onEnter;
-(void)onExit;

-(void)shoot;
-(void)quack;

-(CGFloat)width;
-(CGFloat)height;
-(CGFloat)x;
-(CGFloat)y;

@property(nonatomic) BOOL hasBeenShot;

@end
