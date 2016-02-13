//
//  GameController.m
//  Summing
//
//  Created by cliff on 11. 5. 17..
//  Copyright 2011 esed. All rights reserved.
//

#import "GameController.h"
#import "GameViewController.h"
#import "FruitsNINEAppDelegate.h"
#import "CellButton.h"
#import "NextItemButton.h"

@interface GameController () 
- (void)initializeBoard;
- (void)resumeBoard;
- (void)initializeNextBoard;
- (void)resumeNextBoard;
- (void)setNextItems;
- (void)copyItem:(NSInteger)tgtIndex withItem:(NSInteger)srcIndex;
- (void)checkMatch:(NSInteger)tagNum;
- (void)checkCompleted;
- (void)setGameMode:(NSInteger)gameMode;
- (void)setScore:(NSInteger)scoreInt;
- (void)setResume:(BOOL)flag;
- (void)performAnimation;
@end

@implementation GameController

@synthesize mode = _mode;
@synthesize viewController = _viewController;

- (void)awakeFromNib {
    _cells = [[NSMutableArray arrayWithCapacity:10] retain];
    _nextItems = [[NSMutableDictionary dictionaryWithCapacity:4] retain];

    // 키프레임 에니매이션 세팅
    _popAnimation = [[CAKeyframeAnimation animationWithKeyPath:@"transform.scale"] retain];
    [_popAnimation setKeyTimes:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:0.7f], [NSNumber numberWithFloat:1.0f], nil]];
    [_popAnimation setValues:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.01f], [NSNumber numberWithFloat:1.1f], [NSNumber numberWithFloat:1.0f], nil]];
    [_popAnimation setDuration:0.3];
    
    // 사운드 파일 세팅 (탭)
    NSURL *_tapSoundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tap_sound" ofType:@"aif"]];
    AudioServicesCreateSystemSoundID((CFURLRef)_tapSoundURL, &_tapSoundID);
    
    // 사운드 파일 세팅 (박수)
    NSURL *_clapSoundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"clap_sound" ofType:@"aif"]];
    AudioServicesCreateSystemSoundID((CFURLRef)_clapSoundURL, &_clapSoundID);

    _appDelegate = (FruitsNINEAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _initBlankCells = [[NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:3], [NSNumber numberWithInt:5], [NSNumber numberWithInt:7], [NSNumber numberWithInt:9], [NSNumber numberWithInt:19], [NSNumber numberWithInt:21], [NSNumber numberWithInt:23], [NSNumber numberWithInt:25], [NSNumber numberWithInt:27], [NSNumber numberWithInt:37], [NSNumber numberWithInt:39], [NSNumber numberWithInt:41], [NSNumber numberWithInt:43], [NSNumber numberWithInt:45], [NSNumber numberWithInt:55], [NSNumber numberWithInt:57], [NSNumber numberWithInt:59], [NSNumber numberWithInt:61], [NSNumber numberWithInt:63], [NSNumber numberWithInt:73], [NSNumber numberWithInt:75], [NSNumber numberWithInt:77], [NSNumber numberWithInt:79], [NSNumber numberWithInt:81], nil] retain];
}

- (void)dealloc {
    [_cells release];
    [_nextItems release];
    [_popAnimation release];
    [_initBlankCells release];
    [_viewController release];
    [_appDelegate release];
    [super dealloc];
}

#pragma mark - Event handlers

- (IBAction)cellTapped:(id)sender {
    NSLog(@"call");
    
    CellButton *_cell = (CellButton *)sender;
    
    if (_cell.isAssigned == NO) {
        NextItemButton *_nextItem = [_nextItems objectForKey:[NSNumber numberWithInt:1]];
        
        [_cell setValue:_nextItem.value];
        
        NSString *_valueStr = [NSString stringWithFormat:@"f%02d", _nextItem.value];
        [_cell setBackgroundImage:[UIImage imageNamed:_valueStr] forState:UIControlStateNormal];
        
        [_cell setUserInteractionEnabled:NO];

        [_cell setAssigned:YES];
        
        [self checkMatch:_cell.tag];
        
        [self setNextItems];
        
        _score += 1;
        [self setScore:_score];

        [self setResume:YES];

        [self checkCompleted];
    }
}

#pragma mark - User defined functions

