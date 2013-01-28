//
//  RootViewController.m
//  HelpCenter
//
//  Created by Developers on 12. 10. 10..
//  Copyright (c) 2012년 kthcorp. All rights reserved.
//

#import "RootViewController.h"
#import "HelpCenterViewController.h"
#import <baas.io/Baas.h>

@interface RootViewController (){
    UITableView *_tableView;
}
@end

@implementation RootViewController

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)loadView
{
    [super loadView];

    self.title = @"메인";
    self.view.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:1.0f];
    
    self.navigationController.navigationBar.translucent = YES;


    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

    // 고객센터 버튼 추가
    CGRect frame = self.view.frame;

    UIButton *helpCenterBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [helpCenterBtn setFrame:CGRectMake((frame.size.width - 120) / 2, 250.0, 120, 33)];
    [helpCenterBtn addTarget:self action:@selector(onHelpCenter) forControlEvents:UIControlEventTouchUpInside];
    [helpCenterBtn setTitle:@"고객센터" forState:UIControlStateNormal];
    [_tableView addSubview:helpCenterBtn];
}

- (void) closeKeyboard:(id)sender {
    for (int i = 0 ;i <= 40;i+=10){
        [((UITextField *)[self.view viewWithTag:i]) resignFirstResponder];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];

    UIBarButtonItem *seperatorItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"close"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(closeKeyboard:)];

    NSArray *array = [NSArray arrayWithObjects:seperatorItem, buttonItem, nil];
    [toolbar setItems:array];

    textField.inputAccessoryView  = toolbar;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    NSString *textLabel = nil;
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, 200, 44)];
    field.delegate = self;

    if (indexPath.section == 0){
        if (indexPath.row == 0){
            textLabel = @"baas.io ID";
            field.tag = 10;
            field.text = @"";
        } else{
            textLabel = @"App ID";
            field.text = @"sandbox";
            field.tag = 20;
        }

    } else{
        if (indexPath.row == 0){
            textLabel = @"User ID";
            field.tag = 30;
            field.text = @"";
        } else{
            textLabel = @"Password";
            field.tag = 40;
            field.text = @"";
            field.secureTextEntry = YES;
        }

    }
    cell.textLabel.text = textLabel;
    [cell addSubview:field];

    return cell;
}


#pragma mark - UIEvents

/// 고객센터 시작 버튼
- (void)onHelpCenter
{
    NSString *baasID = ((UITextField *)[self.view viewWithTag:10]).text;
    NSString *appID = ((UITextField *)[self.view viewWithTag:20]).text;
    NSString *userID = ((UITextField *)[self.view viewWithTag:30]).text;
    NSString *password = ((UITextField *)[self.view viewWithTag:40]).text;

    [Baasio setApplicationInfo:baasID applicationName:appID];

    [BaasioUser signInBackground:userID
                        password:password
                    successBlock:^(void){
                        HelpCenterViewController *mainVC = [[HelpCenterViewController alloc] init];
                        [self.navigationController pushViewController:mainVC animated:YES];
                    }
                    failureBlock:^(NSError *error){
                        NSLog(@"e : %@", error.localizedDescription);
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                        message:@"에러가 발생하였습니다.\n다시 시도해주세요."
                                                                       delegate:nil
                                                              cancelButtonTitle:@"확인"
                                                              otherButtonTitles:nil, nil];
                        [alert show];

                    }];
}

@end
