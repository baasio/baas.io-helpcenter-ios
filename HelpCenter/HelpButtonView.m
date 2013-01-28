//
//  HelpButtonView.m
//  HelpCenter
//
//  Created by Developers on 12. 10. 18..
//  Copyright (c) 2012년 kthcorp. All rights reserved.
//

#import "HelpButtonView.h"


@interface HelpButtonView ()

@property (nonatomic, retain) UIButton *helpBtn;        //< 도움말
@property (nonatomic, retain) UIButton *askBtn;         //< 문의하기
@property (nonatomic, retain) UIButton *historyBtn;     //< 문의내역

@end


@implementation HelpButtonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];

        CGFloat pointX = 10.0f;
        
        //< 도움말 버튼
        _helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _helpBtn.frame = CGRectMake(pointX, 10.0f, 150.0f, 28.0f);
//        _helpBtn.backgroundColor = [UIColor grayColor];
        _helpBtn.titleLabel.font = [UIFont systemFontOfSize:15];

        [self selectTabButton:_helpBtn];

        [_helpBtn setTitle:@"도움말" forState:UIControlStateNormal];
        [_helpBtn addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
        _helpBtn.tag = 100;
        _helpBtn.selected = YES;
        
        [self addSubview:_helpBtn];
        pointX += 150.0f;
        
        
        //< 문의하기 버튼
        _askBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _askBtn.frame = CGRectMake(pointX, 10.0f, 150.0f, 28.0f);
        _askBtn.backgroundColor = [UIColor grayColor];
        _askBtn.titleLabel.font = [UIFont systemFontOfSize:15];

        [self deselectTabButton:_askBtn];

        [_askBtn setTitle:@"문의하기" forState:UIControlStateNormal];
        [_askBtn addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
        _askBtn.tag = 101;
        _askBtn.selected = NO;
        
        [self addSubview:_askBtn];
        pointX += 100.0f;
        
//
//        //< 문의내역 버튼
//        _historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _historyBtn.frame = CGRectMake(pointX, 10.0f, 100.0f, 28.0f);
//        [_historyBtn setImage:[UIImage imageNamed:@"button_normal_03.png"] forState:UIControlStateNormal];
//        [_historyBtn setImage:[UIImage imageNamed:@"button_selected_03.png"] forState:UIControlStateSelected];
//        [_historyBtn setTitle:@"문의내역" forState:UIControlStateNormal];
//        [_historyBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        [_historyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
//        [_historyBtn addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
//        _historyBtn.tag = 102;
//        _historyBtn.selected = NO;
//
//        [self addSubview:_historyBtn];
        
        UILabel *lineView = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.bounds.size.height - 1.0f, self.bounds.size.width, 1.0f)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        
        [self addSubview:lineView];
        
    }
    return self;
}

- (void)onSelectButton:(int)tag{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = tag;
    [self onClickButton:button];
}

- (void)onClickButton:(UIButton *)button
{
    [self deselectTabButton:_helpBtn];
    [self deselectTabButton:_askBtn];
    [self deselectTabButton:_historyBtn];

    switch (button.tag) {
            
        case 100:
        {
            _helpBtn.selected = YES;
            _askBtn.selected = NO;
            _historyBtn.selected = NO;

            [self selectTabButton:_helpBtn];
        }
            break;
            
        case 101:
            
            _helpBtn.selected = NO;
            _askBtn.selected = YES;
            _historyBtn.selected = NO;
            [self selectTabButton:_askBtn];
            break;
            
        case 102:
        {
            _helpBtn.selected = NO;
            _askBtn.selected = NO;
            _historyBtn.selected = YES;
            [self selectTabButton:_historyBtn];
        }
            break;
            
        default:
            break;
    }
    
    if([_delegate respondsToSelector:@selector(didTouchedButton:)]) {
        
        [_delegate didTouchedButton:button.tag];
    }
}

- (void)selectTabButton:(UIButton *)button {
    UIImage *image = [[UIImage imageNamed:@"TAB_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateHighlighted];

    [button setTitleShadowColor:[UIColor colorWithWhite:0.0f alpha:0.5f] forState:UIControlStateNormal];

    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor colorWithWhite:0.0f alpha:0.5f] forState:UIControlStateNormal];
}

- (void)deselectTabButton:(UIButton *)button {
    UIImage *image = [[UIImage imageNamed:@"TAB_inactive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateHighlighted];

    [button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor colorWithWhite:0.0f alpha:0.5f] forState:UIControlStateNormal];
}

@end
