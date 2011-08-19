//
//  MNDuck.m
//  duckhuntcc2d
//
//  Created by Matthew on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MNDuck.h"


@implementation MNDuck

+(MNDuck *)newDuck
{
    MNDuck *thisDuck = [MNDuck node];
    CCSprite *dImg = [CCSprite spriteWithFile:@"duck.png"];
    [thisDuck addChild:dImg];
    
    return thisDuck;
}

@end
