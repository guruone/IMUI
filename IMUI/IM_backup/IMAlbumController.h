//
//  IMAlbumController.h
//  IMUI
//
//  Created by knight on 15/11/5.
//  Copyright © 2015年 bj.58.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMAlbumController : UITableViewController
@property (nonatomic , strong)id delegate;
- (instancetype)initWithCollections:(NSArray *)collections;

@end
