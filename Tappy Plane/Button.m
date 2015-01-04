//
//  Button.m
//  Tappy Plane
//
//  Created by Brian Hoang on 1/4/15.
//  Copyright (c) 2015 Brian Hoang. All rights reserved.
//

#import "Button.h"
#import <objc/message.h>

@interface Button()

@property (nonatomic) CGRect fullSizeFrame;

@end


@implementation Button

+(instancetype)spriteNodeWithTexture:(SKTexture *)texture
{
    Button *instance = [super spriteNodeWithTexture:texture];
    instance.pressedScale = 0.9;
    instance.userInteractionEnabled = YES;
    return instance;
    
}

-(void)setPressedTarget:(id)pressedTarget withAction:(SEL)pressedAction
{
    _pressedTarget = pressedTarget;
    _pressedAction = pressedAction;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.fullSizeFrame = self.frame;
    [self touchesMoved:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setScale:1.0];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setScale:1.0];
    for(UITouch* touch in touches){
        if(CGRectContainsPoint(self.fullSizeFrame, [touch locationInNode:self.parent])){
            //pressed button
           // [self.pressedTarget performSelector:self.pressedAction];
            //select Target/build settings/scroll to apple llVM 6.0 - preprocessing
            //set "enable strict scecking of obj_mesgSend calls" to NO
            objc_msgSend(self.pressedTarget , self.pressedAction);
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches){
        if(CGRectContainsPoint(self.fullSizeFrame, [touch locationInNode:self.parent])){
            [self setScale:self.pressedScale];
        }else{
            [self setScale:1.0];
        }
    }
}

@end
