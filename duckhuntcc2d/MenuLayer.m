//
//  MenuLayer.m
//  duckhuntcc2d
//
//  Created by Matthew on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuLayer.h"
#import "GameLayer.h";


@implementation MenuLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuLayer *layer = [MenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id)init
{
    if( self = [super init] ) {
        CCMenuItemImage *startGame = [CCMenuItemImage itemFromNormalImage:@"red-button.png" selectedImage:@"blue-button.png" target:self selector:@selector(startGameTapped:)];
        CCLabelTTF *lbl = [CCLabelTTF labelWithString:@"Start Game" fontName:@"Futura-Medium" fontSize:20.0];
    
        lbl.position = ccp( 195.0f, 43.0f );
        [startGame addChild:lbl];
        
        CCMenu *gameMenu = [CCMenu menuWithItems:startGame, nil];
        
        [self addChild:gameMenu];
    }
    return self;
}

-(void)startGameTapped:(id)sender
{
    CCScene *gameScene = [GameLayer scene];
    CCTransitionZoomFlipAngular *transition = [CCTransitionZoomFlipAngular transitionWithDuration:0.5 scene:gameScene];
    [[CCDirector sharedDirector] replaceScene:transition];
}

-(void)dealloc
{
    [super dealloc];
}

@end
