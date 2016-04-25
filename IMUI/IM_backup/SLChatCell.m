//
//  SLChatCell.m
//  Sherlock
//
//  Created by knight on 15/9/17.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

#import "SLChatCell.h"
#import "UIImageView+WebCache.h"
#import "SLChatBubbleView.h"
#import "SLChatTextBubbleView.h"
#import "SLChatVideoBubbleView.h"
#import "SLChatVoiceBubbleView.h"
#import "SLChatContractBubbleView.h"
#import "SLChatImageBubbleView.h"
#import "SLChatLocationBubbleView.h"
#import "SLMessageModel.h"

#define MARGIN 10
#define HEADVIEW_HEIGH 40
#define TOP_MARGIN 6
#define BOTTOM_MARGIN 6
#define SPACING 20
@interface SLChatCell ()
@property (nonatomic , strong) UIImageView * headView;
@property (nonatomic , strong) SLChatBubbleView * bubleView;

@end

@implementation SLChatCell
- (instancetype)initWithModel:(SLMessageModel *)model reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.cellModel = model;
        [self configSubviews:model];
        [self makeConstrains];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)configSubviews:(SLMessageModel *)model {
    _headView = [[UIImageView alloc] init];
    [self.contentView addSubview:_headView];
    _headView.layer.cornerRadius = HEADVIEW_HEIGH/2;
    _headView.clipsToBounds = YES;
    _headView.backgroundColor = [UIColor redColor];
    _bubleView = [self bubleViewWith:model];
//    _bubleView.model = model;

    [self.contentView addSubview:_bubleView];
    
}

- (void)makeConstrains {
    SLMessageModel * model = (SLMessageModel *)self.cellModel;
    if (model.isSender) {
        [self makeSenderConstrains];
    }else {
        [self makeReceiverConstrains];
    }
}

- (void)makeSenderConstrains {
    WeakSelf(weakself)
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.contentView).offset(-MARGIN);
        make.top.equalTo(weakself.contentView).offset(TOP_MARGIN);
        make.width.height.equalTo(@(HEADVIEW_HEIGH));
    }];
    [_bubleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.headView.mas_left).offset(-SPACING);
        make.left.lessThanOrEqualTo(weakself.contentView).offset(MARGIN);
        make.top.equalTo(weakself.headView.mas_top);
        make.bottom.equalTo(weakself.contentView).offset(-BOTTOM_MARGIN);
    }];
}

- (void)makeReceiverConstrains {
    WeakSelf(weakself)
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.contentView).offset(MARGIN);
        make.top.equalTo(weakself.contentView).offset(TOP_MARGIN);
        make.width.height.equalTo(@(HEADVIEW_HEIGH));
    }];
    [_bubleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.headView.mas_right).offset(MARGIN);
        make.right.lessThanOrEqualTo(weakself.contentView).offset(-SPACING);
        make.top.equalTo(weakself.headView);
        make.bottom.equalTo(weakself.contentView).offset(-BOTTOM_MARGIN);
    }];
}

#pragma mark - private methods
- (SLChatBubbleView *)bubleViewWith:(SLMessageModel *)model {
    switch (model.type) {
        case eMessageBodyType_Text: {
            if (model.message.ext) {
                //自定义bubble,如果自定义bubble类型多则在此处做扩展
                return [[SLChatContractBubbleView alloc] init];
            }else {
                return [[SLChatTextBubbleView alloc] init];
            }
        }
        case eMessageBodyType_Image:
            return [[SLChatImageBubbleView alloc] init];
        case eMessageBodyType_Location:
            return [[SLChatLocationBubbleView alloc] init];
        case eMessageBodyType_Video:
            return [[SLChatVideoBubbleView alloc] init];
         case eMessageBodyType_Voice:
            return [[SLChatVoiceBubbleView alloc] init];
        default:
            return nil;
    }
}

- (void)updateCell {
    SLMessageModel * model = (SLMessageModel *)self.cellModel;
    [_headView sd_setImageWithURL:model.headImageURL placeholderImage:[UIImage imageNamed:@"payicon_wx"]];
    _bubleView.model = model;
}

- (void)resetCell {
    
}

+ (NSString *)reuseIdentifierWith:(SLMessageModel *)model {
    NSString * suffixIdentifier = @"MessageCellIdentifier";
    NSString * prefixIdentifier = @"";
    NSString * middlerIdentifier = @"";
    if (model.isSender) {
        prefixIdentifier =  @"Sender";
    }else {
        prefixIdentifier = @"Receiver";
    }
    switch (model.type) {
        case eMessageBodyType_Text:
            middlerIdentifier = @"Text";
            break;
        case eMessageBodyType_Image:
            middlerIdentifier = @"Image";
            break;
        case eMessageBodyType_Video:
            middlerIdentifier = @"Video";
            break;
        case eMessageBodyType_Location:
            middlerIdentifier = @"Location";
            break;
        case eMessageBodyType_Voice:
            middlerIdentifier = @"Voice";
            break;
        default:
            break;
    }
    return [NSString stringWithFormat:@"%@_%@%@",prefixIdentifier,middlerIdentifier,suffixIdentifier];
}
@end
