//
//  BitMapFont.m
//  Tappy Plane
//
//  Created by Brian Hoang on 1/3/15.
//  Copyright (c) 2015 Brian Hoang. All rights reserved.
//

#import "BitMapFont.h"

@implementation BitMapFont

-(instancetype)initWithText:(NSString *)text andFontName:(NSString *)fontName
{
    if(self = [super init]){
        _text = text;
        _fontName = fontName;
        _letterSpacing = 2.0;
        [self updateText];
    }
    return self;
}

-(void)setText:(NSString *)text
{
    if(_text != text){
        _text = text;
        [self updateText];
    }
}

-(void)setFontName:(NSString *)fontName
{
    if(_fontName != fontName){
        _fontName = fontName;
        [self updateText];
    }
}

-(void)setLetterSpacing:(CGFloat)letterSpacing
{
    if(_letterSpacing != letterSpacing){
        _letterSpacing = letterSpacing;
        [self updateText];
    }
}


-(void)updateText
{
    //removes unused nodes
    if(self.text.length < self.children.count){
        for (NSUInteger i = self.children.count; i > self.text.length; i--){
            [[self .children objectAtIndex:i-1] removeFromParent];
        }
    }
    
    CGPoint pos = CGPointZero;
    CGSize totalSize = CGSizeZero;
    
    SKTextureAtlas* atlas = [SKTextureAtlas atlasNamed:@"Graphics"];
    
    //loop through all chacters in text
    for(NSUInteger i = 0; i <self.text.length; i++){
        //get character in text for current position in loop
        unichar c = [self.text characterAtIndex:i];
        //build texture name from character and font name %@ for string, %C for char
        NSString* textureName = [NSString stringWithFormat:@"%@%C", self.fontName, c];
        
        SKSpriteNode *letter;
        if(i < self.children.count){
            //reuse existinf node
            letter = [self.children objectAtIndex:i];
            letter.texture = [atlas textureNamed:textureName];
            letter.size = letter.texture.size;
        }else{
            //create a new letter node
            letter = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:textureName]];
            letter.anchorPoint = CGPointZero;
            [self addChild:letter];
        }
        
        letter.position = pos;
        pos.x += letter.size.width + self.letterSpacing;
        totalSize.width += letter.size.width + self.letterSpacing;
        if(totalSize.height < letter.size.height){
            totalSize.height = letter.size.height;
        }
        
    }
    if (self.text.length > 0 ){
        totalSize.width -= self.letterSpacing;
    }
    
    //center text
    CGPoint adjustment = CGPointMake(-totalSize.width * 0.5, -totalSize.height * 0.5);
    for (SKNode* letter in self.children){
        letter.position = CGPointMake(letter.position.x + adjustment.x, letter.position.y + adjustment.y);
    }
    
}

@end
