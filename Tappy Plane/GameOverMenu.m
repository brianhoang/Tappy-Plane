//
//  GameOverMenu.m
//  Tappy Plane
//
//  Created by Brian Hoang on 1/5/15.
//  Copyright (c) 2015 Brian Hoang. All rights reserved.
//

#import "GameOverMenu.h"
#import "BitMapFont.h"
#import "Button.h"

@interface GameOverMenu()

@property (nonatomic) SKSpriteNode *medalDisplay;
@property (nonatomic) BitMapFont *scoreText;
@property (nonatomic) BitMapFont *bestText;
@property (nonatomic) SKSpriteNode *gameOverTitle;
@property (nonatomic) SKNode *panelGroup;
@property (nonatomic) Button* button;

@end

@implementation GameOverMenu

-(instancetype) initWithSize: (CGSize) size;
{
    if(self = [super init]){
        _size = size;
        
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Graphics"];
        
        _gameOverTitle = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"textGameOver"]];
        _gameOverTitle.position = CGPointMake(size.width * 0.5, size.height - 70);
        [self addChild:_gameOverTitle];
        
        //setup node to act as group for panel element
        _panelGroup = [SKNode node];
        [self addChild:_panelGroup];
        
        //setup background panel
        //scale image witout losing sharpness
        SKSpriteNode *panelBackground = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"UIbg"]];
        panelBackground.position = CGPointMake(size.width * 0.5, size.height - 150);
        panelBackground.centerRect = CGRectMake( 10 / panelBackground.size.width , 10 / panelBackground.size.height , (panelBackground.size.width - 20) / panelBackground.size.width , (panelBackground.size.height - 20) / panelBackground.size.height);
        
        panelBackground.xScale = 175.0 / panelBackground.size.width;
        panelBackground.yScale = 115.0 / panelBackground.size.height;
        [self.panelGroup addChild:panelBackground];
        
        //setup score title
        SKSpriteNode * scoreTitle = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"textScore"]];
        scoreTitle.anchorPoint = CGPointMake(1.0, 1.0);
        scoreTitle.position = CGPointMake(CGRectGetMaxX(panelBackground.frame) - 20, CGRectGetMaxY(panelBackground.frame) - 10);
        [self.panelGroup addChild:scoreTitle];
        
        //setup score text label
        _scoreText = [[BitMapFont alloc] initWithText:@"0" andFontName:@"number"];
        _scoreText.aligment = BitMapFontAlligmentRight;
        _scoreText.position = CGPointMake(CGRectGetMaxX(scoreTitle.frame), CGRectGetMinY(scoreTitle.frame) - 15);
        [_scoreText setScale:0.5];
        [self.panelGroup addChild:_scoreText];
        
        //setup best title
        SKSpriteNode * bestTitle = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"textBest"]];
        bestTitle.anchorPoint = CGPointMake(1.0, 1.0);
        bestTitle.position = CGPointMake(CGRectGetMaxX(panelBackground.frame) - 20, CGRectGetMaxY(panelBackground.frame) - 60);
        [self.panelGroup addChild:bestTitle];
        
        //setup best label
        _bestText = [[BitMapFont alloc] initWithText:@"0" andFontName:@"number"];
        _bestText.aligment = BitMapFontAlligmentRight;
        _bestText.position = CGPointMake(CGRectGetMaxX(bestTitle.frame), CGRectGetMinY(bestTitle.frame) - 15);
        [_bestText setScale:0.5];
        [self.panelGroup addChild:_bestText];
        
        //setup medal title
        SKSpriteNode * medalTitle = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"textMedal"]];
        medalTitle.anchorPoint = CGPointMake(0.0, 1.0);
        medalTitle.position = CGPointMake(CGRectGetMinX(panelBackground.frame) + 20, CGRectGetMaxY(panelBackground.frame) - 10);
        [self.panelGroup addChild:medalTitle];
        
        //setup medal display
        _medalDisplay = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"medalBlank"]];
        _medalDisplay.anchorPoint = CGPointMake(0.5, 1.0);
        _medalDisplay.position = CGPointMake(CGRectGetMidX(medalTitle.frame), CGRectGetMinY(medalTitle.frame) - 15);
        [self.panelGroup addChild: _medalDisplay];
        
        //set up button
        _button = [Button spriteNodeWithTexture:[atlas textureNamed:@"buttonPlay"]];
        _button.position = CGPointMake(CGRectGetMidX(panelBackground.frame), CGRectGetMinY(panelBackground.frame) - 25);;
       // button.zPosition = 1.0;
        [_button setPressedTarget:self withAction:@selector(pressedPlayButton)];
        [self  addChild:_button];
        
        //set initial values
        self.medal = MedalSilver;
        self.score= 7;
        self.bestScore = 100;
        
    }
    return  self;
}


-(void)pressedPlayButton
{
    [self show];
    NSLog(@"pressedplaybutton");
}

-(void)setScore:(NSInteger)score{
    _score = score;
    self.scoreText.text = [NSString stringWithFormat:@"%ld",(long)score];
}

-(void)setBestScore:(NSInteger)bestScore{
    _bestScore = bestScore;
    self.bestText.text = [NSString stringWithFormat:@"%ld" , (long) bestScore];
}


-(void) setMedal:(MedalType)medal
{
    _medal = medal;
    switch (medal) {
        case MedalBronze:
            self.medalDisplay.texture = [[SKTextureAtlas atlasNamed:@"Graphics"] textureNamed:@"medalBronze"];
            break;
        case MedalSilver:
            self.medalDisplay.texture = [[SKTextureAtlas atlasNamed:@"Graphics"] textureNamed:@"medalSilver"];
            break;
        case MedalGold:
            self.medalDisplay.texture = [[SKTextureAtlas atlasNamed:@"Graphics"] textureNamed:@"medalGold"];
            break;
        default:
            self.medalDisplay.texture = [[SKTextureAtlas atlasNamed:@"Graphics"] textureNamed:@"medalBlank"];
            break;
    }
}

-(void)show
{
    //animate game over title text
    SKAction *dropGameOver = [SKAction moveByX:0.0 y:-100 duration:0.5];
    dropGameOver.timingMode = SKActionTimingEaseOut;
    self.gameOverTitle.position = CGPointMake(self.gameOverTitle.position.x, self.gameOverTitle.position.y + 100);
    [self.gameOverTitle runAction:dropGameOver];
    
    
    //animate main menu panel
    SKAction *raisePanel = [SKAction group:@[[SKAction fadeInWithDuration:0.4],
                                             [SKAction moveByX:0.0 y:100 duration:0.4]]];
    raisePanel.timingMode = SKActionTimingEaseOut;
    //alpha is transparancy, default to one
    self.panelGroup.alpha = 0.0;
    self.panelGroup.position = CGPointMake(self.panelGroup.position.x,  self.panelGroup.position.y - 100);
    [self.panelGroup runAction:[SKAction sequence: @[[SKAction waitForDuration:0.7], raisePanel]]];
    
    //animate play button
    SKAction *fadeButton = [SKAction sequence:@[[SKAction waitForDuration:1.2], [SKAction fadeInWithDuration:0.4]]];
    self.button.alpha = 0.0;
    self.button.userInteractionEnabled = NO;
    [self.button runAction:fadeButton completion:^{
        self.button.userInteractionEnabled = YES;
    }];
     
}

@end
