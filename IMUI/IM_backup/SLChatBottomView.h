//
//  SLChatBottomView.h
//  IMUI
//
//  Created by knight on 15/11/3.
//  Copyright © 2015年 bj.58.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLChatToolBar.h"
#import "SLChatMoreView.h"
@protocol SLChatBottomViewDelegate <NSObject,SLChatMoreViewDelegate,SLChatToolBarDelegate>
@optional
/**
 *  语音按钮按下之后的代理方法
 */
- (void)didSpeechButtonClicked:(UIButton *)sender;

/**
 *  更多按钮按下之后的代理方法
 */
- (void)didMoreButtonClicked:(UIButton *)sender;
@required
/** 底部的toolbar和moreView出现时的代理*/
- (void)bottomViewWillAppear:(CGFloat)height;

/** 底部的toolbar和moreview消失时的代理 */
- (void)bottomViewWillDisAppear:(CGFloat)height;

/** 发送消息 */
- (void)didSendText:(NSString *)text;
@end
@interface SLChatBottomView : UIView
@property(nonatomic , strong , readonly)SLChatToolBar * toolBar;

@property(nonatomic , weak) id<SLChatBottomViewDelegate> delegate;

//触发底部视图消失的接口
- (void)bottomViewDisAppear;
@end
