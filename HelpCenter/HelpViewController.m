//
//  HelpViewController.m
//  HelpCenter
//
//  Created by Developers on 12. 10. 19..
//  Copyright (c) 2012년 kthcorp. All rights reserved.
//

#import "HelpViewController.h"
#import "AskViewController.h"
#import "UIExpandableTableView.h"
#import "GHCollapsingAndSpinningTableViewCell.h"
#import "HelpSearchViewController.h"
#import <baas.io/Baas.h>

@interface HelpViewController (){
    UIActivityIndicatorView *_indicatorView;

@private
    BOOL _didDownloadData;
    
    NSMutableArray *_dataArray;
    NSMutableArray *_expandArray;
}

@property (nonatomic, retain) NSMutableArray    *helpList;
@property (nonatomic, retain) UITableView       *helpTableView;
@property (nonatomic, retain) UISearchBar       *searchBar;


@end


@implementation HelpViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        _expandArray = [[NSMutableArray alloc] init];
        _dataArray = [[NSMutableArray alloc] init];
        self.view.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void) closeKeyboard:(id)sender {
    [_searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];

    UIBarButtonItem *seperatorItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"close"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(closeKeyboard:)];

    NSArray *array = [NSArray arrayWithObjects:seperatorItem, buttonItem, nil];
    [toolbar setItems:array];

    _searchBar.inputAccessoryView  = toolbar;
}

// Do any additional setup after loading the view.
- (void)loadView
{
    [super loadView];
    
    //< 검색 바
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 50.0f)];
    _searchBar.delegate = self;
    [_searchBar setBackgroundColor:[UIColor clearColor]];
    [_searchBar setTintColor:[UIColor lightGrayColor]];
    [_searchBar setPlaceholder:@"Search"];
    
    for (UIView * v in [_searchBar subviews]) {
        if (![v isKindOfClass:[UITextField class]]) {
            v.alpha = 0.5;
        }
    }

    //< 도움말 테이블 뷰
    _helpTableView = [[UIExpandableTableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height-44-50)
                                                            style:UITableViewStylePlain];
    _helpTableView.dataSource = self;
    _helpTableView.delegate = self;
    _helpTableView.tableHeaderView = _searchBar;
    [self.view addSubview:_helpTableView];
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, -1000, self.view.frame.size.width, 1000)];
    view.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
    [_helpTableView addSubview:view];
}

- (void)viewDidLoad;
{
    BaasioHelp *help = [[BaasioHelp alloc]init];
    [help getHelpsInBackground:^(NSArray *array) {

                 for (NSDictionary *help in array){
                     if (((NSArray *)[help objectForKey:@"helps"]).count != 0){
                         [_dataArray addObject:help];
                     }
                 }

                 for (int i = 0; i < _dataArray.count; i++) {
                     _expandArray[i] = @"false";
                 }

                 [_helpTableView reloadData];
                 [_helpTableView performSelector:@selector(expandSection:animated:) withObject:0];

                 [self.view setUserInteractionEnabled:YES];
                 [_indicatorView removeFromSuperview];
             }
             failureBlock:^(NSError *error) {

                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:@"에러가 발생하였습니다.\n다시 시도해주세요."
                                                                delegate:nil
                                                       cancelButtonTitle:@"확인"
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
    _helpList = nil;
}


#pragma mark - UIExpandableTableViewDatasource

- (BOOL)tableView:(UIExpandableTableView *)tableView canExpandSection:(NSInteger)section {
    // return YES, if the section should be expandable
    return true;
}

- (BOOL)tableView:(UIExpandableTableView *)tableView needsToDownloadDataForExpandableSection:(NSInteger)section {
    // return YES, if you need to download data to expand this section. tableView will call tableView:downloadDataForExpandableSection: for this section
    NSString *isopen ;
    if (_expandArray.count == 0){
        isopen = @"false";
    } else {
        isopen = _expandArray[section];    
    }
    
    return [isopen isEqualToString:@"false"];
}

- (UITableViewCell<UIExpandingTableViewCell> *)tableView:(UIExpandableTableView *)tableView expandingCellForSection:(NSInteger)section {
    NSString *CellIdientifier = @"GHCollapsingAndSpinningTableViewCell";
    
    GHCollapsingAndSpinningTableViewCell *cell = (GHCollapsingAndSpinningTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdientifier];
    
    if (cell == nil) {
        cell = [[GHCollapsingAndSpinningTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdientifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dictionary = _dataArray[section];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%i)", dictionary[@"name"], ((NSArray*)dictionary[@"helps"]).count];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    
    return cell;
}

#pragma mark - UIExpandableTableViewDelegate

- (void)tableView:(UIExpandableTableView *)tableView downloadDataForExpandableSection:(NSInteger)section {
    _expandArray[section] = @"true";
    [tableView expandSection:section animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *isopen = _expandArray[section];
    if([isopen isEqualToString:@"true"]){
        if (_dataArray.count == 0){
            return 1;
        }

        NSDictionary *dictionary = _dataArray[section];
        return ((NSArray*)dictionary[@"helps"]).count + 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cell.backgroundView = backgroundView;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor= [UIColor darkGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15];

    }

    if ([_expandArray[indexPath.section] isEqualToString:@"true"]) {
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryNone;

        NSDictionary *dictionary = (NSDictionary *)_dataArray[indexPath.section];
        NSArray *helps = (NSArray *)dictionary[@"helps"];
        NSDictionary *help = helps[indexPath.row - 1];

        cell.textLabel.text = help[@"title"];
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictionary = (NSDictionary *)_dataArray[indexPath.section];
    NSArray *helps = (NSArray *)dictionary[@"helps"];
    NSDictionary *help = helps[indexPath.row - 1];

    AskViewController *askVC = [[AskViewController alloc] init];
    askVC.uuid = help[@"uuid"];
    [self.navigationController pushViewController:askVC animated:YES];
}


#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];

    HelpSearchViewController *searchViewController = [[HelpSearchViewController alloc] init];
    [searchViewController setSearchText:searchBar.text];
    [self.navigationController pushViewController:searchViewController animated:YES];

}

@end
