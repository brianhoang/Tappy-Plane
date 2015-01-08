//
//  GameOverMenu.h
//  Tappy Plane
//
//  Created by Brian Hoang on 1/5/15.
//  Copyright (c) 2015 Brian Hoang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


typedef enum : NSUInteger {
    MedalNone,
    MedalBronze,
    MedalSilver,
    MedalGold
}MedalType;

@protocol GameOverMenuDelegate <NSObject>

-(void)pressedStartButton;

@end


@interface GameOverMenu : SKNode

@property (nonatomic) CGSize size;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger bestScore;
@property (nonatomic) MedalType medal;
@property (nonatomic, weak) id<GameOverMenuDelegate> delegate;

-(instancetype) initWithSize: (CGSize) size;
-(void)show;

@end
