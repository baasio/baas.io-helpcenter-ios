//
//  HelpButtonView.h
//  HelpCenter
//
//  Created by Developers on 12. 10. 18..
//  Copyright (c) 2012년 kthcorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HelpButtonViewDelegate <NSObject>

- (void)didTouchedButton:(NSInteger)tag;

@end

@interface HelpButtonView : UIView

@property (nonatomic, assign) id <HelpButtonViewDelegate> delegate;

- (void)onSelectButton:(int)tag;
@end
