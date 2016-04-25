//
//  SLChatMoreView.m
//  Sherlock
//  "+"号点开之后展示的view
//  Created by knight on 15/9/17.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

#import "SLChatMoreView.h"
#define LEFT_MARGIN 10
#define RIGHT_MARGIN 10
#define TOP_MARGIN 10
#define BOTTOM_MARGIN 10
#define PADDING 6

@interface SLChatMoreView ()
@property (nonatomic , strong)  UIButton * picButton;
@property (nonatomic , strong)  UIButton * videoButton;
@property (nonatomic , strong)  UIButton * contractButton;
@property (nonatomic , strong)  UIButton * locationButton;

@end

@implementation SLChatMoreView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _picButton = [SLTools createButtonWithtarget:self selector:@selector(sendPic:) backgroudImg:@"pictures"];
        _videoButton = [SLTools createButtonWithtarget:self selector:@selector(sendVideo:) backgroudImg:@"videos"];
        _contractButton = [SLTools createButtonWithtarget:self selector:@selector(sendContract:) backgroudImg:@"takePhoto"];
        _locationButton = [SLTools createButtonWithtarget:self selector:@selector(sendLocation:) backgroudImg:@"location"];
        [self addSubViews];
        [self makeConstrains];
    }
    return self;
}

- (void)addSubViews {
    [self addSubview:_picButton];
    [self addSubview:_videoButton];
    [self addSubview:_contractButton];
    [self addSubview:_locationButton];
}

- (void)makeConstrains {
    CGFloat padding = 20;
    CGFloat top = 15;
    [self.picButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(padding);
        make.top.equalTo(self).offset(top);
        make.bottom.equalTo(self).offset(-top);
        make.width.equalTo(self.videoButton);
//        make.centerY.equalTo(self);
    }];
    [self.videoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.picButton.mas_right).offset(padding);
        make.top.bottom.equalTo(self.picButton);
        make.width.equalTo(self.contractButton);
//        make.centerY.equalTo(self.picButton);
    }];
    [self.contractButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.videoButton.mas_right).offset(padding);
        make.top.bottom.equalTo(self.videoButton);
        make.width.equalTo(self.locationButton);
//        make.centerY.equalTo(self.videoButton);
    }];
    [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contractButton.mas_right).offset(padding);
        make.right.equalTo(self).offset(-padding);
        make.top.bottom.centerY.equalTo(self.contractButton);
//        make.width.equalTo(self.picButton);
    }];
}

- (void)sendPic:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSendPicButtonClicked:)]) {
        [self.delegate didSendPicButtonClicked:sender];
    }
}

- (void)sendVideo:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSendVideoButtonClicked:)]) {
        [self.delegate didSendVideoButtonClicked:sender];
    }
}

- (void)sendContract:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSendContractButtonClicked:)]) {
        [self.delegate didSendContractButtonClicked:sender];
    }
}

- (void)sendLocation:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSendLocationButtonClicked:)]) {
        [self.delegate didSendLocationButtonClicked:sender];
    }
}

@end
