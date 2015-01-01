//
//  ObstacleLayer.h
//  Tappy Plane
//
//  Created by Brian Hoang on 12/31/14.
//  Copyright (c) 2014 Brian Hoang. All rights reserved.
//

#import "ScrollingNode.h"

@interface ObstacleLayer : ScrollingNode

@property (nonatomic) CGFloat floor;
@property (nonatomic) CGFloat ceiling;

-(void)reset;

@end
