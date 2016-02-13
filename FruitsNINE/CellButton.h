//
//  CellButton.h
//  Summing
//
//  Created by cliff on 11. 5. 17..
//  Copyright 2011 esed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameController;

@interface CellButton : UIButton {
    
@private
    GameController *_controller;
    NSInteger _value;
    BOOL _assigned;
}

@property (nonatomic, retain) IBOutlet GameController *controller;
@property (nonatomic, assign) IBOutlet NSInteger value;
@property (nonatomic, assign, getter = isAssigned) BOOL assigned;

@end
