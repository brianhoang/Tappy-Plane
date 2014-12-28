//
//  ScrollingNode.m
//  Tappy Plane
//
//  Created by Brian Hoang on 12/27/14.
//  Copyright (c) 2014 Brian Hoang. All rights reserved.
//

#import "ScrollingNode.h"

@implementation ScrollingNode

- (void)updateWithTimeElpased:(NSTimeInterval)timeElapsed
{
    if (self.scrolling) {
        self.position = CGPointMake(self.position.x + (self.horizontalScrollSpeed * timeElapsed), self.position.y);
    }
}
@end