- (void)startGame {
    NSLog(@"call");
    
    if ([_appDelegate isResume] && self.mode == [[_appDelegate.saveStatus objectForKey:@"mode"] intValue]) {
        _score = [[_appDelegate.saveStatus objectForKey:@"score"] intValue];
        [self setScore:_score];
        
        [self resumeBoard];
        
        [self resumeNextBoard];
    } else {
        [self setGameMode:self.mode];
        
        _score = 0;
        [self setScore:_score];

        [self initializeBoard];
        
        [self initializeNextBoard];
    }
}

- (void)restartGame {
    NSLog(@"call");
    
    _score = 0;
    [self setScore:_score];
    
    [self initializeBoard];
    [self initializeNextBoard];
}

- (void)registerCell:(CellButton *)cellButton {
    [_cells addObject:cellButton];
}

- (void)registerNextItem:(NextItemButton *)nextItemButton {
    [_nextItems setObject:nextItemButton forKey:[NSNumber numberWithInt:nextItemButton.tag]];
}

- (void)stopGame {
    NSLog(@"call");

    [self.viewController dismissView];
}

- (void)initializeBoard {
    for (CellButton *_cell in _cells) {
        
        // 짝수 셀에 배치
        if ([_initBlankCells containsObject:[NSNumber numberWithInt:_cell.tag]]) {
            // 공백
            [_cell setValue:0];
            
            [_cell setBackgroundImage:[UIImage imageNamed:@"fb"] forState:UIControlStateNormal];

            [_cell setUserInteractionEnabled:YES];
            
            [_cell setAssigned:NO];
        } else {
            // 임의의 수로 세팅
            int _value = arc4random() % self.mode;
            
            [_cell setValue:_value];
            
            NSString *_valueStr = [NSString stringWithFormat:@"f%02d", _value];
            [_cell setBackgroundImage:[UIImage imageNamed:_valueStr] forState:UIControlStateNormal];

            [_cell setUserInteractionEnabled:NO];
            
            [_cell setAssigned:YES];
        }

        [_cell setHidden:YES];
        
        [_appDelegate.saveValueList setObject:[NSString stringWithFormat:@"%d", _cell.value] forKey:[NSString stringWithFormat:@"%d", _cell.tag]];
        [_appDelegate.saveAssignList setObject:[NSString stringWithFormat:@"%d", _cell.isAssigned] forKey:[NSString stringWithFormat:@"%d", _cell.tag]];
    }
    
    [self setResume:NO];
    
    [self performAnimation];
}

- (void)resumeBoard {
    for (CellButton *_cell in _cells) {
        [_cell setValue:[[_appDelegate.saveValueList objectForKey:[NSString stringWithFormat:@"%d", _cell.tag]] intValue]];
        [_cell setAssigned:[[_appDelegate.saveAssignList objectForKey:[NSString stringWithFormat:@"%d", _cell.tag]] boolValue]];
        
        if (!_cell.isAssigned) {
            // 공백
            [_cell setBackgroundImage:[UIImage imageNamed:@"fb"] forState:UIControlStateNormal];
            
            [_cell setUserInteractionEnabled:YES];
            
            [_cell setAssigned:NO];
        } else {
            // 저장된 수로 세팅
            NSString *_valueStr = [NSString stringWithFormat:@"f%02d", _cell.value];
            [_cell setBackgroundImage:[UIImage imageNamed:_valueStr] forState:UIControlStateNormal];
            
            [_cell setUserInteractionEnabled:NO];
            
            [_cell setAssigned:YES];
        }
        
        [_cell setHidden:YES];
    }
    
    [self performAnimation];
}

- (void)initializeNextBoard {
    NSEnumerator *_enumerator = [_nextItems objectEnumerator];
    NextItemButton *_nextItem;
    
    while ((_nextItem = [_enumerator nextObject])) {
        // 임의의 수로 세팅
        int _value = arc4random() % self.mode;
        
        [_nextItem setValue:_value];
        
        NSString *_valueStr = [NSString stringWithFormat:@"f%02d", _value];
        [_nextItem setBackgroundImage:[UIImage imageNamed:_valueStr] forState:UIControlStateNormal];

        [_appDelegate.saveNextList setObject:[NSString stringWithFormat:@"%d", _nextItem.value] forKey:[NSString stringWithFormat:@"%d", _nextItem.tag]];
    }
}

