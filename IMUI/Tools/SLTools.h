//
//  SLTools.h
//  Sherlock
//
//  Created by fangyuxi on 15/9/10.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

@class ChatSendHelper;
@class EMError;
@class SLRootViewController;


#pragma mark 协议
/** 从cell到controller的各种操作统一接口 **/
@protocol HYCellToControllerActionProtocal <NSObject>
@optional

- (void)ActionFromView:(UIView *)view
          withEventTag:(NSString *)tag
   withParameterObject:(id)object;

@end

#pragma mark - macro

#define HYRGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define HYRGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define HYHexToRGB(value) [UIColor colorWithRed:((value&0xFF0000)>>16)/255.0 green:((value&0xFF00)>>8)/255.0 blue:(value&0xFF)/255.0 alpha:1.0]


#import "IChatManagerBuddy.h"

@interface SLTools : NSObject

+ (UIButton *)createButtonWithtarget:(id)target selector:(SEL)selector backgroudImg:(NSString *)imgName;
+ (UIBarButtonItem *)createCommonBackButtonWithTarget:(id)target action:(SEL)action;

+ (NSString *)appVersion;
+ (NSString *)randomString;

/** 正则匹配 **/
+ (BOOL)validateValue:(id)value withPatern:(NSString *)patern ;

+ (SLRootViewController *)rootController;

+ (void)getBlackList;

+ (BOOL)isUrl:(NSString *)url;

+ (NSArray *)imagesForGIF:(NSString *)gifName;

+ (NSArray *)imagesForPNGS:(NSString *)pngFileName count:(NSInteger)count;
+ (NSString *)pathForApplicationRoot;

@end
