//
//  SLPhotoPicker.h
//  Sherlock
//
//  Created by knight on 15/10/2.
//  Copyright © 2015年 bj.58.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWPhotoBrowser.h"
@class SLPhotoPicker;
@protocol SLPhotoPickerDelegate <NSObject>
@optional
//点击确定后对所选的资源单个进行回调，有多少个资源回调多少次
- (void)assetDidPicked:(id)asset;

//
- (void)assetsPickFinished;

//点击确定后对所有的资源进行的回调
- (void)assetsDidPicked:(NSArray *)assets;

@end

@interface SLPhotoPicker : NSObject<MWPhotoBrowserDelegate>
/** 允许选择照片的最大数量 ,默认为9张 */
@property (nonatomic , assign) NSInteger maxPickNum;
/** 要选择的资源类型,分为照片（ESLPhotoType）和视频（ESLVideoType）以及两者同时取（ESLPhotoAndVideoType），默认图片 */
//@property (nonatomic , assign) ESLAssetsType assetsType;
@property (nonatomic , weak) id<SLPhotoPickerDelegate> delegate;
@property (nonatomic , strong) UIViewController * pickerController;

- (instancetype)initWithAssets:(NSArray *)assets;

@end
