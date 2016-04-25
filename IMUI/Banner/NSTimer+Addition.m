//
//  NSTimer+Addition.m
//  Sherlock
//
//  Created by knight on 15/11/13.
//  Copyright © 2015年 bj.58.com. All rights reserved.
//

#import "NSTimer+Addition.h"

@implementation NSTimer (Addition)

- (void)pause {
    if (self.isValid) {
        [self setFireDate:[NSDate distantFuture]];
    }else
        return;
}

- (void)resume {
    if (self.isValid) {
        [self setFireDate:[NSDate date]];
    }else
        return;
}

- (void)resumeTimerAfterTimerInterval:(NSTimeInterval)interval {
    if (self.isValid) {
        [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
    }
    return;
    
}
@end
