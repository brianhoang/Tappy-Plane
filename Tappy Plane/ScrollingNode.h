//
//  ScrollingNode.h
//  Tappy Plane
//
//  Created by Brian Hoang on 12/28/14.
//  Copyright (c) 2014 Brian Hoang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ScrollingNode : SKNode

//distance to scroll per second
@property (nonatomic) CGFloat horizontalScrollSpeed;
@property (nonatomic) BOOL scrolling;

-(void)updateWithTimesElapsed: (NSTimeInterval) timeElapsed;
@end
