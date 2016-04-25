//
//  SLChatViewSource.h
//  Sherlock
//
//  Created by knight on 15/9/16.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

#import "HYBaseTableViewSource.h"
#import "EaseMob.h"

@protocol SLChatViewSourceDelegate<HYBaseTableViewSourceDelegate>
@optional
- (void)didReceiveMessage:(EMMessage *)message;

-(void)didReceiveOfflineMessages:(NSArray *)offlineMessages;

-(void)didReceiveOfflineCmdMessages:(NSArray *)offlineCmdMessages;

- (void)didSendMessage:(EMMessage *)message error:(EMError *)error;
@end

@interface SLChatViewSource : HYBaseStaticTableViewSource

- (void)viewWillDisappear;

- (dispatch_queue_t)dispachQueue;
@end
