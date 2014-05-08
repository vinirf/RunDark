//
//  MenuPrincipal.h
//  RunDark
//
//  Created by Vinicius Resende Fialho on 15/03/14.
//  Copyright (c) 2014 VINICIUS RESENDE FIALHO. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MenuPrincipal : SKScene {
    SKNode *fundo;
    SKAction *sound;
    AVAudioPlayer *queuePlayer;
}

@property SKSpriteNode *fundoMenu;


-(SKSpriteNode *)buttonStartGame;
-(SKSpriteNode *)buttonRecord;
-(SKSpriteNode *)buttonExit;






@end
