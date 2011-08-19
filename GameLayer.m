//
//  GameLayer.m
//  duckhuntcc2d
//
//  Created by Matthew on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "MNDuck.h"


@implementation GameLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id)init
{
    if( self = [super init] ) {
        background = [CCSprite spriteWithFile:@"background.jpeg"];
        [background setPosition:ccp(240, 160)];
        [self addChild:background];
        
        MNDuck *firstDuck = [MNDuck newDuck];
        [firstDuck setScale:0.5];
        [firstDuck setPosition:ccp(195, 43)];
        
        [self addChild:firstDuck];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
