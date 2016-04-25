//
//  SLChatViewController.m
//  Sherlock
//
//  Created by knight on 15/9/14.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

#import "SLChatViewController.h"
#import "SLChatViewSource.h"
#import "SLChatMoreView.h"
#import "SLChatToolBar.h"
#import "EaseMob.h"
#import "SLChatBottomView.h"
#import "ChatSendHelper.h"
#import <Photos/Photos.h>
#import "SLPhotoPicker.h"
#import "IMAlbumController.h"
#import "HYPhotoBrowserAssetsHelper.h"
#import "SLGlobalBannerModel.h"
#import "SLGlobalBannerView.h"

@interface SLChatViewController ()<SLChatViewSourceDelegate,SLChatBottomViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SLPhotoPickerDelegate>
@property (nonatomic , strong) EMConversation * conversation;
@property (nonatomic , strong) NSString * chatter;
@property (nonatomic , assign) BOOL isScrollToBottom;
@property (nonatomic , strong) SLChatMoreView * chatMoreView;
@property (nonatomic , strong) SLChatToolBar * toolBar;
@property (nonatomic , assign) CGFloat toobBarHeight;//会经常变化
@property (nonatomic , strong) SLChatBottomView * bottomView;
@property (nonatomic , strong) UIImagePickerController * imagePicker;
@property (nonatomic , strong) SLPhotoPicker * photoPicker;
@property (nonatomic , strong) SLGlobalBannerView * banner;
@property (nonatomic , strong) UIPageControl * pageControl;
@end

@implementation SLChatViewController

- (instancetype)initWithChatter:(NSString *)chatter {
    if (self = [super init]) {
        _chatter = chatter;
        _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:chatter conversationType:eConversationTypeChat];
        [_conversation markAllMessagesAsRead:YES];
        _toobBarHeight = kToolBarHeight;
    }
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableViewSource registerCellsToTable:self.tableView];
    [self.tableViewSource refreshSource];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.title = @"呵呵哒";
    _isScrollToBottom = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    SLChatViewSource * tableViewSource = (SLChatViewSource *)self.tableViewSource;
    [tableViewSource viewWillDisappear];
}

#pragma mark - private methods
- (void)scrollToBottom {
    if (self.isScrollToBottom && self.tableView.contentSize.height > self.tableView.frame.size.height) {
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height-self.tableView.frame.size.height) animated:NO];
        self.isScrollToBottom = NO;
    }
}

-(void)sendVideoMessage:(EMChatVideo *)video
{
    NSDictionary *ext = nil;
    [ChatSendHelper sendVideo:video
                   toUsername:_conversation.chatter
                  messageType:eMessageTypeChat
            requireEncryption:NO ext:ext];
}

-(void)sendImageMessage:(UIImage *)image
{
    NSDictionary *ext = nil;
    [ChatSendHelper sendImageMessageWithImage:image
                                   toUsername:_conversation.chatter
                                  messageType:eMessageTypeChat
                            requireEncryption:NO
                                          ext:ext];
}



#pragma mark - overwrite
- (void)initTableView {
    SLGlobalBannerModel * model1 = [[SLGlobalBannerModel alloc] init];
    model1.image = [UIImage imageNamed:@"payicon_wx"];
    SLGlobalBannerModel * model2 = [[SLGlobalBannerModel alloc] init];
    model2.image = [UIImage imageNamed:@"payicon_balance"];
    SLGlobalBannerModel * model3 = [[SLGlobalBannerModel alloc] init];
    model3.image = [UIImage imageNamed:@"payicon_cash"];
    self.banner = [[SLGlobalBannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 170)];
    self.banner.dataSource = @[model1,model2,model3];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.needHeader = YES;
    self.needFooter = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.bottomView = [[SLChatBottomView alloc] init];
    self.bottomView.delegate = self;
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.banner];
    [self makeConstrains];
    [self.banner start];
}

- (void)initTableViewSource {
    HYContext * context = [[HYContext alloc] init];
    [context.contextDic setObject:self.conversation forKey:@"conversation"];
    self.tableViewSource = [[SLChatViewSource alloc] initWithDelegate:self context:context];
    self.tableView.dataSource = self.tableViewSource;
    self.tableView.delegate = self;
    UIGestureRecognizer * tapgestuer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tapgestuer];
}

- (void)makeConstrains {
    //1.tableView的约束
    WeakSelf(weakself)
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself.view).insets(UIEdgeInsetsMake(0, 0, self.toobBarHeight, 0));
    }];
    //2.bottomView的约束
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.tableView.mas_bottom);
        make.left.right.equalTo(weakself.view);
        make.height.mas_equalTo(kToolBarHeight);
    }];
}

- (void) tableSourceDidFinishRefresh:(HYBaseTableViewSource *)tableSource {
    [super tableSourceDidFinishRefresh:tableSource];
    [self scrollToBottom];
}

#pragma mark - SLChatViewSourceDelegate
- (void)didReceiveMessage:(EMMessage *)message {
    NSLog(@"complete code here when message was received if needed");
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.tableViewSource.modelArray.count -1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];

}

-(void)didReceiveOfflineMessages:(NSArray *)offlineMessages {
    NSLog(@"complete code here when offlinemessage was received if needed");
}

-(void)didReceiveOfflineCmdMessages:(NSArray *)offlineCmdMessages {
    NSLog(@"complete code here when cmdmessage was received if needed");
}

- (void)didSendMessage:(EMMessage *)message error:(EMError *)error {
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.tableViewSource.modelArray.count -1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];

    NSLog(@"complete code here when message was sended if needed");
}

