//
//  SLPhotoPicker.m
//  Sherlock
//
//  Created by knight on 15/10/2.
//  Copyright © 2015年 bj.58.com. All rights reserved.
//

#import "SLPhotoPicker.h"
#import "HYPhotoBrowserAssetsHelper.h"
#import "MMAlertView.h"
#import "IMAlbumController.h"

@interface SLPhotoPicker () {
    dispatch_semaphore_t _semaphore;
}
@property (nonatomic , strong) MWPhotoBrowser * photoBrowser;
@property (nonatomic , strong) NSMutableArray<MWPhoto *> * photos;//图片（MWPhotoBrowser用）
@property (nonatomic , strong) NSMutableArray<MWPhoto *> * thumbs;//缩略图（MWPhotoBrowser用）
@property (nonatomic , strong) NSArray * assets;//资源
@property (nonatomic , strong) NSMutableArray * selections;
@property (nonatomic , strong) UINavigationController * naviController;
@end

@implementation SLPhotoPicker

- (instancetype)initWithAssets:(NSArray *)assets {
    if (self = [super init]) {
        _assets = assets;
        _maxPickNum = 9;
        _selections = [[NSMutableArray alloc] init];
        _photos = [HYPhotoBrowserAssetsHelper photosFromAssets:_assets];
        _thumbs = [HYPhotoBrowserAssetsHelper thumbsFromAssets:_assets];
        [_photoBrowser setCurrentPhotoIndex:0];
    }
    return  self;
}

- (void)setPickerController:(UIViewController *)pickerController {
    if (pickerController) {
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        _photoBrowser.startOnGrid = YES;
        _photoBrowser.enableGrid = NO;
        _photoBrowser.displaySelectionButtons = YES;
        _pickerController = pickerController;
        if ([_pickerController isKindOfClass:[IMAlbumController class]]) {
            [_pickerController.navigationController pushViewController:_photoBrowser animated:YES];
            return;
        }
        self.naviController = [[UINavigationController alloc] initWithRootViewController:_photoBrowser];
        self.naviController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [pickerController presentViewController:self.naviController animated:YES completion:nil];
    }}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}
- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    if (_selections && [_selections count] > 0) {
        BOOL result = [_selections containsObject:[NSNumber numberWithInteger:index]];
//        if ([_selections count] >= _maxPickNum && result) {
//            result = NO;
//        }
        return result;
    }else {
        return NO;
    }
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    if (selected) {
        if ([_selections count] < _maxPickNum)
            [_selections addObject:[NSNumber numberWithInteger:index]];
    }else {
        [_selections removeObject:[NSNumber numberWithInteger:index]];
    }
    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    UIWindow * visibleWindow = [HYCommonTools visibleWindow];
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithWindow:visibleWindow];
    [visibleWindow addSubview:hud];
    hud.labelText =  @"正在处理";
    
    [hud showAnimated:YES whileExecutingBlock:^{
        NSLog(@"Did finish modal presentation");
        __block NSMutableArray * assets = [[NSMutableArray alloc] init];
        for (NSInteger index = 0; index<[_selections count]; index++) {
            NSInteger value = [[_selections objectAtIndex:index] integerValue];
            [HYPhotoBrowserAssetsHelper resourcesFromAsset:self.assets[value] complete:^(id result) {
                [assets addObject:result];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(assetDidPicked:)]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate assetDidPicked:result];
                    });

                }
            }];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(assetsDidPicked:)]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate assetsDidPicked:assets];
            });
        }
    } completionBlock:^{
        [hud removeFromSuperview];
        if (self.delegate && [self.delegate respondsToSelector:@selector(assetsPickFinished)]) {
            dispatch_async(dispatch_get_main_queue(), ^{

                [self.delegate assetsPickFinished];
            });
        }
    }];
}

- (BOOL)gridCanPressAtIndex:(NSInteger)index selected:(BOOL)selected{
    if ( selected && [self.selections count] >= self.maxPickNum) {MMAlertView * alertView = [[MMAlertView alloc] initWithConfirmTitle:@"唉哟，选多了" detail:[NSString stringWithFormat:@"最多选择%ld个图片",self.maxPickNum]];
        [alertView show];
        return NO;
    }
    return YES;
}

- (void)backButtonClicked:(id)sender {
    [[HYPhotoBrowserAssetsHelper sharedInstance] loadUserAlbumsWithBlock:^(NSMutableArray * collections) {
        IMAlbumController * controller = [[IMAlbumController alloc] initWithCollections:collections];
        controller.delegate = self.delegate;
        controller.title = @"相册";
        [self.photoBrowser.navigationController pushViewController:controller animated:YES];
    }] ;

}
@end
