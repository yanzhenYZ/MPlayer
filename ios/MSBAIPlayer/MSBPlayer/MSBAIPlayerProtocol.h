//
//  MSBAIPlayerProtocol.h
//  MSBAIPlayer
//
//  Created by yanzhen on 2020/6/21.
//  Copyright © 2020 MSBAI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MSBEnum.h"

@protocol MSBAIPlayerProtocol <NSObject>

@property (nonatomic, readonly) NSURL *URL;

@property (nonatomic, readonly) NSTimeInterval currentTime;
@property (nonatomic, readonly) NSTimeInterval duration;
@property (nonatomic, readonly) UIImage *currentImage;

@property (nonatomic, readonly) MSBAIPlaybackStatus status;
@property (nonatomic, readonly) BOOL isPlaying;
@property (nonatomic, readonly) BOOL isPaused;
@property (nonatomic, readonly) BOOL isEnded;

@property (nonatomic, assign) NSTimeInterval playbackTimeInterval;
@property (nonatomic, copy) AVLayerVideoGravity videoGravity;

@property (nonatomic, copy) void (^videoDataBlock)(CVPixelBufferRef pixelBuffer);
@property (nonatomic, copy) void (^yuvDataBlock)(int width, int height, NSData *data);
@property (nonatomic, copy) void (^audioDataBlock)(int sampleRate, int channels, void *data, int size);
//cancel
@property (nonatomic, copy) void (^playerStatus)(AVPlayerStatus status, NSError *error);
@property (nonatomic, copy) void (^loadedTime)(NSTimeInterval time, NSTimeInterval duration);

@property (nonatomic, copy) void (^playbackStatus)(MSBAIPlaybackStatus status);
@property (nonatomic, copy) void (^playbackTime)(NSTimeInterval time, NSTimeInterval duration);

- (void)attachToView:(UIView *)view;

- (void)play;
- (void)pause;
- (void)resume;
- (void)stop;

- (void)seekToTime:(NSTimeInterval)time;

@end



