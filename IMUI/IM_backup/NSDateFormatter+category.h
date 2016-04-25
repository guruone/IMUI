//
//  NSDateFormatter+category.h
//  Sherlock
//
//  Created by knight on 15/9/17.
//  Copyright (c) 2015年 bj.58.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (category)

+ (id)dateFormatter;
+ (id)dateFormatterWithFormat:(NSString *)dateFormat;
+ (id)defaultDateFormatter;/*yyyy-MM-dd HH:mm:ss*/

@end
