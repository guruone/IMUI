//
//  SLChatVideoBubbleView.m
//  Sherlock
//
//  Created by knight on 15/9/17.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

#import "SLChatVideoBubbleView.h"

@interface SLChatVideoBubbleView ()

@property(nonatomic , strong) UIButton * videoPlayButton;
@end
@implementation SLChatVideoBubbleView

- (instancetype)init {
    if  (self = [super init]) {
        _videoPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_videoPlayButton setImage:[UIImage imageNamed:@"chat_video_play"] forState:UIControlStateNormal];
        [self makeConstraints];
    }
    return self;
}

- (void)makeConstraints {
    [self addSubview:_videoPlayButton];
    [_videoPlayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
}

- (void)setModel:(SLMessageModel *)model {
    [super setModel:model];
}
@end
