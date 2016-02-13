//
//  ScoresViewController.h
//  SUMMING
//
//  Created by cliff on 11. 5. 23..
//  Copyright 2011 esed. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScoresViewController : UIViewController {
    
@private
    UILabel *_scoreLabel1;
    UILabel *_scoreLabel2;
    UILabel *_scoreLabel3;
    UILabel *_scoreLabel4;
    UILabel *_scoreLabel5;
    UILabel *_scoreHardLabel1;
    UILabel *_scoreHardLabel2;
    UILabel *_scoreHardLabel3;
    UILabel *_scoreHardLabel4;
    UILabel *_scoreHardLabel5;
}

@property (nonatomic, retain) IBOutlet UILabel *scoreLabel1;
@property (nonatomic, retain) IBOutlet UILabel *scoreLabel2;
@property (nonatomic, retain) IBOutlet UILabel *scoreLabel3;
@property (nonatomic, retain) IBOutlet UILabel *scoreLabel4;
@property (nonatomic, retain) IBOutlet UILabel *scoreLabel5;
@property (nonatomic, retain) IBOutlet UILabel *scoreHardLabel1;
@property (nonatomic, retain) IBOutlet UILabel *scoreHardLabel2;
@property (nonatomic, retain) IBOutlet UILabel *scoreHardLabel3;
@property (nonatomic, retain) IBOutlet UILabel *scoreHardLabel4;
@property (nonatomic, retain) IBOutlet UILabel *scoreHardLabel5;

- (IBAction)goBack:(id)sender;

@end
