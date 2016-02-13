//
//  GameViewController.m
//  Summing
//
//  Created by cliff on 11. 5. 17..
//  Copyright 2011 esed. All rights reserved.
//

#import "GameViewController.h"
#import "GameController.h"
#import "FruitsNineAppDelegate.h"
#import <GameKit/GameKit.h>

@implementation GameViewController

@synthesize scoreLabel = _scoreLabel;
@synthesize scoreLabelComplete = _scoreLabelComplete;
@synthesize gameCompleteOverlay = _gameCompleteOverlay;
@synthesize gameOverOverlay = _gameOverOverlay;
@synthesize gameMode = _gameMode;
@synthesize gameController = _gameController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [_scoreLabel release];
    [_scoreLabelComplete release];
    [_gameCompleteOverlay release];
    [_gameOverOverlay release];
    [_gameController release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.scoreLabel = nil;
    self.scoreLabelComplete = nil;
    self.gameCompleteOverlay = nil;
    self.gameOverOverlay = nil;
    self.gameController = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.gameController setMode:self.gameMode];
    [self.gameController startGame];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Event handler

- (IBAction)restartGame:(id)sender {
    NSLog(@"call");

    [self.gameController restartGame];
}

- (IBAction)quitGame:(id)sender {
    NSLog(@"call");

    [self.gameController stopGame];
}

- (void)displayGameComplete:(NSInteger)scoreInt withMode:(NSInteger)gameMode {
    NSLog(@"call");
    
    NSString *_scoreText = [NSString stringWithFormat:@"%d turns", scoreInt];
    self.scoreLabelComplete.text = _scoreText;    

    [self.view addSubview:self.gameCompleteOverlay];
    
    if([GKLocalPlayer localPlayer].authenticated == YES) {
        GKScore *scoreReporter;
        
        if (gameMode == 12) {   // Easy Scores
            scoreReporter = [[[GKScore alloc] initWithCategory:@"esed_fruitsnine_0001"] autorelease];
        } else {                // Hard Scores
            scoreReporter = [[[GKScore alloc] initWithCategory:@"esed_fruitsnine_0002"] autorelease];
        }
        
        scoreReporter.value = scoreInt;
        
        [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
            if (error != nil) {
                NSLog(@"Submitting a score failed !");
            } else {
                NSLog(@"Submitting succeeded !");
            }
        }];
    }
    
    [self performSelector:@selector(dismissView) withObject:nil afterDelay:1.0];
}

- (void)displayGameOver {
    NSLog(@"call");
    
    [self.view addSubview:self.gameOverOverlay];
  
    [self performSelector:@selector(dismissView) withObject:nil afterDelay:1.0];
}

- (void)dismissView {
    NSLog(@"call");
    
    [self.navigationController popViewControllerAnimated:NO];
}

@end
