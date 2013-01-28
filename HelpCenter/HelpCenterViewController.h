//
//  HelpCenterViewController.h
//  HelpCenter
//
//  Created by Developers on 12. 10. 10..
//  Copyright (c) 2012년 kthcorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpButtonView.h"

@interface HelpCenterViewController : UIViewController <HelpButtonViewDelegate, UITableViewDelegate, UITableViewDataSource>
- (void)didTouchedButton:(NSInteger)tag;

@end
