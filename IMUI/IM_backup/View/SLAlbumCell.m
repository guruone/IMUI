//
//  SLAlbumCell.m
//  IMUI
//
//  Created by knight on 15/11/5.
//  Copyright © 2015年 bj.58.com. All rights reserved.
//

#import "SLAlbumCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface SLAlbumCell ()
@property(nonatomic , strong)UIImageView * thumbnail;
@property(nonatomic , strong)UILabel * nameLabel;
@property(nonatomic , strong)UILabel * numLabel;
@end

@implementation SLAlbumCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configViews];
    }
    return self;
}

- (void)configViews {
    _thumbnail = [[UIImageView alloc] init];
    _nameLabel = [[UILabel alloc] init];
    _numLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_thumbnail];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_numLabel];
    [self makeConstraints];
}

- (void)makeConstraints {
    [_thumbnail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.left.equalTo(self);
        make.centerY.equalTo(self);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.thumbnail.mas_right).offset(10);
//        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(self);
    }];
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(10);
        make.centerY.equalTo(self);
        make.right.lessThanOrEqualTo(self).offset(-10);
        make.height.mas_equalTo(30);
    }];
}

- (void)updateCell {
    if ([self.collection isKindOfClass:[PHAssetCollection class]]) {
        _nameLabel.text = self.collection.localizedTitle;
        PHAssetCollection * assetCollection = (PHAssetCollection *)self.collection;
        PHFetchOptions * options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:YES]];
        PHFetchResult * results = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
        if (results && results.count > 0) {
            _numLabel.text = [NSString stringWithFormat:@"(%ld)",results.count];
            PHAsset * asset = results.firstObject;
            PHImageRequestOptions * requestOptions = [[PHImageRequestOptions alloc] init];
            requestOptions.networkAccessAllowed = NO;
            requestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
            requestOptions.synchronous = YES;
           [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(60, 60) contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
               _thumbnail.image = result;
           }];
        }
    }else if ([self.collection isKindOfClass:[ALAssetsGroup class]]) {
        ALAssetsGroup * group = (ALAssetsGroup *)self.collection;
        NSString * groupName = [group valueForProperty:ALAssetsGroupPropertyName];
        _nameLabel.text = groupName;
        NSInteger assetsNum = [group numberOfAssets];
        _numLabel.text = [NSString stringWithFormat:@"(%ld)",assetsNum];
        UIImage * thumbnail = [UIImage imageWithCGImage: group.posterImage];
        _thumbnail.image = thumbnail;
    }
}

@end
