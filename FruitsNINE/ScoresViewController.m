//
//  ScoresViewController.m
//  SUMMING
//
//  Created by cliff on 11. 5. 23..
//  Copyright 2011 esed. All rights reserved.
//

#import "ScoresViewController.h"
#import "FruitsNINEAppDelegate.h"

@implementation ScoresViewController

@synthesize scoreLabel1 = _scoreLabel1;
@synthesize scoreLabel2 = _scoreLabel2;
@synthesize scoreLabel3 = _scoreLabel3;
@synthesize scoreLabel4 = _scoreLabel4;
@synthesize scoreLabel5 = _scoreLabel5;
@synthesize scoreHardLabel1 = _scoreHardLabel1;
@synthesize scoreHardLabel2 = _scoreHardLabel2;
@synthesize scoreHardLabel3 = _scoreHardLabel3;
@synthesize scoreHardLabel4 = _scoreHardLabel4;
@synthesize scoreHardLabel5 = _scoreHardLabel5;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [_scoreLabel1 release];
    [_scoreLabel2 release];
    [_scoreLabel3 release];
    [_scoreLabel4 release];
    [_scoreLabel5 release];
    [_scoreHardLabel1 release];
    [_scoreHardLabel2 release];
    [_scoreHardLabel3 release];
    [_scoreHardLabel4 release];
    [_scoreHardLabel5 release];
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
    self.scoreLabel1 = nil;
    self.scoreLabel2 = nil;
    self.scoreLabel3 = nil;
    self.scoreLabel4 = nil;
    self.scoreLabel5 = nil;
    self.scoreHardLabel1 = nil;
    self.scoreHardLabel2 = nil;
    self.scoreHardLabel3 = nil;
    self.scoreHardLabel4 = nil;
    self.scoreHardLabel5 = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    FruitsNINEAppDelegate *_appDelegate = (FruitsNINEAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSArray *_scores = _appDelegate.scoreList;
    
    int _count = [_scores count];
    
    if (_count > 0) {
        [self.scoreLabel1 setText:[NSString stringWithFormat:@"%d turns", [[_scores objectAtIndex:0] intValue]]];
        if (_count > 1) {
            [self.scoreLabel2 setText:[NSString stringWithFormat:@"%d turns", [[_scores objectAtIndex:1] intValue]]];
            if (_count > 2) {
                [self.scoreLabel3 setText:[NSString stringWithFormat:@"%d turns", [[_scores objectAtIndex:2] intValue]]];
                if (_count > 3) {
                    [self.scoreLabel4 setText:[NSString stringWithFormat:@"%d turns", [[_scores objectAtIndex:3] intValue]]];
                    if (_count > 4) {
                        [self.scoreLabel5 setText:[NSString stringWithFormat:@"%d turns", [[_scores objectAtIndex:4] intValue]]];
                    }
                }
            }
        }
    }

    _scores = _appDelegate.scoreHardList;
    
    _count = [_scores count];
    
    if (_count > 0) {
        [self.scoreHardLabel1 setText:[NSString stringWithFormat:@"%d turns", [[_scores objectAtIndex:0] intValue]]];
        if (_count > 1) {
            [self.scoreHardLabel2 setText:[NSString stringWithFormat:@"%d turns", [[_scores objectAtIndex:1] intValue]]];
            if (_count > 2) {
                [self.scoreHardLabel3 setText:[NSString stringWithFormat:@"%d turns", [[_scores objectAtIndex:2] intValue]]];
                if (_count > 3) {
                    [self.scoreHardLabel4 setText:[NSString stringWithFormat:@"%d turns", [[_scores objectAtIndex:3] intValue]]];
                    if (_count > 4) {
                        [self.scoreHardLabel5 setText:[NSString stringWithFormat:@"%d turns", [[_scores objectAtIndex:4] intValue]]];
                    }
                }
            }
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Event handler

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

@end
