//
//  PreviousRefreshViewController.h
//  imin-ios
//
//  Created by cetauri on 12. 7. 23..
//  Copyright (c) 2012년 kth. All rights reserved.
//

typedef void(^PreviousUpdateBlock)(void);

#define kOffsetHeight 60.0f
#import <UIKit/UIKit.h>

@interface PreviousRefreshViewController : UIView
- (id)initAtTableView:(UITableView *)tableView previousBlock:(void (^)(void))previousBlocks;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView ;
- (void)finishWithSuccess;
- (void)finishWithFailure;
@end