//
//  SLChatTextBubbleView.m
//  Sherlock
//
//  Created by knight on 15/9/17.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

#import "SLChatTextBubbleView.h"

@interface SLChatTextBubbleView ()
@property (nonatomic , strong) UILabel * textLabel;
@end

@implementation SLChatTextBubbleView

- (instancetype)init {
    if (self = [super init]) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.numberOfLines = 0;
        _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:_textLabel];
        [self makeConstrains];
    }
    return self;
}

- (void)makeConstrains {
    WeakSelf(weakself)
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself).insets(UIEdgeInsetsMake(15, 15, 15, 15));
    }];
}

- (void)setModel:(SLMessageModel *)model {
    [super setModel:model];
    self.textLabel.text = model.content;
    self.textLabel.numberOfLines = 0;
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
}
@end
