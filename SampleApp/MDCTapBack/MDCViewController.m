//  MDCViewController.m
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


#import "MDCViewController.h"
#import <UIView+MDCTapBack/UIView+MDCTapBack.h>


@implementation MDCViewController


#pragma mark - Internal Methods

- (IBAction)onButtonTap:(UIButton *)sender {
    if (self.view.isRecording) {
        MDCTapBackRecord record = [self.view stopRecordingTaps];
        NSLog(@"%lf", record.tapsPerSecond);
        [sender setTitle:@"Start Recording"
                forState:UIControlStateNormal];
    } else {
        [self.view startRecordingTapsWithUpdateInterval:.001 onTap:^(CGPoint tapPoint) {
            NSLog(@"Tap at point: (%f, %f)", tapPoint.x, tapPoint.y);
        }];
        [sender setTitle:@"Stop Recording"
                forState:UIControlStateNormal];
    }
}

@end
