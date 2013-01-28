//
//  AskViewController.m
//  HelpCenter
//
//  Created by 채 선옥 on 12. 10. 19..
//  Copyright (c) 2012년 kthcorp. All rights reserved.
//

#import "AskViewController.h"
#import <baas.io/Baas.h>
#define DEFAULT_FONT 13.0f

@interface AskViewController ()    {
    UIActivityIndicatorView *_indicatorView;
    NSDictionary *helps;
}

@property (nonatomic, retain) UITableView       *helpTableView;

@end

@implementation AskViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"상세 도움말";
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"back"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(onBack)];
    [self.navigationItem setBackBarButtonItem:backBtnItem];

    
    //< 도움말 테이블 뷰
    _helpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, self.view.bounds.size.width, self.view.bounds.size.height - 44.0f) style:UITableViewStyleGrouped];
    _helpTableView.dataSource = self;
    _helpTableView.delegate = self;
    _helpTableView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_helpTableView];

}

- (void)viewWillAppear:(BOOL)animated
{
    BaasioHelp *help = [[BaasioHelp alloc] init];
    [help getHelpDetailInBackground:_uuid
           successBlock:^(NSDictionary *dictionary) {
               NSLog(@"dictionary : %@", dictionary.description);
               helps = dictionary;
               [_helpTableView reloadData];

               [self.view setUserInteractionEnabled:YES];
               [_indicatorView removeFromSuperview];
           }
           failureBlock:^(NSError *error) {

               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"에러가 발생하였습니다.\n다시 시도해주세요."
                                                              delegate:nil cancelButtonTitle:@"확인"
                                                     otherButtonTitles:nil, nil];
               [alert show];


               [self.view setUserInteractionEnabled:YES];
               [_indicatorView removeFromSuperview];
           }];

    [self.view setUserInteractionEnabled:NO];

    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.center = _helpTableView.center;
    [_helpTableView addSubview:_indicatorView];
    [_indicatorView startAnimating];
}

#pragma mark - UI Event(s)

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableView delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return @"Question";
    else
        return @"Answer";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *identifier = @"helpList";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

     if (!cell) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
         cell.textLabel.numberOfLines = 0;
     }

    if (indexPath.section == 0){
        cell.textLabel.text = helps[@"title"];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:DEFAULT_FONT];
    } else if (indexPath.section == 1){
        cell.textLabel.text = helps[@"content"];
        cell.textLabel.font = [UIFont systemFontOfSize:DEFAULT_FONT];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text;
    if (indexPath.section == 0){
        text = helps[@"title"];
    } else if (indexPath.section == 1){
        text = helps[@"content"];
    }
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:DEFAULT_FONT]
                   constrainedToSize:CGSizeMake(285, CGFLOAT_MAX)
                       lineBreakMode:NSLineBreakByWordWrapping];

    return size.height + 50;
}

@end
