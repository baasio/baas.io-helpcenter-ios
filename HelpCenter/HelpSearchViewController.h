//
//  HelpSearchViewController.h
//  HelpCenter
//
//  Created by Developers on 12. 10. 19..
//  Copyright (c) 2012년 kthcorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpSearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) NSString  *searchText;
@end
