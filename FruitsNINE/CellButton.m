//
//  CellButton.m
//  Summing
//
//  Created by cliff on 11. 5. 17..
//  Copyright 2011 esed. All rights reserved.
//

#import "CellButton.h"
#import "GameController.h"
#import "QuartzCore/QuartzCore.h"

@implementation CellButton

@synthesize controller = _controller;
@synthesize value = _value;
@synthesize assigned = _assigned;

- (void)awakeFromNib {
    [self setTitle:@"" forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont fontWithName:@"Marker Felt" size:20]];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"nb"] forState:UIControlStateNormal];
    [self setUserInteractionEnabled:YES];
    [self.layer setBorderColor:[[UIColor blackColor] CGColor]];

    // border
//    [self.layer setBorderColor:[[UIColor grayColor] CGColor]];
//    [self.layer setBorderWidth:1.0];
    
    [self setAssigned:NO];

    [self.controller registerCell:self];
}

- (void)dealloc {
    [_controller release];
    [super dealloc];
}

@end
