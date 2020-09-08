//
//  MSBAIPlayer.m
//  MSBPlayer
//
//  Created by yanzhen on 2020/6/29.
//  Copyright © 2020 MSBAI. All rights reserved.
//

#import "MSBAIPlayer.h"
#import "MSBAIApplePlayer.h"
#import "IJKAVMoviePlayerController.h"

@interface MSBAIPlayer ()
@property (nonatomic, strong) id<MSBAIPlayerProtocol> player;
@end

@implementation MSBAIPlayer
- (instancetype)initWithURL:(NSURL *)URL {
    if (self = [super init]) {
        _URL = URL;
        [self createPlayer:NO];
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)URL mode:(MSBVideoDecoderMode)mode {
    if (self = [super init]) {
        _URL = URL;
        [self createPlayer:NO];
    }
    return self;
}

- (void)createPlayer:(BOOL)apple {
    _player = [[MSBAIApplePlayer alloc] initWithURL:_URL];
}

#pragma mark - property readonly
- (NSTimeInterval)currentTime {
    return _player.currentTime;
}

- (NSTimeInterval)duration {
    return _player.duration;
}

- (UIImage *)currentImage {
    return _player.currentImage;
}

- (MSBAIPlaybackStatus)status {
    return _player.status;
}

- (BOOL)isPlaying {
    return _player.isPlaying;
}

- (BOOL)isPaused {
    return _player.isPaused;
}

- (BOOL)isEnded {
    return _player.isEnded;
}

#pragma mark - property
-(void)setPlaybackTimeInterval:(NSTimeInterval)playbackTimeInterval {
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

- (void)setPlayerStatus:(void (^)(AVPlayerStatus, NSError *))playerStatus {
    _player.playerStatus = playerStatus;
}

- (void (^)(AVPlayerStatus, NSError *))playerStatus {
    return _player.playerStatus;
}

- (void)setLoadedTime:(void (^)(NSTimeInterval, NSTimeInterval))loadedTime {
    _player.loadedTime = loadedTime;
}

- (void (^)(NSTimeInterval, NSTimeInterval))loadedTime {
    return _player.loadedTime;
}

- (void)setPlaybackStatus:(void (^)(MSBAIPlaybackStatus))playbackStatus {
    _player.playbackStatus = playbackStatus;
}

- (void (^)(MSBAIPlaybackStatus))playbackStatus {
    return _player.playbackStatus;
}

- (void)setPlaybackTime:(void (^)(NSTimeInterval, NSTimeInterval))playbackTime {
    _player.playbackTime = playbackTime;
}

- (void (^)(NSTimeInterval, NSTimeInterval))playbackTime {
    return _player.playbackTime;
}

#pragma mark - func
- (void)attachToView:(UIView *)view {
    [_player attachToView:view];
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

/**
 1.1 加载资源，手动播放
 */
+ (NSString *)getVersion {
    return @"1.1.0";
}
@end
