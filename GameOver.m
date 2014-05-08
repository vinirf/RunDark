//
//  GameOver.m
//  RunDark
//
//  Created by Vinicius Resende Fialho on 14/03/14.
//  Copyright (c) 2014 VINICIUS RESENDE FIALHO. All rights reserved.
//

#import "GameOver.h"
#import "MyScene.h"
#import "MenuPrincipal.h"

@implementation GameOver



-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        fundo = [[SKNode alloc]init];
        fundo.name = @"FundoGameOver";
        fundo.position  = CGPointMake(190,250);
        
        SKTexture *texturaFundo = [SKTexture textureWithImageNamed:@"gameover.png"];
        self.fundoGameOver = [SKSpriteNode spriteNodeWithTexture:texturaFundo size:CGSizeMake(420,530)];
        [fundo addChild: self.fundoGameOver];
        [self addChild:fundo];
        
        
        SKTexture *texturaFundoLapide = [SKTexture textureWithImageNamed:@"fundoAuxGameOver.png"];
        self.fundoGameOver = [SKSpriteNode spriteNodeWithTexture:texturaFundoLapide size:CGSizeMake(130,320)];
        self.fundoGameOver.position = CGPointMake(300,250);
        [self addChild: self.fundoGameOver];
        
        SKAction *sound = [SKAction playSoundFileNamed:@"gameOverSound.mp3" waitForCompletion:NO];
        [self runAction:sound];
       
        
        [self addChild: [self botaoRecomecaJogo]];
        [self addChild:[self botaoVoltarMenu]];
    }
    
    return self;
}

- (SKSpriteNode *)botaoRecomecaJogo{
    SKSpriteNode *fireNode = [SKSpriteNode spriteNodeWithImageNamed:@"buttonJogarNovamente.png"];
    fireNode.position = CGPointMake(300,170);
    fireNode.size = CGSizeMake(70,40);
    fireNode.name = @"JogarNovamente";//how the node is identified later
    fireNode.zPosition = +5.0;
    return fireNode;
}

-(SKSpriteNode *)botaoVoltarMenu{
    SKSpriteNode *fireNode = [SKSpriteNode spriteNodeWithImageNamed:@"botaoVoltarMenu.png"];
    fireNode.position = CGPointMake(300,120);
    fireNode.size = CGSizeMake(70,40);
    fireNode.name = @"VoltarMenu";//how the node is identified later
    fireNode.zPosition = +5.0;
    return fireNode;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"JogarNovamente"]) {
        MyScene *inicioJogo = [[MyScene alloc]initWithSize:CGSizeMake(768, 1024)];
        inicioJogo.scaleMode = SKSceneScaleModeAspectFill;
        SKTransition *animate = [SKTransition fadeWithDuration:1.0f];
        [self.view presentScene:inicioJogo transition:animate];
    }
    
    if ([node.name isEqualToString:@"VoltarMenu"]) {
        MenuPrincipal *voltaMenu = [[MenuPrincipal alloc]initWithSize:CGSizeMake(768, 1024)];
        voltaMenu.scaleMode = SKSceneScaleModeAspectFill;
        SKTransition *animate = [SKTransition fadeWithDuration:1.0f];
        [self.view presentScene:voltaMenu transition:animate];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
