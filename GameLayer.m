//
//  GameLayer.m
//  duckhuntcc2d
//
//  Created by Matthew on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "ConveyorBelt.h"


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
        self.isTouchEnabled = NO;
        
        background = [CCSprite spriteWithFile:@"background.jpeg"];
        [background setPosition:ccp(240, 160)];
        [self addChild:background z:0];
        
        ConveyorBelt *cb = [[ConveyorBelt alloc] init];
        [self addChild:cb z:1];
        [cb release];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}
@end
