//
//  ConveyorBelt.h
//  duckhuntcc2d
//
//  Created by Matthew on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MNDuck.h"

@interface ConveyorBelt : CCLayer {
    NSMutableArray *onBelt;
    NSMutableArray *rightPond;
    NSMutableArray *deadDucks;
    int startingDucks;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)returnDuck:(id)sender;
- (void)onEnter;
- (void)onExit;

@property(nonatomic) BOOL gameOver;

@end
