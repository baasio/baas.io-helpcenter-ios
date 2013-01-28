//
//  QuestionFinishViewController.m
//  HelpCenter
//
//  Created by cetauri on 12/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestionFinishViewController.h"
#import "HelpCenterViewController.h"

@interface QuestionFinishViewController (){
    UITableView *_tableView ;
}

@end

@implementation QuestionFinishViewController
@synthesize email = _email;

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"문의 결과";
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        CGRect frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return self;
}


#pragma mark -UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 200;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    footerView.backgroundColor = [UIColor clearColor];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 320 - 20, 30)];
    [label setBackgroundColor:[UIColor clearColor]];
    label.text = @"고객님의 메일 문의가 접수 되었습니다.";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor darkGrayColor];
    [footerView addSubview:label];

    return footerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    footerView.backgroundColor = [UIColor clearColor];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton.frame = CGRectMake(10, 10, 300, 44);
    [loginButton setTitle:@"확인" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(finishButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    loginButton.tag = 3;
    [footerView addSubview:loginButton];
    
    return footerView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"resultCell";
    
    UITableViewCell *resultCell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (resultCell == nil) {
        resultCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        resultCell.selectionStyle = UITableViewCellSelectionStyleNone;
        resultCell.textLabel.font = [UIFont boldSystemFontOfSize:13];
        resultCell.textLabel.textColor = [UIColor darkGrayColor];

        switch (indexPath.row){
            case 0:
            {
                NSDate *today = [NSDate date];

                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                NSTimeZone *timeZone = [NSTimeZone localTimeZone];
                [dateFormatter setTimeZone:timeZone];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *dateString = [dateFormatter stringFromDate:today];

                resultCell.textLabel.text = [NSString stringWithFormat:@"접수 일시 : %@", dateString];
                break;
            }
            case 1:
                resultCell.textLabel.text = [NSString stringWithFormat:@"회신 메일 : %@", _email];
                break;
        }
    }
    
    return resultCell;
}

#pragma mark - event

- (void)finishButtonPressed
{
    for (UIViewController *controller in self.navigationController.viewControllers){
        NSLog(@"controller : %@", controller.description);
        if ([controller isKindOfClass:[HelpCenterViewController class]]){
            [((HelpCenterViewController *) controller) didTouchedButton:100];


            for (UIView *view in [controller.view subviews]){
                if ([view isKindOfClass:[HelpButtonView class]]){
                    [((HelpButtonView *) view) onSelectButton:100];
                }
            }
        }
    }
    [self.navigationController popViewControllerAnimated:NO];

}

@end