//
//  IMAlbumController.m
//  IMUI
//
//  Created by knight on 15/11/5.
//  Copyright © 2015年 bj.58.com. All rights reserved.
//

#import "IMAlbumController.h"
#import <Photos/Photos.h>
#import "SLAlbumCell.h"
#import "SLPhotoPicker.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface IMAlbumController ()
@property(nonatomic , strong)NSArray * collections;
@property(nonatomic , strong)SLPhotoPicker * photoPicker;
@end

@implementation IMAlbumController


- (instancetype)initWithCollections:(NSArray *)collections {
    if (self = [super init]) {
        _collections = collections;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self configNavbar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
- (void)configNavbar {
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] init];
    leftItem.title = @"";
    self.navigationItem.leftBarButtonItem = leftItem;
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] init];
    rightItem.title = @"完成";
    //rightItem.tintColor = kSLMainColor;
    rightItem.tintColor = HYRGBCOLOR(244, 46, 65);
    rightItem.target = self;
    rightItem.action = @selector(doneButtonClicked:);
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.collections)
        return self.collections.count;
    else
        return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SLAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"albumIdentifier"];
    if (!cell) {
        cell = [[SLAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"albumIdentifier"];
    }
    PHCollection * collection = (PHCollection *)self.collections[indexPath.row];
    cell.collection = collection;
    [cell updateCell];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id collection = self.collections[indexPath.row];
    if ([collection isKindOfClass:[PHAssetCollection class]]) {
        PHFetchOptions * options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:YES]];
        PHFetchResult * results = [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection *)collection options:options];
        if (results && results.count > 0) {
            NSMutableArray * assets = [[NSMutableArray alloc] init];
            [results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [assets addObject:obj];
            }];
            self.photoPicker  = [[SLPhotoPicker alloc] initWithAssets:assets];
            self.photoPicker.delegate = self.delegate;
            self.photoPicker.pickerController = self;
        }
    }else if ([collection isKindOfClass:[ALAssetsGroup class]]) {
        ALAssetsGroup * group = (ALAssetsGroup *)collection;
        NSMutableArray * assets = [[NSMutableArray alloc] init];
        NSInteger count = [group numberOfAssets];
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result)
                [assets addObject:result];
            if (index == count-1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.photoPicker  = [[SLPhotoPicker alloc] initWithAssets:assets];
                    self.photoPicker.delegate = self.delegate;
                    self.photoPicker.pickerController = self;
                });
            }
        }];
    }
}

#pragma mark - actions
- (void)doneButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setDelegate:(id)delegate {
    _delegate = delegate;
    _photoPicker.delegate = delegate;
}
@end
