//
//  GameLayer.h
//  duckhuntcc2d
//
//  Created by Matthew on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ConveyorBelt.h"

@interface GameLayer : CCLayer {
    CCSprite *background;
    CCLabelTTF *clockLabel;
    CCLabelTTF *duckStatsLabel;
    CCLabelTTF *levelLabel;
    ConveyorBelt *conveyorBeltLayer;
}

#pragma mark Class
+(CCScene *)scene;

#pragma mark Set Up
-(void)initLabels;
-(void)initConveyorBeltLayerWithStartingDucks:(int)ducks beltSpeed:(float)beltSpeed beltInterval:(float)beltInterval;
-(void)setBackground:(NSString *)newBackground;

#pragma mark Reset
-(void)resetAndIncrementLevel;
-(void)resetLabels;
-(void)removeConveyorBeltObject;

#pragma mark Game Play and Logic
-(void)updateDuckStats:(id)object withKeyPath:(NSString *)keyPath;
-(void)gameOver:(NSNumber *)istatus;

#pragma mark Background
-(void)loadSoundFilesInBackground;

#pragma mark -
#pragma mark Properties
@property(nonatomic) int clockValue;
@property(nonatomic) int level;

@end
