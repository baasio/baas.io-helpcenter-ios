//
//  QuestionViewController.m
//  HelpCenter
//
//  Created by 채 선옥 on 12. 10. 19..
//  Copyright (c) 2012년 kthcorp. All rights reserved.
//

#import "QuestionViewController.h"
#import "QuestionView.h"

@interface QuestionViewController ()
@property (nonatomic, retain) QuestionView  *questionView;
@end


@implementation QuestionViewController


- (id)init
{
    self = [super init];
    if (self)
    {
        self.view.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

	// Do any additional setup after loading the view.
- (void)loadView
{
    [super loadView];
    
    //< 문의하기 뷰
    _questionView = [[QuestionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, self.view.bounds.size.height)];
    _questionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_questionView];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
     _questionView.navigationController =  self.navigationController;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.questionView resetAskView];
}

@end