- (void)resumeNextBoard {
    NSEnumerator *_enumerator = [_nextItems objectEnumerator];
    NextItemButton *_nextItem;
    
    while ((_nextItem = [_enumerator nextObject])) {
        [_nextItem setValue:[[_appDelegate.saveNextList objectForKey:[NSString stringWithFormat:@"%d", _nextItem.tag]] intValue]];
        
        // 저장된 수로 세팅
        NSString *_valueStr = [NSString stringWithFormat:@"f%02d", _nextItem.value];
        [_nextItem setBackgroundImage:[UIImage imageNamed:_valueStr] forState:UIControlStateNormal];
    }
}

- (void)setNextItems {
    // copy 2>1, 3>2, 4>3
    [self copyItem:1 withItem:2];
    [self copyItem:2 withItem:3];
    [self copyItem:3 withItem:4];
    
    // 신규 아이템 추가
    NextItemButton *_nextItem = [_nextItems objectForKey:[NSNumber numberWithInt:4]];

    // 임의의 수로 세팅
    int _value = arc4random() % self.mode;
    [_nextItem setValue:_value];
    
    NSString *_valueStr = [NSString stringWithFormat:@"f%02d", _value];
    [_nextItem setBackgroundImage:[UIImage imageNamed:_valueStr] forState:UIControlStateNormal];

    [_appDelegate.saveNextList setObject:[NSString stringWithFormat:@"%d", _nextItem.value] forKey:[NSString stringWithFormat:@"%d", _nextItem.tag]];
}

- (void)copyItem:(NSInteger)tgtIndex withItem:(NSInteger)srcIndex {
    NextItemButton *_nextItemSrc = [_nextItems objectForKey:[NSNumber numberWithInt:srcIndex]];
    NextItemButton *_nextItemTgt = [_nextItems objectForKey:[NSNumber numberWithInt:tgtIndex]];
    
    [_nextItemTgt setValue:_nextItemSrc.value];
    
    NSString *_valueStr = [NSString stringWithFormat:@"f%02d", _nextItemSrc.value];
    [_nextItemTgt setBackgroundImage:[UIImage imageNamed:_valueStr] forState:UIControlStateNormal];

    [_appDelegate.saveNextList setObject:[NSString stringWithFormat:@"%d", _nextItemSrc.value] forKey:[NSString stringWithFormat:@"%d", _nextItemTgt.tag]];
}

- (void)checkMatch:(NSInteger)tagNum {
    NSMutableArray *_octet = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:tagNum - 9 - 1], [NSNumber numberWithInt:tagNum - 9], [NSNumber numberWithInt:tagNum - 9 + 1], [NSNumber numberWithInt:tagNum - 1], [NSNumber numberWithInt:tagNum + 1], [NSNumber numberWithInt:tagNum + 9 - 1], [NSNumber numberWithInt:tagNum + 9], [NSNumber numberWithInt:tagNum + 9 + 1], nil];
    
    NSMutableArray *_octetTgt = [NSMutableArray array];
    
    for (NSNumber *_position in _octet) {
        NSInteger _checkInt = [_position intValue];
        
        // 1보다 작은 셀은 제외
        if (_checkInt < 1) {
            [_octetTgt addObject:_position];
            continue;
        }
        
        // 81보다 큰 셀은 제외
        if (_checkInt > 81) {
            [_octetTgt addObject:_position];
            continue;
        }
        
        NSInteger _checkLeftRight = [_octet indexOfObject:_position];

        NSInteger _modNum = tagNum % 9;
        
        if (_modNum == 0) { // 9의 배수 > 선택된 셀이 우측 엣지 이면
            if (_checkLeftRight == 2 || _checkLeftRight == 4 || _checkLeftRight == 7) {
                // 오른쪽 셀은 대상에서 제외
                [_octetTgt addObject:_position];
                continue;
            }
        } else if (_modNum == 1) { // 1에서 부터 7씩 더한 수 (7로 나누면 1이 남음) > 선택된 셀이 좌측 엣지 이면
            if (_checkLeftRight == 0 || _checkLeftRight == 3 || _checkLeftRight == 5) {
                // 왼쪽 셀은 대상에서 제외
                [_octetTgt addObject:_position];
                continue;
            }
        }
    }
    
    for (NSNumber *_position in _octetTgt) {
        [_octet removeObject:_position];
    }
    
    [_octet addObject:[NSNumber numberWithInt:tagNum]];

    // 비교대상 셀의 집합
    NSLog(@"_octet = %@", _octet);
    
    // 집합 자료 구조체
    NSMutableArray *_chkArray = [NSMutableArray arrayWithCapacity:9];
    
    // 판단 변수
    BOOL _chkRight = YES;
    
    for (NSNumber *_chkIdx in _octet) {
        CellButton *_cell = (CellButton *)[self.viewController.view viewWithTag:[_chkIdx intValue]];
        
        NSLog(@"_cell.value = %d", _cell.value);

        if (_cell.assigned == NO) {
            _chkRight = NO;
            break;
        }
        
        NSNumber *_chkValue = [NSNumber numberWithInt:_cell.value];
        if ([_chkArray containsObject:_chkValue]) {
            _chkRight = NO;
            break;
        }
        
        [_chkArray addObject:_chkValue];
    }    
    
    NSLog(@"_chkArray = %@", _chkArray);
    NSLog(@"_chkRight = %d", _chkRight);

    CellButton *_cellTgt = (CellButton *)[self.viewController.view viewWithTag:tagNum];
    
    if (_chkRight) {
        for (NSNumber *_position in _octet) {
            for (CellButton *_cell in _cells) {     
                if (_cell.tag == [_position intValue] || _cell.tag == tagNum) {
                    // 공백
                    [_cell setValue:0];
                    
                    [_cell setBackgroundImage:[UIImage imageNamed:@"fb"] forState:UIControlStateNormal];
                    
                    [_cell setUserInteractionEnabled:YES];
                    
                    [_cell setAssigned:NO];
                    
                    [_cell setHidden:YES];

                    float _animationTime = 0.1;
                    [self performSelector:@selector(popView:) withObject:_cell afterDelay:_animationTime];

                    [_appDelegate.saveValueList setObject:@"0" forKey:[NSString stringWithFormat:@"%d", _cell.tag]];
                    [_appDelegate.saveAssignList setObject:@"0" forKey:[NSString stringWithFormat:@"%d", _cell.tag]];
                }
            }
        }
        
        if (_appDelegate.shouldPlaySound) {
            AudioServicesPlaySystemSound(_clapSoundID);
        }
    } else {
        [_appDelegate.saveValueList setObject:[NSString stringWithFormat:@"%d", _cellTgt.value] forKey:[NSString stringWithFormat:@"%d", tagNum]];
        [_appDelegate.saveAssignList setObject:[NSString stringWithFormat:@"%d", _cellTgt.isAssigned] forKey:[NSString stringWithFormat:@"%d", tagNum]];
        
        if (_appDelegate.shouldPlaySound) {
            AudioServicesPlaySystemSound(_tapSoundID);
        }
    }
}

