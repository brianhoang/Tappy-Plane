//
//  ScrollingNode.h
//  Tappy Plane
//
//  Created by Brian Hoang on 12/27/14.
//  Copyright (c) 2014 Brian Hoang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


@interface ScrollingNode : SKNode
@property (nonatomic) BOOL scrolling;

//how fast to scroll per second
@property (nonatomic) CGFloat horizontalScrollSpeed; // Distance to scroll per second.
- (void)updateWithTimeElpased:(NSTimeInterval)timeElapsed;
@end
