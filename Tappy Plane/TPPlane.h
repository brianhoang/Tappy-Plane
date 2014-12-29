//
//  TPPlane.h
//  Tappy Plane
//
//  Created by Brian Hoang on 12/26/14.
//  Copyright (c) 2014 Brian Hoang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TPPlane : SKSpriteNode

//see if its moving or not
@property (nonatomic) BOOL engineRunning;
@property (nonatomic) BOOL accelerating;
@property (nonatomic) BOOL crashed;

-(void)setRandomColor;
-(void)update;
-(void)collide:(SKPhysicsBody*)body;

@end
