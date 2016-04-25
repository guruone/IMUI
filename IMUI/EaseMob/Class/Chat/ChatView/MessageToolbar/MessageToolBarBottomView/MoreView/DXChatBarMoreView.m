/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "DXChatBarMoreView.h"

#define CHAT_BUTTON_SIZE 50
#define INSETS 8

@implementation DXChatBarMoreView

- (instancetype)initWithFrame:(CGRect)frame type:(ChatMoreType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupSubviewsForType:type];
    }
    return self;
}

- (void)setupSubviewsForType:(ChatMoreType)type
{
    self.backgroundColor = [UIColor clearColor];
    CGFloat insets = (self.frame.size.width - 4 * CHAT_BUTTON_SIZE) / 5;
    
    _photoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_photoButton setFrame:CGRectMake(insets, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_photoButton setImage:[UIImage imageNamed:@"pictures"] forState:UIControlStateNormal];
    [_photoButton setImage:[UIImage imageNamed:@"pictures_pressed"] forState:UIControlStateHighlighted];
    [_photoButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_photoButton];
    
    _photoLabel = [[UILabel alloc] init];
    [_photoLabel setFrame:CGRectMake(insets, 10 + CHAT_BUTTON_SIZE + 5, CHAT_BUTTON_SIZE, 13.0f)];
    _photoLabel.text = @"照片";
    _photoLabel.textColor = [UIColor lightGrayColor];
    _photoLabel.font = [UIFont systemFontOfSize:13.0f];
    _photoLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_photoLabel];
    
    _takePicButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_takePicButton setFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE , 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_takePicButton setImage:[UIImage imageNamed:@"takePhoto"] forState:UIControlStateNormal];
    [_takePicButton setImage:[UIImage imageNamed:@"takePhoto_pressed"] forState:UIControlStateHighlighted];
    [_takePicButton addTarget:self action:@selector(takePicAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_takePicButton];
    
    _takePicLabel = [[UILabel alloc] init];
    [_takePicLabel setFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE, 10 + CHAT_BUTTON_SIZE + 5, CHAT_BUTTON_SIZE, 13.0f)];
    _takePicLabel.text = @"拍摄";
    _takePicLabel.textColor = [UIColor lightGrayColor];
    _takePicLabel.font = [UIFont systemFontOfSize:13.0f];
    _takePicLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_takePicLabel];
    
    _videoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_videoButton setFrame:CGRectMake(insets * 3 + CHAT_BUTTON_SIZE * 2, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_videoButton setImage:[UIImage imageNamed:@"videos"] forState:UIControlStateNormal];
    [_videoButton setImage:[UIImage imageNamed:@"viedeos_pressed"] forState:UIControlStateHighlighted];
    [_videoButton addTarget:self action:@selector(VideoAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_videoButton];
    
    _videoLabel = [[UILabel alloc] init];
    [_videoLabel setFrame:CGRectMake(insets * 3 + CHAT_BUTTON_SIZE * 2, 10 + CHAT_BUTTON_SIZE + 5, CHAT_BUTTON_SIZE, 13.0f)];
    _videoLabel.text = @"视频";
    _videoLabel.textColor = [UIColor lightGrayColor];
    _videoLabel.font = [UIFont systemFontOfSize:13.0f];
    _videoLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_videoLabel];
    
    _audioCallButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_audioCallButton setFrame:CGRectMake(insets * 4 + CHAT_BUTTON_SIZE * 3, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_audioCallButton setImage:[UIImage imageNamed:@"callPhone"] forState:UIControlStateNormal];
    [_audioCallButton setImage:[UIImage imageNamed:@"callPhone_pressed"] forState:UIControlStateHighlighted];
    [_audioCallButton addTarget:self action:@selector(audioCallAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_audioCallButton];
    
    _audioCallLabel = [[UILabel alloc] init];
    [_audioCallLabel setFrame:CGRectMake(insets * 4 + CHAT_BUTTON_SIZE * 3, 10 + CHAT_BUTTON_SIZE + 5, CHAT_BUTTON_SIZE, 13.0f)];
    _audioCallLabel.text = @"打电话";
    _audioCallLabel.textColor = [UIColor lightGrayColor];
    _audioCallLabel.font = [UIFont systemFontOfSize:13.0f];
    _audioCallLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_audioCallLabel];
    
    CGRect frame = self.frame;
    frame.size.height = 60 + CHAT_BUTTON_SIZE + 30 + (5 + 13) * 2;
    self.frame = frame;
    
    _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_locationButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    [_locationButton setImage:[UIImage imageNamed:@"location_pressed"] forState:UIControlStateHighlighted];
    [_locationButton setFrame:CGRectMake(insets, 2*10+CHAT_BUTTON_SIZE+(5+13), CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE)];
    [_locationButton addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_locationButton];
    
    _locationLabel = [[UILabel alloc] init];
    [_locationLabel setFrame:CGRectMake(insets, 2*10+CHAT_BUTTON_SIZE*2+(5+13)+5, CHAT_BUTTON_SIZE, 13.0f)];
    _locationLabel.text = @"位置";
    _locationLabel.textColor = [UIColor lightGrayColor];
    _locationLabel.font = [UIFont systemFontOfSize:13.0f];
    _locationLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_locationLabel];
}

#pragma mark - action

- (void)takePicAction{
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakePicAction:)]){
        [_delegate moreViewTakePicAction:self];
    }
}

- (void)photoAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]) {
        [_delegate moreViewPhotoAction:self];
    }
}

- (void)locationAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]) {
        [_delegate moreViewLocationAction:self];
    }
}

- (void)VideoAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewAudioCallAction:)]) {
        [_delegate moreViewVideoAction:self];
    }
}

- (void)takeVideoCallAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewVideoCallAction:)]) {
        [_delegate moreViewVideoCallAction:self];
    }
}

- (void)audioCallAction {
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewAudioCallAction:)]) {
        [_delegate moreViewAudioCallAction:self];
    }
}

@end
