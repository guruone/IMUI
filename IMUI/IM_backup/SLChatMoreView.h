//
//  SLChatMoreView.h
//  Sherlock
//
//  Created by knight on 15/9/17.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SLChatMoreViewDelegate <NSObject>

- (void)didSendPicButtonClicked:(UIButton *)sender;

- (void)didSendVideoButtonClicked:(UIButton *)sender;

- (void)didSendContractButtonClicked:(UIButton *)sender;

- (void)didSendLocationButtonClicked:(UIButton *)sender;

@end
@interface SLChatMoreView : UIView

@property (nonatomic , weak) id<SLChatMoreViewDelegate> delegate;
@end
