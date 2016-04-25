//
//  SLGlobalBannerView.m
//  Sherlock
//
//  Created by knight on 15/11/13.
//  Copyright © 2015年 bj.58.com. All rights reserved.
//

#import "SLGlobalBannerView.h"
#import "SLGlobalBannerModel.h"
#import "NSTimer+Addition.h"
#define kBannerHeight 170
#define kTimerInterVal 1

@interface SLGlobalBannerView ()<UIScrollViewDelegate>
@property (nonatomic , strong) UIScrollView * scrollView;
@property (nonatomic , assign) NSInteger currentIndex;
@property (nonatomic , strong) NSTimer * timer;
@property (nonatomic , assign) NSInteger width;
@property (nonatomic , strong) UIImageView * firstImageView;
@property (nonatomic , strong) UIImageView * secondImageView;
@property (nonatomic , strong) UIImageView * thirdImageView;
@property (nonatomic , strong) UIPageControl * pageControl;
@end

@implementation SLGlobalBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _width = CGRectGetWidth(frame);
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithDataSource:(NSArray *)dataSource {
    if (self = [super init]) {
        _dataSource = dataSource;
        _width = kScreenWidth;
        [self setupViews];
    }
    return self;
}
#pragma mark - private methods

- (void)setupViews {
    _currentIndex = 0;
    [self configViews];
}

- (void)configViews {
    _scrollView  = [[UIScrollView alloc] init];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _firstImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,self.width, kBannerHeight)];
    _secondImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width, 0, self.width, kBannerHeight)];
    _thirdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2*self.width, 0, self.width, kBannerHeight)];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewdidTapped:)];
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.hidesForSinglePage = YES;
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    [_scrollView addSubview:_firstImageView];
    [_scrollView addSubview:_secondImageView];
    [_scrollView addSubview:_thirdImageView];
    [_scrollView addGestureRecognizer:tapGesture];
    [self addSubview:_scrollView];
    [self addSubview:_pageControl];
    [self makeConstraints];
    _scrollView.contentSize = CGSizeMake(3*self.width, kBannerHeight);
    //把中间当做最开始的一张图示意为：|-[ previous ]-[ current ]-[ rear ]-|
    if (_dataSource && _dataSource.count > 0) {
        _pageControl.numberOfPages = _dataSource.count;
         [self updateScrollViews];
    }
}

- (void)makeConstraints {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.width, kBannerHeight));
    }];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-9);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(50);
    }];
}

- (NSInteger)getCyclelyIndex:(NSInteger)index {
   return index < 0?self.dataSource.count-1:index%self.dataSource.count;
}

- (void)updateScrollViews {
    NSInteger rearIndex = [self getCyclelyIndex:self.currentIndex+1];
    NSInteger previousIndex = [self getCyclelyIndex:self.currentIndex -1];
    _firstImageView.image = ((SLGlobalBannerModel *)self.dataSource[previousIndex]).image;
    _secondImageView.image = ((SLGlobalBannerModel *)self.dataSource[self.currentIndex]).image;
    _thirdImageView.image = ((SLGlobalBannerModel *)self.dataSource[rearIndex]).image;
    [self.scrollView setContentOffset:CGPointMake(self.width, 0)];
}

#pragma mark - public
- (void)start {
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimerInterVal target:self selector:@selector(trigleToScroll) userInfo:nil repeats:YES];
    };
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    _pageControl.numberOfPages = _dataSource.count;
    _pageControl.currentPage = 0;
    [self updateScrollViews];
}
#pragma mark - UIScrollViewDelegate 
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer pause];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.timer resumeTimerAfterTimerInterval:kTimerInterVal];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x >= 2*self.width) {
        self.currentIndex = [self getCyclelyIndex:self.currentIndex+1];
        [self updateScrollViews];
    }else if (scrollView.contentOffset.x <= 0) {
        self.currentIndex = [self getCyclelyIndex:self.currentIndex -1];
        [self updateScrollViews];
    }
    self.pageControl.currentPage = self.currentIndex;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.scrollView setContentOffset:CGPointMake(self.width, 0) animated:YES];
}

#pragma mark - actions & notifications 
- (void)trigleToScroll {
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x+self.width, 0);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

- (void)viewdidTapped:(UITapGestureRecognizer *) recognizer {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidTappedAtIndex:)]) {
        [self.delegate scrollViewDidTappedAtIndex:self.currentIndex];
    }
}
@end
