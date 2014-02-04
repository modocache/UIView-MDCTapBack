# UIView+MDCTapBack

A category on `UIView` that allows you to record the number of taps,
as well as execute a callback for each tap. At the request of Ovi Bortas.

## Installation (CocoaPods)

Add the following to your Podfile:

```ruby
platform :ios

pod 'UIView+MDCTapBack', git: 'https://github.com/modocache/UIView-MDCTapBack.git'
```

Then run `pod install` on the command line from the directory of your Podfile.

## Usage

```objc
#import <UIView+MDCTapBack/UIView+MDCTapBack.h>

// ...

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
```

