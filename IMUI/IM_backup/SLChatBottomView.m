//
//  SLChatBottomView.m
//  IMUI
//
//  Created by knight on 15/11/3.
//  Copyright © 2015年 bj.58.com. All rights reserved.
//

#import "SLChatBottomView.h"

@interface SLChatBottomView ()<SLChatToolBarDelegate,SLChatMoreViewDelegate>
    
@property(nonatomic , strong , readwrite)SLChatToolBar * toolBar;
@property(nonatomic , strong)SLChatMoreView * moreView;
@property(nonatomic , assign)CGFloat toolBarHeight;
@end

@implementation SLChatBottomView
- (instancetype)init {
    if (self = [super init]) {
        _toolBarHeight = kToolBarHeight;
        [self configSubviews];
    }
    return self;
}


- (void)configSubviews {
    _toolBar = [[SLChatToolBar alloc] initWithFrame:CGRectZero];
    _moreView = [[SLChatMoreView alloc] initWithFrame:CGRectZero];
    _toolBar.backgroundColor = [UIColor whiteColor];
    _toolBar.delegate = self;
    _moreView.backgroundColor = [UIColor whiteColor];
    _moreView.delegate = self;
    [self addSubviews];
    [self makeConstraints];
}

- (void)addSubviews {
    [self addSubview:_toolBar];
    [self addSubview:_moreView];
}

- (void)makeConstraints {
    [_toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(kToolBarHeight);
    }];
    [_moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolBar.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(kMoreView_height);
    }];
}

- (void)bottomViewDisAppear {
    [self moreViewDidDisappear:kMoreView_height];
}

#pragma mark - SLChatToolBarDelegate
- (void)toolBarWillChangeHeight:(CGFloat)height keyboardHeight:(CGFloat)keyboardHeight {
    self.toolBarHeight = height;
    CGFloat totalHeight = height + keyboardHeight;
    [_toolBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(totalHeight);
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomViewWillAppear:)]) {
        [self.delegate bottomViewWillAppear:totalHeight];
    }
}

- (void)moreViewDidDisappear:(CGFloat)height {
    [_moreView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (height == 0) {
            make.height.mas_equalTo(kMoreView_height);
        }else {
            make.height.mas_equalTo(height);
        }
    }];
    CGFloat totalHeight = height + self.toolBarHeight;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(totalHeight);
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomViewWillDisAppear:)]) {
        [self.delegate bottomViewWillDisAppear:totalHeight];
    }
}

- (void)moreViewWillAppear:(CGFloat)height {
    [_moreView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (height == 0) {
            make.height.mas_equalTo(kMoreView_height);
        }else
            make.height.mas_equalTo(height);
    }];
    CGFloat totalHeight = height + self.toolBarHeight;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(totalHeight);
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomViewWillAppear:)]) {
        [self.delegate bottomViewWillAppear:totalHeight];
    }
}

- (void)didSendText:(NSString *)text {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSendText:)]){
        [self.delegate didSendText:text];
    }
}

#pragma mark - SLChatToolBarDelegate 
- (void)didSpeechButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSpeechButtonClicked:)]) {
        [self.delegate didSpeechButtonClicked:sender];
    }
}

- (void)didMoreButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didMoreButtonClicked:)]) {
        [self.delegate didMoreButtonClicked:sender];
    }
}
#pragma mark - SLChatMoreViewDelegate

- (void)didSendContractButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSendContractButtonClicked:)]) {
        [self.delegate didSendContractButtonClicked:sender];
    }
}

- (void)didSendLocationButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSendLocationButtonClicked:)]) {
        [self.delegate didSendLocationButtonClicked:sender];
    }
}

- (void)didSendPicButtonClicked:(UIButton *)sender {
    if  (self.delegate && [self.delegate respondsToSelector:@selector(didSendPicButtonClicked:)]) {
        [self.delegate didSendPicButtonClicked:sender];
    }
}

- (void)didSendVideoButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSendVideoButtonClicked:)]) {
        [self.delegate didSendVideoButtonClicked:sender];
    }
}

#pragma mark - getters & setters
- (void)setDelegate:(id<SLChatBottomViewDelegate>)delegate {
    _delegate = delegate;
    _moreView.delegate = delegate;
}


@end
