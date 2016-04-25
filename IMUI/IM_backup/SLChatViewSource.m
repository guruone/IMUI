//
//  SLChatViewSource.m
//  Sherlock
//
//  Created by knight on 15/9/16.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

#import "SLChatViewSource.h"
#import "EMCDDeviceManager.h"
#import "SLChatCell.h"
#import "SLChatTimeCell.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "NSDate+category.h"
#import "SLMessageModel.h"
@interface SLChatViewSource ()<EMCallManagerDelegate,EMCDDeviceManagerDelegate,EMChatManagerChatDelegate,IChatManagerDelegate>
{
    dispatch_queue_t _messageQueue;
}
@property (nonatomic , strong) EMConversation * conversation;
@property (nonatomic , strong) NSMutableArray * messages;//里面存的都是EMMessage对象，不包括时间的
@property (nonatomic , assign) BOOL isPlayingAudio;
@property (nonatomic , strong) NSDate * chatTagDate;
@property (nonatomic , assign) BOOL isInvisible;
@end
@implementation SLChatViewSource

- (void)dealloc {
    _isPlayingAudio = NO;
}

- (void)initExtentions {
    self.modelArray = [[NSMutableArray alloc] init];
    _messages = [[NSMutableArray alloc] init];
    _messageQueue = dispatch_queue_create("com.bj58.sherlock", NULL);
    _isPlayingAudio = NO;
    self.isInvisible = NO;
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    //注册为SDK的ChatManager的delegate
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [EMCDDeviceManager sharedInstance].delegate = self;
}

- (void)refreshSource {
    self.chatTagDate = nil;
    [self notifyWillRefresh];
    if (self.context) {
        self.conversation = self.context.contextDic[@"conversation"];
    }
    //从环信sdk的数据库中load数据
    if (self.conversation) {
        [self fetchMessages];
    }
}

-(void)registerCellsToTable:(UITableView *)tableView {
    [self.sizeingManager registerCellClassName:@"SLChatCell"
                                  withNibNamed:nil
                                forObjectClass:[SLMessageModel class]
                        withConfigurationBlock:^(HYBaseCell *cell, id object)
     {
         cell.cellModel = object;
     }];
}

- (void)fetchMessages {
    WeakSelf(weakSelf)
    dispatch_async(_messageQueue, ^{
        if ([weakSelf.messages count]>0) {
           EMMessage * firstMessage = (EMMessage *)weakSelf.messages.firstObject;
            if (firstMessage) {
                NSArray * messages = [weakSelf.conversation loadNumbersOfMessages:20 before:firstMessage.timestamp];
                NSArray * formattedMessages = [weakSelf formattedMessage:messages];
                [weakSelf.messages insertObjects:messages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, messages.count) ]];
                [weakSelf.modelArray insertObjects:formattedMessages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, formattedMessages.count)]];
            }
           
        }else {
            long long timeStamp = [[NSDate date] timeIntervalSince1970]*1000 +1;
            NSArray * messages = [weakSelf.conversation loadNumbersOfMessages:20 before:timeStamp];
            [weakSelf.messages addObjectsFromArray:messages];
            [weakSelf.modelArray addObjectsFromArray:[weakSelf formattedMessage:messages]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf notifyDidFinishRefresh];
        });
    });
}

#pragma mark - interfaces
- (void)viewWillDisappear {
    _isPlayingAudio = NO;
    [EMCDDeviceManager sharedInstance].delegate = self;
    [_conversation markAllMessagesAsRead:YES];
    self.isInvisible = YES;
}

- (dispatch_queue_t)dispachQueue {
    return _messageQueue;
}


#pragma mark - private methods
- (void)setIsInvisible:(BOOL)isInvisible
{
    _isInvisible =isInvisible;
    if (!_isInvisible)
    {
        NSMutableArray *unreadMessages = [NSMutableArray array];
        for (EMMessage *message in self.messages)
        {
            if ([self shouldAckMessage:message read:NO])
            {
                [unreadMessages addObject:message];
            }
        }
        if ([unreadMessages count])
        {
            [self sendHasReadResponseForMessages:unreadMessages];
        }
        
        [_conversation markAllMessagesAsRead:YES];
    }
}

- (void)sendHasReadResponseForMessages:(NSArray*)messages
{
    dispatch_async(_messageQueue, ^{
        for (EMMessage *message in messages)
        {
            [[EaseMob sharedInstance].chatManager sendReadAckForMessage:message];
        }
    });
}


- (NSArray *)formattedMessage:(NSArray *)messages {
    NSMutableArray * formattedMessages = [[NSMutableArray alloc] init];
    if ([messages count] > 0) {
        [messages enumerateObjectsUsingBlock:^(id message, NSUInteger idx, BOOL *stop) {
            NSDate * createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:((EMMessage *)message).timestamp];
            NSTimeInterval timeInterval = [createDate timeIntervalSinceDate:self.chatTagDate];
            if (self.chatTagDate == nil || timeInterval > 60 || timeInterval < -60) {
                [formattedMessages addObject:[createDate formattedTime]];
                self.chatTagDate = createDate;
            }
            #warning 这个地方可能头像和昵称会有点问题
            SLMessageModel * model = [SLMessageModel modelWithMessage:message];
            model.nickName = model.username;
            model.identifier = [SLChatCell reuseIdentifierWith:model];
            if (model) {
                [formattedMessages addObject:model];
            }
        }];
    }
    return formattedMessages;
}

- (NSDate *)chatTagDate {
    if (!_chatTagDate) {
        _chatTagDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:0];
    }
    return _chatTagDate;
}

