//
//  GameOver.h
//  RunDark
//
//  Created by Vinicius Resende Fialho on 14/03/14.
//  Copyright (c) 2014 VINICIUS RESENDE FIALHO. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameOver : SKScene  {
    SKNode *fundo;
}

@property SKSpriteNode *fundoGameOver;
@property SKSpriteNode *fundoLapide;

-(SKSpriteNode *)botaoRecomecaJogo;
-(SKSpriteNode *)botaoVoltarMenu;

@end
