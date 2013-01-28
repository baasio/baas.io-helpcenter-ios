//
//  QuestionView.m
//  HelpCenter
//
//  Created by Developers on 12. 10. 18..
//  Copyright (c) 2012년 kthcorp. All rights reserved.
//

#import "QuestionView.h"
#import "QuestionFinishViewController.h"
#import <baas.io/Baas.h>

@interface QuestionView ()    {
    UIActivityIndicatorView *_indicatorView;
}

@property (nonatomic, retain) UILabel       *emailLabel;
@property (nonatomic, retain) UILabel       *contentLabel;
@property (nonatomic, retain) UILabel       *limitLabel;

@property (nonatomic, retain) UITextField    *emailTextField;
@property (nonatomic, retain) UITextView    *contentTextView;

@property (nonatomic, retain) UIButton      *submitBtn;
@property (nonatomic, retain) UIButton      *cancelBtn;

@end


@implementation QuestionView
@synthesize navigationController = _navigationController;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        //< 메일 라벨
        _emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(17.0f, 10.0f, 300.0f, 30.0f)];
        _emailLabel.text = @"E-mail 주소";
        _emailLabel.textColor = [UIColor grayColor];
        _emailLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_emailLabel];
        

        // 메일 주소
        UILabel *emailBgLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 215.0f, 30.0f)];
        emailBgLabel.layer.borderWidth = 1.0;
        emailBgLabel.layer.cornerRadius = 5.0f;
        emailBgLabel.layer.borderColor = [[UIColor grayColor] CGColor];
        emailBgLabel.clipsToBounds = YES;
        
        [self addSubview:emailBgLabel];


        _emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(20.0f, 15.0f, 200.0f, 30.0f)];
        _emailTextField.delegate = self;
        _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _emailTextField.returnKeyType = UIReturnKeyNext;
        _emailTextField.autoresizesSubviews = NO;
        _emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;

        _emailTextField.font = [UIFont systemFontOfSize:13.0];
        _emailTextField.backgroundColor = [UIColor clearColor];
        _emailTextField.tag = 300;
        _emailTextField.placeholder = @" E-mail";
        [self addSubview:_emailTextField];
        
        //
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(17.0f, 50.0f, 100.0f, 30.0f)];
        _contentLabel.text = @"문의 내용";
        _contentLabel.textColor = [UIColor grayColor];
        _contentLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_contentLabel];
        
        
        // 문의 내용
        UILabel *contentBgLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 50.0f, 300.0f, 80.0f)];
        contentBgLabel.layer.borderWidth = 1.0;
        contentBgLabel.layer.cornerRadius = 5.0f;
        contentBgLabel.layer.borderColor = [[UIColor grayColor] CGColor];
        contentBgLabel.clipsToBounds = YES;
        
        [self addSubview:contentBgLabel];

        _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 50.0f, 300.0f, 80.0f)];
        _contentTextView.delegate = self;
        _contentTextView.keyboardType = UIKeyboardTypeDefault;
        _contentTextView.returnKeyType = UIReturnKeyDefault;
        _contentTextView.showsHorizontalScrollIndicator = NO;
        _contentTextView.alwaysBounceVertical = YES;
        _contentTextView.font = [UIFont systemFontOfSize:13.0];
        _contentTextView.backgroundColor = [UIColor clearColor];
        _contentTextView.tag = 301;
        
        [self addSubview:_contentTextView];
        
        
        //< 글자수 라벨
        _limitLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 130, 280.0f, 20.0f)];
        _limitLabel.backgroundColor = [UIColor clearColor];
        _limitLabel.text = @"0/1000";
        _limitLabel.textAlignment = NSTextAlignmentRight;
        _limitLabel.textColor = [UIColor cyanColor];
        _limitLabel.font = [UIFont systemFontOfSize:13.0f];
        _limitLabel.alpha = 0.7f;

        [self addSubview:_limitLabel];

        // 전송 버튼
        _submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _submitBtn.frame = CGRectMake(230.0f, 10.0f, 80.0f, 30.0f);
        [_submitBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [_submitBtn setTitle:@"문의하기" forState:UIControlStateNormal];
        _submitBtn.tag = 200;
        [self addSubview:_submitBtn];
        
        
        UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 170.0f, 300.0f, 40.0f)];
        noticeLabel.text = @"* 정확한 답변을 위해 모바일 정보(Device, OS)와\n   E-mail 주소가 저장됩니다.";
        noticeLabel.textColor = [UIColor whiteColor];
        noticeLabel.backgroundColor = [UIColor clearColor];
        noticeLabel.font = [UIFont systemFontOfSize:13.0f];
        noticeLabel.numberOfLines = 2;
        noticeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self addSubview:noticeLabel];
    }
    return self;
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_contentTextView becomeFirstResponder];

    return YES;
}

