//
//  MenuLayer.m
//  duckhuntcc2d
//
//  Created by Matthew on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuLayer.h"
#import "HowToPlayLayer.h"
#import "GameLayer.h"

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
        CGSize winSize = [[CCDirector sharedDirector] winSize];

        CCMenuItemImage *startGame = [CCMenuItemImage itemFromNormalImage:@"red-button.png" selectedImage:@"blue-button.png" target:self selector:@selector(startGameTapped:)];
        CCMenuItemImage *howToPlay = [CCMenuItemImage itemFromNormalImage:@"red-button.png" selectedImage:@"blue-button.png" target:self selector:@selector(howToPlayTapped:)];
        
        CCLabelTTF *lbl = [CCLabelTTF labelWithString:NSLocalizedString(@"Start Game", @"Start Game menu button") fontName:@"Futura-Medium" fontSize:20.0];
        CCLabelTTF *htp = [CCLabelTTF labelWithString:NSLocalizedString(@"How To Play", @"How To Play menu button") fontName:@"Futura-Medium" fontSize:20.0];
        
        [lbl setPosition:ccp( startGame.contentSize.width / 2, startGame.contentSize.height / 2 )];
        [startGame addChild:lbl];
        
        [htp setPosition:ccp( howToPlay.contentSize.width / 2, howToPlay.contentSize.height / 2 )];
        [howToPlay addChild:htp];
        
        int x = winSize.width / 2;
        int y = winSize.height / 3;
        
        [startGame setPosition:ccp( x, 2*y )];
        [howToPlay setPosition:ccp( x, y )];
        
        CCMenu *gameMenu = [CCMenu menuWithItems:startGame, howToPlay, nil];
        [gameMenu setPosition:CGPointZero];
        
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

-(void)howToPlayTapped:(id)sender
{
    CCScene *howToPlay = [HowToPlayLayer scene];
    CCTransitionFade *transition = [CCTransitionFade transitionWithDuration:1 scene:howToPlay];
    [[CCDirector sharedDirector] replaceScene:transition];
}

-(void)dealloc
{
    [super dealloc];
}

@end
