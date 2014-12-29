//
//  ScrollingNode.m
//  Tappy Plane
//
//  Created by Brian Hoang on 12/28/14.
//  Copyright (c) 2014 Brian Hoang. All rights reserved.
//

#import "ScrollingNode.h"

@implementation ScrollingNode

-(void) updateWithTimesElapsed:(NSTimeInterval)timeElapsed
{
    if(self.scrolling){
    self.position = CGPointMake(self.position.x + (self.horizontalScrollSpeed * timeElapsed), self.position.y);
    }
}

@end
