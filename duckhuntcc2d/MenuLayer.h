//
//  MenuLayer.h
//  duckhuntcc2d
//
//  Created by Matthew on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MenuLayer : CCLayer {

}

+(CCScene *)scene;

-(void)howToPlayTapped:(id)sender;
-(void)startGameTapped:(id)sender;

@end
