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
    CCLabelTTF *clock;
    CCLabelTTF *duckStats;
    ConveyorBelt *conveyorBeltLayer;
    
    int level;
}

+(CCScene *)scene;
-(void)gameOver:(BOOL)status;
-(void)resetAndIncrementLevel;
-(void)loadSoundFilesInBackground;
-(void)removeConveyorBeltObject;
-(void)updateDuckStats:(id)object withKeyPath:(NSString *)keyPath;

@property int clockValue;

@end