- (BOOL)shouldAckMessage:(EMMessage *)message read:(BOOL)read
{
    NSString *account = [[EaseMob sharedInstance].chatManager loginInfo][kSDKUsername];
    if (message.messageType != eMessageTypeChat || message.isReadAcked || [account isEqualToString:message.from] || ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) || self.isInvisible)
    {
        return NO;
    }
    
    id<IEMMessageBody> body = [message.messageBodies firstObject];
    if (((body.messageBodyType == eMessageBodyType_Video) ||
         (body.messageBodyType == eMessageBodyType_Voice) ||
         (body.messageBodyType == eMessageBodyType_Image)) &&
        !read)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)shouldMarkMessageAsRead
{
    if (([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) || self.isInvisible)
    {
        return NO;
    }
    
    return YES;
}

- (void)markMessagesAsRead:(NSArray*)messages
{
    EMConversation *conversation = _conversation;
    dispatch_async(_messageQueue, ^{
        for (EMMessage *message in messages)
        {
            [conversation markMessageWithId:message.messageId asRead:YES];
        }
    });
}

#pragma mark - UITableViewDataSource
#pragma mark Cell Height

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.modelArray[indexPath.row] isKindOfClass:[NSString class]]) {
        return 30;
    }else {
        SLMessageModel * model = (self.modelArray)[indexPath.row];
        HYBaseCell * cell = [tableView dequeueReusableCellWithIdentifier:model.identifier];
        if (!cell) {
            cell = [[SLChatCell alloc] initWithModel:model reuseIdentifier:model.identifier];
        }
        [cell updateCell];
        [cell setNeedsLayout];
        [cell layoutIfNeeded];

        CGFloat height = 0;
        CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        height = size.height;
        return height+1;
    }
   }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id obj = [self.modelArray objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[NSString class]]) {
        SLChatTimeCell * timeCell = (SLChatTimeCell *)[tableView dequeueReusableCellWithIdentifier:@"MessageTimeCell"];
        if (!timeCell) {
            timeCell = [[SLChatTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageTimeCell"];
        }
        timeCell.textLabel.text = (NSString *)obj;
        return timeCell;
    }else {
        SLMessageModel * model = (SLMessageModel *)obj;
        SLChatCell * cell = (SLChatCell *) [tableView dequeueReusableCellWithIdentifier:model.identifier];
        if (!cell) {
            cell = [[SLChatCell alloc] initWithModel:model reuseIdentifier:model.identifier];
        }
        cell.cellModel = model;
        [self prepareCell:cell index:indexPath];
        return cell;
    }
    return  nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.modelArray || [self.modelArray count] < 1) {
        return 0;
    }else
        return [self.modelArray count];
}

#pragma mark - EMChatManagerChatDelegate
/*!
 * 收到消息时的回调
 @param message      消息对象
 @discussion 当EMConversation对象的enableReceiveMessage属性为YES时, 会触发此回调
 针对有附件的消息, 此时附件还未被下载.
 附件下载过程中的进度回调请参考didFetchingMessageAttachments:progress:,
 下载完所有附件后, 回调didMessageAttachmentsStatusChanged:error:会被触发
 */
- (void)didReceiveMessage:(EMMessage *)message {
    //TODO resolve message here
    WeakSelf(weakself)
    dispatch_async(_messageQueue, ^{
        NSArray * messages = [weakself formattedMessage:@[message]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.modelArray addObjectsFromArray:messages];
            //处理完之后调代理方法
            if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveMessage:)]) {
                [(id<SLChatViewSourceDelegate>)self.delegate didReceiveMessage:message];
            }
            if ([self shouldAckMessage:message read:NO])
            {
                [self sendHasReadResponseForMessages:@[message]];
            }
            if ([self shouldMarkMessageAsRead])
            {
                [self markMessagesAsRead:@[message]];
            }
        });
    });
}

//收到离线消息
-(void)didReceiveOfflineMessages:(NSArray *)offlineMessages {
    //TODO resolve message here
    //处理完之后调代理方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveOfflineMessages:)]) {
        [(id<SLChatViewSourceDelegate>)self.delegate didReceiveOfflineMessages:offlineMessages];
    }
}

//收到透传的消息
-(void)didReceiveOfflineCmdMessages:(NSArray *)offlineCmdMessages {
    //TODO resolve message here
    
    //处理完之后调代理方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveOfflineCmdMessages:)]) {
        [(id<SLChatViewSourceDelegate>)self.delegate didReceiveOfflineCmdMessages:offlineCmdMessages];
    }
}

- (void)didSendMessage:(EMMessage *)message error:(EMError *)error {
    //TODO resolve message here
    [self.modelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[SLMessageModel class]]) {
            SLMessageModel * temMessage = (SLMessageModel *)obj;
            if (temMessage.message.messageId == message.messageId) {
                temMessage.message.deliveryState = message.deliveryState;
                *stop = YES;
            }
        }
    }];
    WeakSelf(weakself)
    dispatch_async(_messageQueue, ^{
        NSArray * messages = [weakself formattedMessage:@[message]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.modelArray addObjectsFromArray:messages];
            //处理完之后调代理方法
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSendMessage:error:)]) {
                [(id<SLChatViewSourceDelegate>)self.delegate didSendMessage:message error:error];
            }
        });
    });
}

- (void)willSendMessage:(EMMessage *)message error:(EMError *)error {
    
}
#pragma mark - EMCDDeviceManagerDelegate
- (void)proximitySensorChanged:(BOOL)isCloseToUser{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (isCloseToUser)
    {
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    } else {
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        if (!_isPlayingAudio) {
            [[EMCDDeviceManager sharedInstance] disableProximitySensor];
        }
    }
    [audioSession setActive:YES error:nil];
}
@end
