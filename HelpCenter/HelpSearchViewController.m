//
//  HelpViewController.m
//  HelpCenter
//
//  Created by Developers on 12. 10. 19..
//  Copyright (c) 2012년 kthcorp. All rights reserved.
//

#import "HelpSearchViewController.h"
#import "AskViewController.h"
#import <baas.io/Baas.h>

@interface HelpSearchViewController (){
    UIActivityIndicatorView *_indicatorView;
}

@property (nonatomic, retain) NSMutableArray    *helpList;
@property (nonatomic, retain) UITableView       *helpTableView;

@end


@implementation HelpSearchViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.view.backgroundColor = [UIColor grayColor];
        _helpList = [[NSMutableArray alloc] init];
    }
    return self;
}

	// Do any additional setup after loading the view.
- (void)loadView
{
    [super loadView];
    
    //< 도움말 테이블 뷰
    _helpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, self.view.bounds.size.width, self.view.bounds.size.height-44) style:UITableViewStylePlain];
    _helpTableView.dataSource = self;
    _helpTableView.delegate = self;

    [self.view addSubview:_helpTableView];
}

- (void)viewDidAppear:(BOOL)animated {

    if (_helpList.count != 0)
        return;

    BaasioHelp *help = [[BaasioHelp alloc]init];
    [help searchHelpsInBackground:_searchText
         successBlock:^(NSArray *array) {
             for (NSDictionary *help in array) {
                 NSArray *helps = help[@"helps"];
                 [_helpList addObjectsFromArray:helps];
             }
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

- (void)viewDidUnload
{
    [_helpList removeAllObjects];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _helpList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cell.backgroundView = backgroundView;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor= [UIColor darkGrayColor];
    }

    NSDictionary *help = (NSDictionary *)_helpList[indexPath.row];
    cell.textLabel.text = help[@"title"];

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *help = (NSDictionary *)_helpList[indexPath.section];

    AskViewController *askVC = [[AskViewController alloc] init];
    askVC.uuid = help[@"uuid"];
    [self.navigationController pushViewController:askVC animated:YES];
}

@end
