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
}

- (void)initializeDucks;
- (void)resetWithLevel:(int)level;
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
- (void)returnDuck:(id)sender;
- (void)setOpacity: (GLubyte) opacity;
- (void)start;
- (void)pause;
- (void)onEnter;
- (void)onExit;

@property(nonatomic) BOOL   gameOver;
@property(nonatomic) int    deadDucks;
@property(nonatomic) int    startingDucks;
@property(nonatomic) int    beltSpeed;
@property(nonatomic) float  beltInterval;

@end
