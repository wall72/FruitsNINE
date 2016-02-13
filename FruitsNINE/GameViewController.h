//
//  GameViewController.h
//  Summing
//
//  Created by cliff on 11. 5. 17..
//  Copyright 2011 esed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameController;

@interface GameViewController : UIViewController {
    
@private
    UILabel *_scoreLabel;
    UILabel *_scoreLabelComplete;
    UIView *_gameCompleteOverlay;
    UIView *_gameOverOverlay;
    NSInteger _gameMode;
    GameController *_gameController;
}

@property (nonatomic, retain) IBOutlet UILabel *scoreLabel;
@property (nonatomic, retain) IBOutlet UILabel *scoreLabelComplete;
@property (nonatomic, retain) IBOutlet UIView *gameCompleteOverlay;
@property (nonatomic, retain) IBOutlet UIView *gameOverOverlay;
@property (nonatomic, assign) NSInteger gameMode;
@property (nonatomic, retain) IBOutlet GameController *gameController;

- (IBAction)restartGame:(id)sender;
- (IBAction)quitGame:(id)sender;

- (void)displayGameComplete:(NSInteger)scoreInt withMode:(NSInteger)gameMode;
- (void)displayGameOver;
- (void)dismissView;

@end
