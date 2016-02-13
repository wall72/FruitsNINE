//
//  NextItemButton.m
//  Summing
//
//  Created by cliff on 11. 5. 18..
//  Copyright 2011 esed. All rights reserved.
//

#import "NextItemButton.h"
#import "GameController.h"
#import "QuartzCore/QuartzCore.h"

@implementation NextItemButton

@synthesize controller = _controller;
@synthesize value = _value;

- (void)awakeFromNib {
    [self setTitle:@"" forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont fontWithName:@"Marker Felt" size:15]];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"nb"] forState:UIControlStateNormal];
    [self setUserInteractionEnabled:NO];
    [self.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    
    // border
//    [self.layer setBorderColor:[[UIColor grayColor] CGColor]];
//    [self.layer setBorderWidth:1.0];
    
    [self.controller registerNextItem:self];
}

- (void)dealloc {
    [_controller release];
    [super dealloc];
}

@end