#pragma mark - TextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    switch (textView.tag) {
        case 300:
            _emailLabel.hidden = YES;
            break;
            
        case 301:
            _contentLabel.hidden = YES;
            break;
            
        default:
            break;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if(textView.tag == 301) {
        
        _limitLabel.text = [NSString stringWithFormat:@"%d/1000", textView.text.length];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    switch (textView.tag) {
        case 300:
            
            if ([text isEqualToString:@"\n"]) {
                
                [_contentTextView becomeFirstResponder];
                return NO;
            }

            break;
            
        case 301:
            
            if (text.length + textView.text.length > 1000) {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"허용 문자수를 초과하였습니다."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"확인"
                                                          otherButtonTitles:nil];
                [alertView show];
                return NO;
            }
            break;
            
        default:
            break;
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    if([textView.text isEqualToString:@""]) {
        
        switch (textView.tag) {
            case 300:
                _emailLabel.hidden = NO;
                break;
                
            case 301:
                _contentLabel.hidden = NO;
                break;
                
            default:
                break;
        }
    }
    
    return YES;
}


#pragma mark Button Selector

- (void)onButton:(UIButton *)btn {
    
    // 공란 체크
    if(_emailTextField.text.length == 0) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"메일주소를 입력하세요."
                                                       delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil, nil];
        alert.tag = 401;
        [alert show];

        return;
    }


    // 이메일 형식 체크
    if(![self validateEmailWithString:_emailTextField.text]) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"메일주소 형식에 맞춰주세요."
                                                       delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil, nil];
        alert.tag = 401;
        [alert show];

        return;
    }


    if(_contentTextView.text.length == 0) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"내용을 입력하세요."
                                                       delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil, nil];
        alert.tag = 402;
        [alert show];

        return;
    }

    [_emailTextField resignFirstResponder];
    [_contentTextView resignFirstResponder];

    // 등록 확인 경고창
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"등록 하시겠습니까?"
                                                   delegate:self
                                          cancelButtonTitle:@"취소"
                                          otherButtonTitles:@"확인", nil];
    alert.tag = 400;
    [alert show];
}


#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (alertView.tag) {
            
        case 400:       // 등록 확인 경고창
            
            if(buttonIndex == 1) {

                UIDevice *currentDevice = [UIDevice currentDevice];
                NSDictionary *param = @{
                    @"email" : _emailTextField.text,
                    @"content" : _contentTextView.text,
                    @"temporary_answer" : @"temporary_answer",  //
                    @"classification_id" : @"classification_id",//
                    @"satisfaction_level_id" : @"satisfaction_level_id",//
                    @"status_id" : @"status_id",//
                    @"device_info" : currentDevice.model,           // e.g. @"iPhone", @"iPod touch"
                    @"official" : @"official",//
                    @"publicaccessable" : @"publicaccessable",//
                    @"app_info" : [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"], //
                    @"os_info" : currentDevice.systemVersion,       // e.g. @"4.0"
                    @"platform" : currentDevice.systemName,//
                    @"vote" : @"1",
                    @"tags" : @"아야, 어여, 오요,우유"
                };

                NSLog(@"localizedModel : %@", currentDevice.localizedModel);

                NSLog(@"param : %@", param.description);


                BaasioHelp *help = [[BaasioHelp alloc] init];
                [help sendQuestionInBackground:_emailTextField.text
                                       content:_contentTextView.text
                                  successBlock:^(void) {
                                      QuestionFinishViewController *subVC = [[QuestionFinishViewController alloc] init];
                                      subVC.email = _emailTextField.text;
                                      [self.navigationController pushViewController:subVC animated:YES];

                                      [self resetAskView];

                                      [self setUserInteractionEnabled:YES];
                                      [_indicatorView removeFromSuperview];
                                  }
                                  failureBlock:^(NSError *error) {
                                      NSLog(@"%@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);

                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"에러가 발생하였습니다.\n다시 시도해주세요."
                                                                                     delegate:nil cancelButtonTitle:@"확인"
                                                                            otherButtonTitles:nil, nil];
                                      [alert show];

                                      [self setUserInteractionEnabled:YES];
                                      [_indicatorView removeFromSuperview];
                                  }];


                [self setUserInteractionEnabled:NO];

                _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                _indicatorView.center = self.center;
                [self addSubview:_indicatorView];
                [_indicatorView startAnimating];
            }
            break;
            
        case 401:       // 이메일 주소 공란/이상
            
            [_emailTextField becomeFirstResponder];
            break;
            
        case 402:       // 문의 내용 공란
            
            [_contentTextView becomeFirstResponder];
            break;
            
        default:
            break;
    }
}

// 이메일 형식 체크
- (BOOL)validateEmailWithString:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}


- (void)resetAskView {
    
    _emailTextField.text = @"";
    _contentTextView.text = @"";
    _limitLabel.text = @"0/1000";
    
    _emailLabel.hidden = NO;
    _contentLabel.hidden = NO;
    
    [_contentTextView resignFirstResponder];
    [_emailTextField resignFirstResponder];
}

@end
