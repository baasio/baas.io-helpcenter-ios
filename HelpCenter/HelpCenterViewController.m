//
//  HelpCenterViewController.m
//  HelpCenter
//
//  Created by Developers on 12. 10. 10..
//  Copyright (c) 2012년 kthcorp. All rights reserved.
//

#import "HelpCenterViewController.h"
#import "HelpViewController.h"
#import "QuestionViewController.h"

#define BTNVIEW_H       50.0f

@interface HelpCenterViewController ()

@property (nonatomic, retain) HelpViewController    *helpViewController;
@property (nonatomic, retain) QuestionViewController *questionViewController;
@property (nonatomic, assign) NSInteger         childViewIdx;

@property (nonatomic, retain) HelpButtonView    *helpBtnView;

@end


@implementation HelpCenterViewController


- (id)init
{
    self = [super init];
    if (self)
    {
        [self setTitle:@"HelpCenter"];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"모바일 고객센터";
    [self.navigationController.navigationItem.backBarButtonItem setTitle:@"Back"];

    
    CGRect rect = self.view.frame;
    
    _helpBtnView = [[HelpButtonView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, rect.size.width, BTNVIEW_H)];
    _helpBtnView.delegate = self;

    [self.view addSubview:_helpBtnView];

    _helpViewController = [[HelpViewController alloc] init];
    _helpViewController.view.frame = CGRectMake(0.0f, 44.0f + BTNVIEW_H, 320.0f, rect.size.height - (44.0f + BTNVIEW_H));

    [self addChildViewController:_helpViewController];
    [self.view addSubview:_helpViewController.view];
    
    self.childViewIdx = [[self childViewControllers] indexOfObject:_helpViewController];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - HelpButtonViewDelegate

/// 탭 버튼 선택 시
- (void)didTouchedButton:(NSInteger)tag
{
    UIViewController *fromVC = nil;
    UIViewController *toVC = nil;

    
    switch (tag)
    {
        case 100:
            {
                if (!_helpViewController) {
                    _helpViewController = [[HelpViewController alloc] init];
                }
                
                NSLog(@"current child index = %d", self.childViewIdx);

                fromVC = [self.childViewControllers objectAtIndex:self.childViewIdx];
                toVC = _helpViewController;

            }
            break;
            
        case 101:
            {
                
                if (!_questionViewController) {
                    _questionViewController = [[QuestionViewController alloc] init];
                }
                
                fromVC = [self.childViewControllers objectAtIndex:self.childViewIdx];
                toVC = _questionViewController;
                
            }
            break;

        default:
            break;
    }

    if (fromVC != nil) {
        [self transitionFromViewController:fromVC toViewController:toVC];
    }

}

- (void)transitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
	if (fromViewController == toViewController)
	{
		// cannot transition to same
		return;
	}
    
	// animation setup
    toViewController.view.frame = CGRectMake(0.0f, 44.0f + BTNVIEW_H, 320.0f, self.view.frame.size.height - (44.0f + BTNVIEW_H));
	toViewController.view.autoresizingMask = self.view.autoresizingMask;
    
	// notify
	[fromViewController willMoveToParentViewController:nil];
	[self addChildViewController:toViewController];

	// transition
	[self transitionFromViewController:fromViewController
					  toViewController:toViewController
							  duration:0.2
							   options:UIViewAnimationOptionTransitionNone
							animations:^{

							}
							completion:^(BOOL finished) {
                                
                                [self.view addSubview:toViewController.view];

								[toViewController didMoveToParentViewController:self];
								[fromViewController removeFromParentViewController];
                                
                                self.childViewIdx = [[self childViewControllers] indexOfObject:toViewController];
                                NSLog(@"changed child index = %d", self.childViewIdx);

							}];
}

@end
