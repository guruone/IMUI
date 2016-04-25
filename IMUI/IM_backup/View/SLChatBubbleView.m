//
//  SLChatBubbleView.m
//  Sherlock
//
//  Created by knight on 15/9/17.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

#import "SLChatBubbleView.h"

#define BUBBLE_LEFT_IMAGE_NAME @"im_receiver_bubble" // bubbleView 的背景图片
#define BUBBLE_RIGHT_IMAGE_NAME @"im_sender_bubble"

#define BUBBLE_ARROW_WIDTH 5 // bubbleView中，箭头的宽度
#define BUBBLE_VIEW_PADDING 8 // bubbleView 与 在其中的控件内边距

#define BUBBLE_RIGHT_LEFT_CAP_WIDTH 5 // 文字在右侧时,bubble用于拉伸点的X坐标
#define BUBBLE_RIGHT_TOP_CAP_HEIGHT 35 // 文字在右侧时,bubble用于拉伸点的Y坐标

#define BUBBLE_LEFT_LEFT_CAP_WIDTH 5 // 文字在左侧时,bubble用于拉伸点的X坐标
#define BUBBLE_LEFT_TOP_CAP_HEIGHT 5 // 文字在左侧时,bubble用于拉伸点的Y坐标
@interface SLChatBubbleView ()
@property (nonatomic , strong) UIImageView * backImageView;
@end

@implementation SLChatBubbleView
- (instancetype)init {
    if (self = [super init]) {
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self configSubviews];
    }
    return self;
}

- (void)configSubviews {
    _backImageView.multipleTouchEnabled = YES;
    _backImageView.userInteractionEnabled = YES;
    _backImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleViewTaped:)];
    [_backImageView addGestureRecognizer:tapGesture];
    [self addSubview:_backImageView];
    [self makeConstrains];
}

- (void)makeConstrains {
    WeakSelf(weakself)
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself);
    }];
}

- (void)setModel:(SLMessageModel *)model {
    _model = model;
    BOOL isReceiver = !model.isSender;
    NSString *imageName = isReceiver ? BUBBLE_LEFT_IMAGE_NAME : BUBBLE_RIGHT_IMAGE_NAME;
    UIImage * image = [UIImage imageNamed:imageName];
     image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(30,40, 30, 40) resizingMode:UIImageResizingModeStretch];
    self.backImageView.image = image;
}

#pragma mark - actions & notifications
- (void)bubbleViewTaped:(UITapGestureRecognizer *) gestureRecognizer {
    NSLog(@"bubble is tapped!");
}
@end