- (void)checkCompleted {
    BOOL _checkCompleted = YES;
    NSInteger _cnt = 0;
    
    for (CellButton *_cell in _cells) {
        if (_cell.isAssigned == YES) {
            _checkCompleted = NO;
            _cnt++;
        }
    }
    
    if (_checkCompleted == NO) {
        if (_cnt == [_cells count]) {
            // gameover
            [self.viewController displayGameOver];

            [self setResume:NO];
        }
        
        // normal
        return;
    }
    
    // complete
    [_appDelegate addHighScore:_score withMode:self.mode];
    
    [self setResume:NO];
    
    [self.viewController displayGameComplete:_score withMode:self.mode];
}

- (void)setGameMode:(NSInteger)gameMode {
//    NSString *_scoreText = [NSString stringWithFormat:@"%d turns", scoreInt];
//    self.viewController.scoreLabel.text = _scoreText;
    
    [_appDelegate.saveStatus setObject:[NSString stringWithFormat:@"%d", gameMode] forKey:@"mode"];
}

- (void)setScore:(NSInteger)scoreInt {
    NSString *_scoreText = [NSString stringWithFormat:@"%d turns", scoreInt];
    self.viewController.scoreLabel.text = _scoreText;

    [_appDelegate.saveStatus setObject:[NSString stringWithFormat:@"%d", scoreInt] forKey:@"score"];
}

- (void)setResume:(BOOL)flag {
    if (flag == YES) {
        if (![_appDelegate isResume]) {
            [_appDelegate setResume:YES];
        }
    } else {
        if ([_appDelegate isResume]) {
            [_appDelegate setResume:NO];
        }
    }
}

#pragma mark - User defined functions

- (void)popView:(UIView *)view {
    [view setHidden:NO];
    [[view layer] addAnimation:_popAnimation forKey:@"transform.scale"];
}

- (void)performAnimation {
    for (CellButton *_cell in _cells) {
        float _anamationTime = 0.01 * _cell.tag;
        [self performSelector:@selector(popView:) withObject:_cell afterDelay:_anamationTime];
    }    
}

@end
