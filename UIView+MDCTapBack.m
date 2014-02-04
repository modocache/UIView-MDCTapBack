//  UIView+MDCTapBack.m
//
//  Copyright (c) 2014 modocache
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//


#import "UIView+MDCTapBack.h"
#import <objc/runtime.h>


const void * const kMDCTapBlockSecondsKey = &kMDCTapBlockSecondsKey;
const void * const kMDCTapBlockSecondsTimerKey = &kMDCTapBlockSecondsTimerKey;
const void * const kMDCTapBlockTapGestureRecognizerKey = &kMDCTapBlockTapGestureRecognizerKey;
const void * const kMDCTapBlockNumberOfTapsKey = &kMDCTapBlockNumberOfTapsKey;
const void * const kMDCTapBlockTapBlockKey = &kMDCTapBlockTapBlockKey;
static const NSString * const kMDCTapBlockSecondsTimerTimeIntervalKey = @"kMDCTapBlockSecondsTimerTimeIntervalKey";


@implementation UIView (MDCTapBack)


#pragma mark - Public Interface

- (void)startRecordingTapsWithUpdateInterval:(NSTimeInterval)updateInterval
                                       onTap:(MDCTapBackBlock)tapBlock {
    [self setSeconds:0];
    [self setNumberOfTaps:0];
    [self setTapBlock:tapBlock];
    [self setupTapGestureRecognizer];
    [self setupSecondsTimer:updateInterval];
}

- (MDCTapBackRecord)stopRecordingTaps {
    if (!self.isRecording) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"Recording cannot stop; it has not begun yet."];
    }

    NSTimeInterval seconds = [self seconds];
    NSUInteger numberOfTaps = [self numberOfTaps];
    double tapsPerSecond = numberOfTaps/seconds;
    if (seconds == 0) {
        tapsPerSecond = (double)numberOfTaps;
    }
    MDCTapBackRecord record = { .tapsPerSecond = tapsPerSecond,
                                .seconds = seconds,
                                .numberOfTaps = numberOfTaps };

    [self teardownSecondsTimer];
    [self teardownTapGestureRecognizer];

    return record;
}

- (BOOL)isRecording {
    return [self secondsTimer].isValid;
}


#pragma mark - Internal Methods

- (void)setupSecondsTimer:(NSTimeInterval)timeInterval {
    NSTimer *secondsTimer =
        [NSTimer timerWithTimeInterval:timeInterval
                                target:self
                              selector:@selector(onSecondTimer:)
                              userInfo:@{ kMDCTapBlockSecondsTimerTimeIntervalKey: @(timeInterval) }
                               repeats:YES];
    [self setSecondsTimer:secondsTimer];
    [[NSRunLoop mainRunLoop] addTimer:secondsTimer forMode:NSDefaultRunLoopMode];
}

- (void)teardownSecondsTimer {
    NSTimer *secondsTimer = [self secondsTimer];
    [secondsTimer invalidate];
}

- (void)setupTapGestureRecognizer {
    UITapGestureRecognizer *tapRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(onTapGestureRecognizer:)];
    [self setTapGestureRecognizer:tapRecognizer];
    [self addGestureRecognizer:tapRecognizer];
}

- (void)teardownTapGestureRecognizer {
    [self removeGestureRecognizer:[self tapGestureRecognizer]];
    [self setTapGestureRecognizer:nil];
}

#pragma mark Runtime Setters and Getters

- (NSTimer *)secondsTimer {
    return objc_getAssociatedObject(self, kMDCTapBlockSecondsTimerKey);
}

- (void)setSecondsTimer:(NSTimer *)secondsTimer {
    objc_setAssociatedObject(self,
                             kMDCTapBlockSecondsTimerKey,
                             secondsTimer,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UITapGestureRecognizer *)tapGestureRecognizer {
    return objc_getAssociatedObject(self, kMDCTapBlockTapGestureRecognizerKey);
}

- (void)setTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    objc_setAssociatedObject(self,
                             kMDCTapBlockTapGestureRecognizerKey,
                             tapGestureRecognizer,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)seconds {
    return [objc_getAssociatedObject(self, kMDCTapBlockSecondsKey) doubleValue];
}

- (void)setSeconds:(NSTimeInterval)seconds {
    objc_setAssociatedObject(self,
                             kMDCTapBlockSecondsKey,
                             @(seconds),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)numberOfTaps {
    return [objc_getAssociatedObject(self, kMDCTapBlockNumberOfTapsKey) unsignedIntegerValue];
}

- (void)setNumberOfTaps:(NSUInteger)numberOfTaps {
    objc_setAssociatedObject(self,
                             kMDCTapBlockNumberOfTapsKey,
                             @(numberOfTaps),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MDCTapBackBlock)tapBlock {
    return objc_getAssociatedObject(self, kMDCTapBlockTapBlockKey);
}

- (void)setTapBlock:(MDCTapBackBlock)tapBlock {
    objc_setAssociatedObject(self,
                             kMDCTapBlockTapBlockKey,
                             tapBlock,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark UIControl Events

- (void)onSecondTimer:(NSTimer *)timer {
    NSTimeInterval timeInterval =
        [[self secondsTimer].userInfo[kMDCTapBlockSecondsTimerTimeIntervalKey] doubleValue];
    [self setSeconds:[self seconds] + timeInterval];
}

- (void)onTapGestureRecognizer:(UITapGestureRecognizer *)recognizer {
    [self setNumberOfTaps:[self numberOfTaps] + 1];

    MDCTapBackBlock tapBlock = [self tapBlock];
    if (tapBlock) {
        tapBlock([recognizer locationInView:self]);
    }
}

@end