- (void)didSendPicButtonClicked:(UIButton *)sender {
    NSLog(@"complete code here when sendPic button is clicked if needed");
    [[HYPhotoBrowserAssetsHelper sharedInstance] loadAssetsFromUserAlbumWithAssetsType:ESLPhotoType didLoad:^(NSMutableArray *results) {
        if (results && results.count > 0) {
            self.photoPicker = [[SLPhotoPicker alloc] initWithAssets:results];
            self.photoPicker.delegate = self;
            self.photoPicker.pickerController = self;
        }
    }];
}

- (void)didSendVideoButtonClicked:(UIButton *)sender {
    NSLog(@"complete code here when sendVideo button is clicked if needed");
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
}

- (void)didSendContractButtonClicked:(UIButton *)sender {
    NSLog(@"complete code here when sendContract button is clicked if needed");
    [[HYPhotoBrowserAssetsHelper sharedInstance] loadAssetsFromUserAlbumWithAssetsType:ESLVideoType didLoad:^(NSMutableArray *results) {
        if (results && results.count > 0) {
            self.photoPicker = [[SLPhotoPicker alloc] initWithAssets:results];
            self.photoPicker.delegate = self;
            self.photoPicker.pickerController = self;
        }
    }];

}

- (void)didSendLocationButtonClicked:(UIButton *)sender {
    NSLog(@"complete code here when sendLocation button is clicked if needed");

}

- (void)didMoreButtonClicked:(UIButton *)sender {
    NSLog(@"complete code here when morebutton is clicked if needed");

}

- (void)didSpeechButtonClicked:(UIButton *)sender {
    NSLog(@"complete code here when speechbutton is clicked if needed");

}

-(void)textViewDidBeginEditing:(UITextView *)textView {

}

- (void)didSendText:(NSString *)text {
    NSLog(@"send Message");
    EMChatText * chatText = [[EMChatText alloc]initWithText:text];
    EMTextMessageBody * body = [[EMTextMessageBody alloc] initWithChatObject:chatText];
    EMMessage * message = [[EMMessage alloc] initWithReceiver:self.chatter bodies:@[body]];
    message.messageType = eMessageBodyType_Text;
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil];
}

#pragma mark - SLChatBottomViewDelegate

- (void)bottomViewWillAppear:(CGFloat)height {
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-height);
    }];
    [UIView animateWithDuration:0.1 animations:^{
        [self.view layoutIfNeeded];
    }];
    self.isScrollToBottom = YES;
    [self scrollToBottom];
}

- (void)bottomViewWillDisAppear:(CGFloat)height {
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-height);
    }];
    [UIView animateWithDuration:0.1 animations:^{
        [self.view layoutIfNeeded];
    }];
    self.isScrollToBottom = YES;
    [self scrollToBottom];
}

#pragma mark - actions & notifications 

- (void)tapAction:(UITapGestureRecognizer *) recognizer {
    if (self.bottomView.toolBar && self.bottomView.toolBar.inputView && [self.bottomView.toolBar.inputView isFirstResponder]) {
        [self.bottomView.toolBar.inputView resignFirstResponder];
    }else {
        [self.bottomView bottomViewDisAppear];
    }
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString * mediaType = info[UIImagePickerControllerMediaType];
    if  ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage * image = info[UIImagePickerControllerOriginalImage];
        if (picker) {
            [picker dismissViewControllerAnimated:YES completion:^{
                [ChatSendHelper sendImageMessageWithImage:image toUsername:_conversation.chatter messageType:eMessageTypeChat requireEncryption:NO ext:nil];
            }];
        }
    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL * url = info[UIImagePickerControllerMediaURL];
        [picker dismissViewControllerAnimated:YES completion:^{
            NSURL * videoURL = [self convert2Mp4:url];
            if ([[NSFileManager defaultManager] fileExistsAtPath:url.path]) {
                [[NSFileManager defaultManager] removeItemAtPath:url.path error:nil];
            }
            
            EMChatVideo * video = [[EMChatVideo alloc] initWithFile:[videoURL relativePath] displayName:@"vedio.mp4"];
            [ChatSendHelper sendVideo:video toUsername:_conversation.chatter messageType:eMessageTypeChat requireEncryption:NO ext:nil];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (picker) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma makr - SLPhotoPicker
- (void)assetDidPicked:(id)asset {
    if ([asset isKindOfClass:[NSURL class]]){
        //视频
        NSURL * mp4 =  [self convert2Mp4:asset];
        EMChatVideo *chatVideo = [[EMChatVideo alloc] initWithFile:[mp4 relativePath] displayName:@"video.mp4"];
        [self sendVideoMessage:chatVideo];
    }else if ([asset isKindOfClass:[UIImage class]]) {
        [self sendImageMessage:(UIImage *)asset];
    }
}

- (void)assetsPickFinished {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getters & setters 
- (UIImagePickerController *)imagePicker {
    if (!_imagePicker){
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return _imagePicker;
}

#pragma mark - helper
- (NSURL *)convert2Mp4:(NSURL *)movUrl {
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetHighestQuality];
        
        NSDateFormatter * format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyyMMddHHmmss"];
        NSString * path = [[SLTools pathForApplicationRoot] stringByAppendingFormat:@"/output-%@.mp4",[format stringFromDate:[NSDate date]]];
        mp4Url = [NSURL fileURLWithPath:path];
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"completed.");
                } break;
                default: {
                    NSLog(@"others.");
                } break;
            }
            dispatch_semaphore_signal(wait);
        }];
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            NSLog(@"timeout.");
        }
        if (wait) {
            //dispatch_release(wait);
            wait = nil;
        }
    }
    
    return mp4Url;
}
@end
