//
//  SLChatToolBar.h
//  Sherlock
//
//  Created by knight on 15/9/17.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kToolBarHeight 46
#define kMoreView_height 85

@protocol SLChatToolBarDelegate<NSObject>
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
/**
 *  toolbar高度将要发生变化时的代理方法
 */
- (void)toolBarWillChangeHeight:(CGFloat)height keyboardHeight:(CGFloat)keyboardHeight;

/**
 *  “+”号将显示时的代理方法（键盘也算作“+”号里头）
 */
- (void)moreViewWillAppear:(CGFloat)height;

/**
 *  键盘将消失后的代理方法
 */
- (void)moreViewDidDisappear:(CGFloat)height;

/**
 *  发送按钮按下之后的代理方法
 */
- (void)didSendText:(NSString *)text;

@end

@interface SLChatToolBar : UIView
@property (nonatomic , weak) id<SLChatToolBarDelegate> delegate;

@end
