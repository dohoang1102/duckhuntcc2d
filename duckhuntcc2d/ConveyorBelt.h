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
    CCLabelTTF *duckStats;
    CGSize winSize;
    
    CCAction *duckAnimation;
}

-(void)registerObserver:(id)object;
-(void)unregisterObserver:(id)object;
-(void)setupDuckAnimation;

#pragma mark Belt Control
- (void)start;
- (void)pause;

#pragma mark Setup
- (void)initializeDucks;

#pragma mark Game Logic
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
- (void)returnDuck:(id)sender;

#pragma mark Game Touch
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)onEnter;
- (void)onExit;

#pragma mark Game Utilities
- (void)setOpacity: (GLubyte) opacity;

#pragma mark -
#pragma mark Properties
@property(nonatomic) BOOL   gameOver;
@property(nonatomic) int    deadDucks;
@property(nonatomic) int    startingDucks;
@property(nonatomic) int    beltSpeed;
@property(nonatomic) float  beltInterval;

@end
