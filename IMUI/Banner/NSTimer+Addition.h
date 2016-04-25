//
//  NSTimer+Addition.h
//  Sherlock
//
//  Created by knight on 15/11/13.
//  Copyright © 2015年 bj.58.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Addition)
- (void)pause;
- (void)resume;
- (void)resumeTimerAfterTimerInterval:(NSTimeInterval)interval;
@end
