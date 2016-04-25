//
//  SLAlbumCell.h
//  IMUI
//
//  Created by knight on 15/11/5.
//  Copyright © 2015年 bj.58.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface SLAlbumCell : UITableViewCell
@property(nonatomic , strong)PHCollection * collection;

- (void)updateCell;
@end
