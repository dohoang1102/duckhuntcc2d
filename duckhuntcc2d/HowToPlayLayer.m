//
//  HowToPlayLayer.m
//  duckhuntcc2d
//
//  Created by Matthew on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HowToPlayLayer.h"
#import "MenuLayer.h"
#import "MNDuck.h"

#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"

@implementation HowToPlayLayer

#pragma mark Class

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HowToPlayLayer *layer = [HowToPlayLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

#pragma mark init/dealloc

-(id)init
{
    if( self = [super init] ) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CGSize labelSize;
        
        labelSize.height = 200;
        labelSize.width = 300;
        
        [self performSelectorInBackground:@selector(loadSoundFilesInBackground) withObject:nil];
        
        MNDuck *duck = [MNDuck newDuck];
        [duck setPosition:ccp(70, 275)];
        [duck playAnimation];
        [self addChild:duck z:10];
        
        NSString* desc = NSLocalizedString(@"HowToPlayDesc",
                                 @"The premise is simple. Tap on the ducks as they move across the screen. If they quack and fall, they're dead. If you don't kill all the ducks before the timer is up, you lose.");
        
        CCLabelTTF *lbl = [CCLabelTTF labelWithString:desc dimensions:labelSize alignment:UITextAlignmentCenter
                                             fontName:@"Helvetica" fontSize: 15];
        
        [lbl setPosition:ccp(50 + (winSize.width / 2), 50 + (winSize.height / 2))];
        [self addChild:lbl];
        
        CCMenuItemImage *goBack = [CCMenuItemImage itemFromNormalImage:@"red-button.png" selectedImage:@"blue-button.png" target:self selector:@selector(goBackToMenu:)];
        [goBack setPosition:ccp( 0,-50 )];
        [goBack setScale:0.75];
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:NSLocalizedString(@"Go Back", @"Go Back menu button") fontName:@"Futura-Medium" fontSize:20.0];
        [label setPosition:ccp( goBack.contentSize.width / 2, goBack.contentSize.height / 2 )];
        
        [goBack addChild:label];
        
        CCMenu *gameMenu = [CCMenu menuWithItems:goBack, nil];
        
        [self addChild:gameMenu];
    }
    
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

#pragma mark Menu Events

-(void)goBackToMenu:(id)sender
{
    CCScene *menu = [MenuLayer scene];
    CCTransitionFade *transition = [CCTransitionFade transitionWithDuration:1 scene:menu];
    [[CCDirector sharedDirector] replaceScene:transition];
}

#pragma mark Background

-(void)loadSoundFilesInBackground
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"quack.wav"];
    
    [pool release];
}

@end
