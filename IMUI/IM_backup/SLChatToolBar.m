//
//  SLChatToolBar.m
//  Sherlock
//
//  Created by knight on 15/9/17.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

#import "SLChatToolBar.h"
#import "SLChatTextView.h"
#import "SLChatMoreView.h"
#define kToolBarMaxHeight 100
#define kInputViewInceasementHeight 10
@interface SLChatToolBar ()<UITextViewDelegate>
@property (nonatomic , strong) UIButton * speechButton;
@property (nonatomic , strong) UIButton * moreButton;
@property (nonatomic , strong) UITextView * inputView;
@property (nonatomic , strong) UIButton * speekingButton;
@property (nonatomic , assign) CGFloat moreViewHeight;
@property (nonatomic , assign) CGFloat previousContentSizeHeight;
@end

@implementation SLChatToolBar
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
    {
        _previousContentSizeHeight = 0;
        _moreViewHeight = kMoreView_height;
        [self configSubViews];
        [self makeConstrains];
    }
    return self;
}

- (void)setDelegate:(id<SLChatToolBarDelegate>)delegate {
    _delegate = delegate;
}

- (void)speechAction:(UIButton *)sender {
    NSLog(@"speech button is clicked!");
    self.speechButton.selected = !self.speechButton.selected;
    self.moreButton.selected = NO;
    if (self.speechButton.selected) {
        if ([self.inputView isFirstResponder]) {
            [self.inputView resignFirstResponder];
        }
        [self notifyToolBarWillChangeHeight:kToolBarHeight];
    }else {
        [self.inputView becomeFirstResponder];
        [self notifyToolBarWillChangeHeight:self.previousContentSizeHeight==0?kToolBarHeight:self.previousContentSizeHeight];

    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSpeechButtonClicked:)]) {
        [self.delegate didSpeechButtonClicked:sender];
    }
}

- (void)moreButtonAction:(UIButton *)sender {
    NSLog(@"more button is clicked!");
    self.speechButton.selected = NO;
    self.moreButton.selected = !self.moreButton.selected;
    //TODO 在这里控制moreView的出现与退出
    if (self.moreButton.selected) {
        [self.inputView resignFirstResponder];
        if (self.delegate && [self.delegate respondsToSelector:@selector(moreViewWillAppear:)]){
            [self.delegate moreViewWillAppear:kMoreView_height];
        }
    }else {
        [self.inputView becomeFirstResponder];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didMoreButtonClicked:)]) {
        [self.delegate didMoreButtonClicked:sender];
    }
}

#pragma mark - private methods
- (void)configSubViews {
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
   _speechButton = [SLTools createButtonWithtarget:self selector:@selector(speechAction:) backgroudImg:nil];
    [_speechButton setBackgroundImage:[UIImage imageNamed:@"im_voice"] forState:UIControlStateNormal];
    [_speechButton setBackgroundImage:[UIImage imageNamed:@"im_keyboard"] forState:UIControlStateSelected];
    _moreButton = [SLTools createButtonWithtarget:self selector:@selector(moreButtonAction:) backgroudImg:nil];
    [_moreButton setBackgroundImage:[UIImage imageNamed:@"im_more"] forState:UIControlStateNormal];
    [_moreButton setBackgroundImage:[UIImage imageNamed:@"im_keyboard"] forState:UIControlStateSelected];
    _inputView = [[UITextView alloc] initWithFrame:CGRectZero];
    _inputView.font = [UIFont systemFontOfSize:16.f];
    _inputView.layer.cornerRadius = 3.0f;
    _inputView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _inputView.layer.borderWidth = 0.5f;
    _inputView.backgroundColor = HYHexToRGB(0xf5f5f5);
    _inputView.delegate = self;
    [self addSubview:_inputView];
    [self addSubview:_speechButton];
    [self addSubview:_moreButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)makeConstrains {
    WeakSelf(weakself)
    [_speechButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@25);
        make.left.equalTo(@10);
        make.centerY.equalTo(weakself);
    }];
    
    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@25);
        make.right.equalTo(weakself).offset(-10);
        make.centerY.equalTo(weakself);
    }];
    
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.speechButton.mas_right).offset(5);
        make.right.equalTo(weakself.moreButton.mas_left).offset(-5);
        make.centerY.equalTo(weakself);
        make.bottom.equalTo(weakself).offset(-5);
        make.top.equalTo(weakself).offset(5);
    }];
}

- (void)notifyToolBarWillChangeHeight:(CGFloat) height {
    if (self.delegate && [self.delegate respondsToSelector:@selector(toolBarWillChangeHeight:keyboardHeight:)]) {
        [self.delegate toolBarWillChangeHeight:height keyboardHeight:self.moreViewHeight];
    }
}

#pragma mark - UITextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView {
    [textView becomeFirstResponder];
    NSLog(@"hehe %f",self.inputView.contentSize.width);
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"] /*&& ![self.inputView.text isEqualToString:@""]*/) {
        if ([self.inputView.text isEqualToString:@""]) return NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSendText:)]) {
            [self.delegate didSendText:self.inputView.text];
            textView.text = @"";
            [self notifyToolBarWillChangeHeight:self.inputView.contentSize.height+kInputViewInceasementHeight];
        }
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView {
    if (self.previousContentSizeHeight != textView.contentSize.height) {
        if (self.previousContentSizeHeight < kToolBarMaxHeight) {
            self.previousContentSizeHeight = textView.contentSize.height;
            if (self.previousContentSizeHeight > textView.frame.size.height){
                NSLog(@"height = %f", textView.frame.size.height);
                NSLog(@"sizeHeight = %f",self.previousContentSizeHeight);
                [self notifyToolBarWillChangeHeight:self.inputView.contentSize.height+kInputViewInceasementHeight];
            }
        }
        
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
}
#pragma mark - keyboard notifications
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary * userinfo = notification.userInfo;
    NSValue * value = [userinfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [value CGRectValue];
    self.moreViewHeight = rect.size.height;
    NSLog(@"moveviewHeight = %f",self.moreViewHeight);
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreViewWillAppear:)]) {
        [self.delegate moreViewWillAppear:self.moreViewHeight];
    };
}

- (void)keyboardDidHide:(NSNotification *)notification {
    self.moreViewHeight = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreViewDidDisappear:)]) {
        [self.delegate moreViewDidDisappear:self.moreViewHeight];
    };
}
@end
