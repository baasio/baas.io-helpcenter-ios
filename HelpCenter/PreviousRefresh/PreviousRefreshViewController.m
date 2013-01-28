//
//  PreviousRefreshViewController.m
//  helpCenter
//
//  Created by cetauri on 12. 7. 23..
//  Copyright (c) 2012년 kth. All rights reserved.
//

#define BAASIO_HELP_BACKGROUND_TASK "io.baas.helpcenter.background.task"
#import "PreviousRefreshViewController.h"

@interface PreviousRefreshViewController ()
- (void)finishReload;
@end

@implementation PreviousRefreshViewController {
    UITableView *_superTableView;
    BOOL _isRunning;
    
    PreviousUpdateBlock _previousBlocks;
}
- (id)initAtTableView:(UITableView *)tableView
        previousBlock:(void (^)(void))previousBlock{
    
    _previousBlocks = previousBlock;
    return [self initAtTableView:tableView];
}

- (id)initAtTableView:(UITableView *)tableView {
    self = [super init];
    if (self){

        if (tableView == nil) [NSException raise:@"NilFoundException"
                                          format:@"Fail to init. tableView was nil.(%@)", NSStringFromSelector(_cmd)];
        _superTableView = tableView;
        [_superTableView addSubview:self];

    }
    return self;
    
}

- (void)finishWithSuccess{
    [self finishReload];
    
}

- (void)finishWithFailure{
    [self finishReload];
}

- (void)finishReload
{
    _superTableView.contentInset = UIEdgeInsetsZero;

    dispatch_async(dispatch_queue_create(BAASIO_HELP_BACKGROUND_TASK, NULL), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            _isRunning = false;
        });
    });
}

- (void)startReloadAnimationAnimated {

    _isRunning = true;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView  {
    if (_isRunning){
        return;
    }

    CGFloat scrollHeight = scrollView.frame.size.height;
    CGFloat scrollContentHeight = scrollView.contentSize.height;  //440 = 480 - 40(table header)

    if (scrollHeight > scrollContentHeight){
        return;
    }

    if (_superTableView.frame.size.height > scrollView.contentSize.height){
        if ( scrollView.contentOffset.y + 50 > scrollView.contentSize.height){
            [self updateBefore];
        }
    } else{
        if (scrollView.contentOffset.y + _superTableView.frame.size.height + 10 > scrollView.contentSize.height) {
            [self updateBefore];
        }
    }
}

- (void)updateBefore {
    [self startReloadAnimationAnimated];

    if (_previousBlocks != nil) {
        _previousBlocks();
    }
}
@end
