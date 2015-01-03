//
//  Collectable.m
//  Tappy Plane
//
//  Created by Brian Hoang on 1/3/15.
//  Copyright (c) 2015 Brian Hoang. All rights reserved.
//

#import "Collectable.h"

@implementation Collectable

-(void) collect;
{
    [self runAction:[SKAction removeFromParent]];
    if(self.delegate){
        [self.delegate wasCollected:self];
    }
}


@end
