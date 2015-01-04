//
//  Button.h
//  Tappy Plane
//
//  Created by Brian Hoang on 1/4/15.
//  Copyright (c) 2015 Brian Hoang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Button : SKSpriteNode

@property (nonatomic) CGFloat pressedScale;
@property (nonatomic, readonly , weak) id pressedTarget;
@property (nonatomic, readonly) SEL pressedAction;

-(void)setPressedTarget:(id)pressedTarget withAction:(SEL)pressedAction;

+(instancetype)spriteNodeWithTexture:(SKTexture *)texture;


@end
