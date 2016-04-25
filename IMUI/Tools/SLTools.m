//
//  SLTools.m
//  Sherlock
//
//  Created by fangyuxi on 15/9/10.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

#import "SLTools.h"
#import "AppDelegate.h"
#import <CoreGraphics/CoreGraphics.h>
#import <ImageIO/ImageIO.h>

static NSString *dictionary = @"abcdefghijklmnopqrstuvwsyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

@implementation SLTools

+ (UIButton *)createButtonWithtarget:(id)target selector:(SEL)selector backgroudImg:(NSString *)imgName {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        if (imgName && ![imgName isEqualToString:EMPTY_STRING]) {
            [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_pressed",imgName]] forState:UIControlStateHighlighted];
        }
    return button;
}

+ (UIBarButtonItem *)createCommonBackButtonWithTarget:(id)target action:(SEL)action
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[HYCommonTools imageNamed:@"back_button"] style:UIBarButtonItemStylePlain target:target action:action];
    return leftItem;
}


+ (NSString *)appVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

+ (NSString *)randomString
{
    NSMutableString *rtn = [[NSMutableString alloc] init];
    for (int i=0 ; i< 8; i++)
    {
        int r = arc4random() % [dictionary length];
        [rtn appendString:[dictionary substringWithRange:NSMakeRange(r, 1)]];
    }
    return rtn;
}

//正则匹配
+ (BOOL)validateValue:(id)value withPatern:(NSString *)patern {
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",patern];
    return [predicate evaluateWithObject:value];
}


+ (BOOL)isUrl:(NSString *)url {
    if (!url || [url isEqualToString:EMPTY_STRING]) {
        return NO;
    }
    if ([url rangeOfString:@"http"].length > 0) {
        return YES;
    }else
        return NO;
}

+ (NSMutableArray *)praseGIFDataToImageArray:(NSData *)data
{
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    CGFloat animationTime = 0.f;
    if (src) {
        size_t l = CGImageSourceGetCount(src);
        frames = [NSMutableArray arrayWithCapacity:l];
        for (size_t i = 0; i < l; i++) {
            CGImageRef img = CGImageSourceCreateImageAtIndex(src, i, NULL);
            NSDictionary *properties = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(src, i, NULL));
            NSDictionary *frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            animationTime += [delayTime floatValue];
            if (img) {
                [frames addObject:[UIImage imageWithCGImage:img]];
                CGImageRelease(img);
            }
        }
        CFRelease(src);
    }
    return frames;
}

+ (NSArray *)imagesForGIF:(NSString *)gifName
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"];
    return [self praseGIFDataToImageArray:[NSData dataWithContentsOfFile:filePath]];
}

+ (NSArray *)imagesForPNGS:(NSString *)pngFileName count:(NSInteger)count
{
    NSMutableArray *newImages = [NSMutableArray new];
    for (int i = 0; i < count; i++)
    {
        NSString *imageName = [NSString stringWithFormat:@"%@_%@", pngFileName, @(i)];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
        [newImages addObject:[UIImage imageWithContentsOfFile:imagePath]];
    }
    return newImages;
}


+ (NSString *)pathForApplicationRoot
{
    //用Library,作为自定义根目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,  NSUserDomainMask, YES);
    if ([paths count] > 0)
    {
        return [[NSString alloc] initWithFormat:@"%@",paths[0]];
    }
    return @"";
}


@end
