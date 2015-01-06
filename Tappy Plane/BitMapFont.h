//
//  BitMapFont.h
//  Tappy Plane
//
//  Created by Brian Hoang on 1/3/15.
//  Copyright (c) 2015 Brian Hoang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSInteger{
    BitMapFontAlligmentLeft,
    BitMapFontAlligmentCenter,
    BitMapFontAlligmentRight
}BitMapFontAligment;

@interface BitMapFont : SKNode

@property (nonatomic) NSString* fontName;
@property (nonatomic) NSString* text;
@property (nonatomic) CGFloat letterSpacing;
@property (nonatomic) BitMapFontAligment aligment;

-(instancetype)initWithText:(NSString*)text andFontName:(NSString*)fontName;


@end
