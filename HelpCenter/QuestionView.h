//
//  QuestionView.h
//  HelpCenter
//
//  Created by Developers on 12. 10. 18..
//  Copyright (c) 2012년 kthcorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface QuestionView : UIView <UITextViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property(nonatomic, strong) UINavigationController *navigationController;

- (void)resetAskView;

@end
