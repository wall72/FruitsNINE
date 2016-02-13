//
//  NextItemButton.h
//  Summing
//
//  Created by cliff on 11. 5. 18..
//  Copyright 2011 esed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameController;

@interface NextItemButton : UIButton {
    
@private
    GameController *_controller;
    NSInteger _value;
}

@property (nonatomic, retain) IBOutlet GameController *controller;
@property (nonatomic, assign) IBOutlet NSInteger value;

@end
