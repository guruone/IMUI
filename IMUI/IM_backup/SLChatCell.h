//
//  SLChatCell.h
//  Sherlock
//
//  Created by knight on 15/9/17.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

#import "HYBaseCell.h"
@class SLMessageModel;

@interface SLChatCell : HYBaseCell
- (instancetype)initWithModel:(SLMessageModel *)model reuseIdentifier:(NSString *)reuseIdentifier;
+ (NSString *)reuseIdentifierWith:(SLMessageModel *)model;
@end
