//
//  MSBAIApplePlayer.m
//  MSBAIPlayer
//
//  Created by yanzhen on 2020/6/20.
//  Copyright © 2020 MSBAI. All rights reserved.
//

#import "MSBAIApplePlayer.h"
#import "IJKAVMoviePlayerController.h"

@interface MSBAIApplePlayer ()
@property (nonatomic, assign) IJKMPMoviePlaybackState ijkStatus;
@property (nonatomic, strong) IJKAVMoviePlayerController *player;
@property (nonatomic, weak) UIView *view;

@property (nonatomic, copy) NSURL *videoUrl;
@property (nonatomic, assign) MSBAIPlaybackStatus videoStatus;
@end



@implementation MSBAIApplePlayer
@synthesize videoGravity = _videoGravity;
@synthesize playbackStatus = _playbackStatus;
@synthesize audioDataBlock = _audioDataBlock;
@synthesize videoDataBlock = _videoDataBlock;
@synthesize yuvDataBlock = _yuvDataBlock;

+(instancetype)playerWithURL:(NSURL *)URL {
    return [[MSBAIApplePlayer alloc] initWithURL:URL];
}

- (instancetype)initWithURL:(NSURL *)URL {
    if (self = [super init]) {
        _videoUrl = URL;
        _videoGravity = AVLayerVideoGravityResizeAspect;
        _player = [[IJKAVMoviePlayerController alloc] initWithContentURL:URL];
        _player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _videoStatus = MSBAIPlaybackStatusBuffering;
        _ijkStatus = IJKMPMoviePlaybackStatePaused;
        _player.scalingMode = IJKMPMovieScalingModeAspectFit;
        _player.shouldAutoplay = NO;
        [self addObserver];
        [_player prepareToPlay];
    }
    return self;
}

- (void)addObserver {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(playerPlaybackStateDidChange:) name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(playerPlaybackDidFinish:) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (void)playerPlaybackStateDidChange:(NSNotification *)note {
    if (note.object != self.player) {
        return;
    }
    if (_ijkStatus == _player.playbackState) {
        return;
    }
    _ijkStatus = _player.playbackState;
    
    MSBAIPlaybackStatus oldStatus = _videoStatus;
    switch (_ijkStatus) {
        case IJKMPMoviePlaybackStateStopped:
            
            break;
        case IJKMPMoviePlaybackStatePlaying:
            _videoStatus = MSBAIPlaybackStatusPlaying;
            break;
        case IJKMPMoviePlaybackStatePaused:
            _videoStatus = MSBAIPlaybackStatusPaused;
            break;
        case IJKMPMoviePlaybackStateInterrupted:
        
            break;
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward:
            _videoStatus = MSBAIPlaybackStatusSeeking;
            break;
        default:
            break;
    }
    if (_videoStatus != oldStatus) {
        if (_playbackStatus) {
            _playbackStatus(_videoStatus);
        }
    }
}

- (void)playerPlaybackDidFinish:(NSNotification *)note {
    if (note.object != self.player) {
        return;
    }
    int reason = [note.userInfo[IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    if (reason == IJKMPMovieFinishReasonPlaybackEnded) {
        _videoStatus = MSBAIPlaybackStatusEnded;
        if (_playbackStatus) {
            _playbackStatus(_videoStatus);
        }
    }
//    else if (reason == IJKMPMovieFinishReasonPlaybackError) {
//        if ([_delegate respondsToSelector:@selector(player:stoppedWithError:)]) {
//            [_delegate player:self stoppedWithError:note.userInfo[@"error"]];
//        }
//    }
}

#pragma mark - property
//readonly
- (NSURL *)URL {
    return _videoUrl;
}

- (MSBAIPlaybackStatus)status {
    return _videoStatus;
}

- (NSTimeInterval)currentTime {
    return _player.currentPlaybackTime;
}

- (NSTimeInterval)duration {
    return _player.duration;
}

- (BOOL)isPlaying {
    return _videoStatus == MSBAIPlaybackStatusPlaying;
}

- (BOOL)isEnded {
    return _videoStatus == MSBAIPlaybackStatusEnded;
}

- (BOOL)isPaused {
    return _videoStatus == MSBAIPlaybackStatusPaused;
}

- (void)setVideoGravity:(AVLayerVideoGravity)videoGravity {
    _videoGravity = videoGravity;
    if ([videoGravity isEqualToString:AVLayerVideoGravityResizeAspect]) {
        _player.scalingMode = IJKMPMovieScalingModeAspectFit;
    } else if ([videoGravity isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
        _player.scalingMode = IJKMPMovieScalingModeAspectFill;
    } else if ([videoGravity isEqualToString:AVLayerVideoGravityResize]) {
        _player.scalingMode = IJKMPMovieScalingModeFill;
    }
}

- (void)setPlaybackTimeInterval:(NSTimeInterval)playbackTimeInterval {
    self.player.playbackTimeInterval = playbackTimeInterval;
}

- (NSTimeInterval)playbackTimeInterval {
    return self.player.playbackTimeInterval;
}

-(void)setPlaybackTime:(void (^)(NSTimeInterval, NSTimeInterval))playbackTime {
    _player.playbackTime = playbackTime;
}

- (void (^)(NSTimeInterval, NSTimeInterval))playbackTime {
    return _player.playbackTime;
}

- (void)setLoadedTime:(void (^)(NSTimeInterval, NSTimeInterval))loadedTime {
    _player.loadedTime = loadedTime;
}

- (void (^)(NSTimeInterval, NSTimeInterval))loadedTime {
    return _player.loadedTime;
}

- (void)setPlayerStatus:(void (^)(AVPlayerStatus, NSError *))playerStatus {
    _player.playerStatus = playerStatus;
}

- (void (^)(AVPlayerStatus, NSError *))playerStatus {
    return _player.playerStatus;
}

- (void)setAudioDataBlock:(void (^)(int, int, void *, int))audioDataBlock {
    _audioDataBlock = audioDataBlock;
}

- (void (^)(int, int, void *, int))audioDataBlock {
    return _audioDataBlock;
}

- (void)setVideoDataBlock:(void (^)(CVPixelBufferRef))videoDataBlock {
    _videoDataBlock = videoDataBlock;
}

- (void (^)(CVPixelBufferRef))videoDataBlock {
    return _videoDataBlock;
}

- (void)setYuvDataBlock:(void (^)(int, int, NSData *))yuvDataBlock {
    _yuvDataBlock = yuvDataBlock;
}

- (void (^)(int, int, NSData *))yuvDataBlock {
    return _yuvDataBlock;
}

#pragma mark - funcs
- (void)attachToView:(UIView *)view {
    if (_view == view) {
        return;
    }
    _view = view;
    if (NSThread.isMainThread) {
        [_player.view removeFromSuperview];
        _player.view.frame = view.bounds;
        [view insertSubview:_player.view atIndex:0];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_player.view removeFromSuperview];
            _player.view.frame = view.bounds;
            [view insertSubview:_player.view atIndex:0];
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
    [_player play];
}

- (void)stop {
    [_player shutdown];
}

- (void)seekToTime:(NSTimeInterval)time {
    _player.currentPlaybackTime = time;
}

- (UIImage *)currentImage {
    return [_player thumbnailImageAtCurrentTime];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}
@end
