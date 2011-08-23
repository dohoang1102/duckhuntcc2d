//
//  HowToPlayLayer.h
//  duckhuntcc2d
//
//  Created by Matthew on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HowToPlayLayer : CCLayer {
    
}

+(CCScene *)scene;

-(void)loadSoundFilesInBackground;
-(void)goBackToMenu:(id)sender;


@end
