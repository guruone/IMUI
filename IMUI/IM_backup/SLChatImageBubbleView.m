//
//  SLChatImageBubbleView.m
//  Sherlock
//
//  Created by knight on 15/9/17.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

#import "SLChatImageBubbleView.h"
#import "UIImageView+WebCache.h"
@interface SLChatImageBubbleView ()
@property (nonatomic , strong) UIImageView * imageView;
@end

@implementation SLChatImageBubbleView

- (instancetype)init {
    if (self = [super init]) {
        _imageView = [[UIImageView alloc] init];
        [self configViews];
    }
    return self;
}

- (void)configViews {
    [self addSubview:_imageView];
    [self makeConstrains];
}

- (void)makeConstrains {
    WeakSelf(weakself)
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself).insets(UIEdgeInsetsMake(10, 16, 10, 10));
    }];
}

- (void)setModel:(SLMessageModel *)model {
    [super setModel:model];
    UIImage * image = model.isSender?model.image:model.thumbnailImage;
    if (!image) {
        image = model.image;
        if (!image) {
            [_imageView sd_setImageWithURL:model.imageRemoteURL placeholderImage:[UIImage imageNamed:@"imageDownloadFail.png"]];
        } else {
            self.imageView.image = image;
        }
    } else {
        self.imageView.image = image;
    }
    self.imageView.image = image;
}


@end
