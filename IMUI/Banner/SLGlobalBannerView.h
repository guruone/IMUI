//
//  SLGlobalBannerView.h
//  Sherlock
//
//  Created by knight on 15/11/13.
//  Copyright © 2015年 bj.58.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SLGlobalBannerViewDelegate<NSObject>
- (void)scrollViewDidTappedAtIndex:(NSInteger)index;
@end

@interface SLGlobalBannerView : UIView
@property(nonatomic , strong)NSArray * dataSource;
@property(nonatomic , weak) id<SLGlobalBannerViewDelegate> delegate;

- (instancetype)initWithDataSource:(NSArray *)dataSource;

//触发滚动
- (void)start;
@end
