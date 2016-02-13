//
//  RootViewController.m
//  Summing
//
//  Created by Changho Lee on 11. 5. 17..
//  Copyright 2011 esed. All rights reserved.
//

#import "MenuViewController.h"
#import "GameViewController.h"
#import "GameController.h"
#import "ScoresViewController.h"
#import "FruitsNineAppDelegate.h"

@interface MenuViewController ()
- (void)showAlert;
- (void)showGameView;
- (void)AddiAd;
- (void)AddCaulyAD;
@end

@implementation MenuViewController

@synthesize musicSwitch = _musicSwitch;
@synthesize soundSwitch = _soundSwitch;
@synthesize newGameButton = _newGameButton;
@synthesize newGameHardButton = _newGameHardButton;
@synthesize howOverlay = _howOverlay;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib {
    _newButtonIdx = 12;
    
    _appDelegate = (FruitsNINEAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_musicSwitch release];
    [_soundSwitch release];
    [_newGameButton release];
    [_newGameHardButton release];
    [_howOverlay release];
    [_appDelegate release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    // 지역 체크!
    NSString   *language = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
    NSLog(@"The device's specified language is %@", language);
    NSString   *countryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    NSLog(@"The device's specified countryCode is %@", countryCode);
	
	// embed AD
    _isBannerVisible = NO;
    
    if ([countryCode isEqualToString:@"KR"]) {
        [self AddCaulyAD];
    } else {
        [self AddiAd];
    }

    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.musicSwitch = nil;
    self.soundSwitch = nil;
    self.newGameButton = nil;
    self.newGameHardButton = nil;
    self.howOverlay = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setToggle];

    if ([_appDelegate isResume]) {
        if ([[_appDelegate.saveStatus objectForKey:@"mode"] isEqualToString:@"12"]) {
            [self.newGameButton setImage:[UIImage imageNamed:@"resumegame_button.png"] forState:UIControlStateNormal];
            [self.newGameHardButton setImage:[UIImage imageNamed:@"newgamehard_button.png"] forState:UIControlStateNormal];
        } else {
            [self.newGameButton setImage:[UIImage imageNamed:@"newgame_button.png"] forState:UIControlStateNormal];
            [self.newGameHardButton setImage:[UIImage imageNamed:@"resumegamehard_button.png"] forState:UIControlStateNormal];
        }
    } else {
        [self.newGameButton setImage:[UIImage imageNamed:@"newgame_button.png"] forState:UIControlStateNormal];
        [self.newGameHardButton setImage:[UIImage imageNamed:@"newgamehard_button.png"] forState:UIControlStateNormal];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSLog(@"call");
    
    if (buttonIndex == 0) { // Cancel
        
    } else { // OK
        [self showGameView];
    }
}

#pragma mark - LeaderboardViewController delegate

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Event handlers

- (IBAction)newGame:(id)sender {
    NSLog(@"call");
    
    UIButton *_newButton = (UIButton *)sender;
    
    _newButtonIdx = _newButton.tag;
    
    // Resume 일때 SaveMode와 선택된 버튼의 Tag가 틀리면 세이브 데이터가 없어진다고 경고 필요!
    if ([_appDelegate isResume] && _newButtonIdx != [[_appDelegate.saveStatus objectForKey:@"mode"] intValue]) {
        [self showAlert];
    } else {
        [self showGameView];
    }
}

- (void)showGameView {
    GameViewController *_gameViewController = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
    [_gameViewController setGameMode:_newButtonIdx];
    [self.navigationController pushViewController:_gameViewController animated:NO];
    [_gameViewController release];
}

- (IBAction)showScores:(id)sender {
    ScoresViewController *_scoresViewController = [[ScoresViewController alloc] initWithNibName:@"ScoresViewController" bundle:nil];
    [self.navigationController pushViewController:_scoresViewController animated:NO];
    [_scoresViewController release];
}

- (IBAction)showLeaderboard:(id)sender {
    if([GKLocalPlayer localPlayer].authenticated == YES) {
        GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
        if (leaderboardViewController != nil) {
//            leaderboardViewController.category = @"";
            leaderboardViewController.leaderboardDelegate = self;
            [self presentModalViewController:leaderboardViewController animated:YES];
        }
    }    
}

- (IBAction)showHowtoplay:(id)sender {
    [self.view addSubview:self.howOverlay];
}

- (IBAction)closeHowtoplay:(id)sender {
    [self.howOverlay removeFromSuperview];
}

- (IBAction)changedMusic:(id)sender {
    [_appDelegate setShouldPlayMusic:self.musicSwitch.on];
}

- (IBAction)changedSound:(id)sender {
    [_appDelegate setShouldPlaySound:self.soundSwitch.on];
}

#pragma mark - User defined functions

- (void)setToggle {
    [self.musicSwitch setOn:_appDelegate.shouldPlayMusic];
    [self.soundSwitch setOn:_appDelegate.shouldPlaySound];
}

- (void)showAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:@"Your save data will be lost!"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
}

#pragma mark - iAd

- (void) AddiAd {
    ADBannerView *_bannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    CGRect _adBannerFrame = _bannerView.frame;
    _adBannerFrame.origin.y = self.navigationController.view.frame.size.height;
    [_bannerView setFrame:_adBannerFrame];
    [_bannerView setDelegate:self];
    [_bannerView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin];
    [_bannerView setRequiredContentSizeIdentifiers:[NSSet setWithObject:ADBannerContentSizeIdentifierPortrait]];
    [self.navigationController.view addSubview:_bannerView];
    [_bannerView release];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
	NSLog(@"iAd AdReceiveCompleted..");
    
    if (!_isBannerVisible) {
        [UIView beginAnimations:@"animateAdBannerOn" context:nil];
        [banner setFrame:CGRectOffset(banner.frame, 0, -banner.frame.size.height)];
        [UIView commitAnimations];
        _isBannerVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
	NSLog(@"iAd AdReceiveFailed..");
    
	if (_isBannerVisible) {
        [UIView beginAnimations:@"animateAdBannerOff" context:nil];
        [banner setFrame:CGRectOffset(banner.frame, 0, banner.frame.size.height)];
        [UIView commitAnimations];
        _isBannerVisible = NO;
    }
}

#pragma mark - CaulyAD

- (void)AddCaulyAD {
    [CaulyViewController initCauly:self];
    
    float yPos = self.navigationController.view.frame.size.height - 48;
    
	if( [CaulyViewController requestBannerADWithViewController:self.navigationController xPos:0 yPos:yPos adType:BT_IPHONE] == FALSE ) {
		NSLog(@"requestBannerAD failed");
	}
}

- (void)AdReceiveCompleted {
	NSLog(@"CaulyAD AdReceiveCompleted..");
    
    if (!_isBannerVisible) {
        [CaulyViewController hideBannerAD:_isBannerVisible];
        _isBannerVisible = YES;
    }
}

- (void)AdReceiveFailed {
	NSLog(@"CaulyAD AdReceiveFailed..");
    
	if (_isBannerVisible) {
        [CaulyViewController hideBannerAD:_isBannerVisible];
        _isBannerVisible = NO;
    }
}

- (NSString *) devKey {
	return @"i3jbp2GLm";
}

- (NSString *) gender {
	return @"all";
}

- (NSString *) age {
	return @"all";
}

- (BOOL) getGPSInfo {
	return FALSE;
}

- (REFRESH_PERIOD) rollingPeriod {
	return SEC_30;
}

- (ANIMATION_TYPE) animationType {
	return FADEOUT;
}

@end
