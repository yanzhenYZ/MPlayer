//
//  MSBArtPlayer.m
//  MSBPlayer
//
//  Created by yanzhen on 2020/9/2.
//  Copyright © 2020 MSBAI. All rights reserved.
//

#import "MSBArtPlayer.h"
#import "MSBArtApplePlayer.h"

@interface MSBArtPlayer ()
@property (nonatomic, strong) id<MSBArtPlayerProtocol> player;
@end

@implementation MSBArtPlayer
- (instancetype)initWithURL:(NSURL *)url {
    return [self initWithURL:url mode:MSBVideoDecoderModeToolBoxSync];
}

- (instancetype)initWithURL:(NSURL *)url mode:(MSBVideoDecoderMode)mode {
    self = [super init];
    if (self) {
        _player = [[MSBArtApplePlayer alloc] initWithURL:url];
        _player.playbackTimeInterval = 1;
    }
    return self;
}

#pragma mark - method
- (void)attachToView:(UIView *)view {
    if (NSThread.isMainThread) {
        [_player.playerView removeFromSuperview];
        _player.playerView.frame = view.bounds;
        [view insertSubview:_player.playerView atIndex:0];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.player.playerView removeFromSuperview];
            self.player.playerView.frame = view.bounds;
            [view insertSubview:self.player.playerView atIndex:0];
        });
    }
}

- (void)play {
    [_player play];
}

- (void)pause {
    [_player pause];
}

- (void)resume {
    [_player resume];
}

- (void)stop {
    [_player stop];
}

- (void)seekToTime:(NSTimeInterval)time {
    [_player seekToTime:time];
}
#pragma mark - property
- (void)setPlaybackTimeInterval:(NSTimeInterval)playbackTimeInterval {
    _player.playbackTimeInterval = playbackTimeInterval;
}

- (NSTimeInterval)playbackTimeInterval {
    return _player.playbackTimeInterval;
}

- (void)setVideoGravity:(AVLayerVideoGravity)videoGravity {
    _player.videoGravity = videoGravity;
}

- (AVLayerVideoGravity)videoGravity {
    return _player.videoGravity;
}

- (void)setVideoDataBlock:(void (^)(CVPixelBufferRef))videoDataBlock {
    _player.videoDataBlock = videoDataBlock;
}

- (void (^)(CVPixelBufferRef))videoDataBlock {
    return _player.videoDataBlock;
}


- (void)setAudioDataBlock:(void (^)(int, int, void *, int))audioDataBlock {
    _player.audioDataBlock = audioDataBlock;
}

- (void (^)(int, int, void *, int))audioDataBlock {
    return _player.audioDataBlock;
}

- (void)setLoadedTime:(void (^)(NSTimeInterval, NSTimeInterval))loadedTime {
    _player.loadedTime = loadedTime;
}

- (void (^)(NSTimeInterval, NSTimeInterval))loadedTime {
    return _player.loadedTime;
}

- (void)setPlaybackTime:(void (^)(NSTimeInterval, NSTimeInterval))playbackTime {
    _player.playbackTime = playbackTime;
}

- (void (^)(NSTimeInterval, NSTimeInterval))playbackTime {
    return _player.playbackTime;
}

- (void)setPlaybackStatus:(void (^)(MSBArtPlaybackStatus, NSError *))playbackStatus {
    _player.playbackStatus = playbackStatus;
}

- (void (^)(MSBArtPlaybackStatus, NSError *))playbackStatus {
    return _player.playbackStatus;
}
#pragma mark - property readOnly
- (UIView *)playerView {
    return _player.playerView;
}

- (NSTimeInterval)currentTime {
    return _player.currentTime;
}

- (NSTimeInterval)duration {
    return _player.duration;
}

- (UIImage *)currentImage {
    return _player.currentImage;
}

- (MSBArtPlaybackStatus)status {
    return _player.status;
}

/**
 1.1 加载资源，手动播放
 */
+ (NSString *)getVersion {
    return @"1.0.0";
}
@end
