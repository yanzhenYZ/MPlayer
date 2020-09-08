//
//  ArtViewController.m
//  test
//
//  Created by yanzhen on 2020/9/2.
//  Copyright © 2020 yanzhen. All rights reserved.
//

#import "ArtViewController.h"
#import <MSBPlayer/MSBPlayer.h>

@interface ArtViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIImageView *smallPlayer;
@property (nonatomic, strong) MSBArtPlayer *player;
@property (nonatomic, strong) CIContext *context;
@end

@implementation ArtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self playVideo];
}

- (IBAction)playOrPause:(UIButton *)sender {
    if (sender.isSelected) {
        [_player resume];
    } else {
        [_player pause];
    }
    sender.selected = !sender.isSelected;
}

- (IBAction)sliderAction:(UISlider *)sender {
    [_player seekToTime:sender.value];
}

- (void)playVideo {
    NSString *path = [NSBundle.mainBundle pathForResource:@"3" ofType:@"mp4"];
    NSURL *pathUrl = [NSURL fileURLWithPath:path];
    
    NSURL *url = [NSURL URLWithString:@"http://39.107.116.40/res/tpl/default/file/guoke.mp4"];
    
    _player = [[MSBArtPlayer alloc] initWithURL:url mode:MSBVideoDecoderModeToolBoxSync];
    _player.playerView.frame = self.view.bounds;
    [self.view insertSubview:_player.playerView atIndex:0];
    
    __weak ArtViewController *weakSelf = self;
    [_player play];
    _player.playbackStatus = ^(MSBArtPlaybackStatus status, NSError *error) {
        NSLog(@"22 playbackStatus: %ld:%@", (long)status, error);
    };
    
    _player.playbackTime = ^(NSTimeInterval time, NSTimeInterval duration) {
        weakSelf.slider.maximumValue = duration;
        weakSelf.slider.value = time;
        weakSelf.timeLabel.text = [NSString stringWithFormat:@"%.f/%.f", time, duration];
    };
    
    _player.loadedTime = ^(NSTimeInterval time, NSTimeInterval duration) {
        NSLog(@"44 loadedTime: %f/%f", time, duration);
    };
    
    
//    _player.audioDataBlock = ^(int sampleRate, int channels, void *data, int size) {
//        NSLog(@"55 audioDataBlock: %d, %d, %d", sampleRate, channels, size);
//    };
    
    
    _player.videoDataBlock = ^(CVPixelBufferRef pixelBuffer) {
        [weakSelf displayVideo:pixelBuffer];
    };
    
    
//    _player.yuvDataBlock = ^(int width, int height, NSData *data) {
//        @autoreleasepool {//must do this
//            [weakSelf autoBGRA:width height:height data:data];
//        }
//    };
    
}

- (void)displayVideo:(CVPixelBufferRef)pixelBuffer {
    CIImage *ciImage = [CIImage imageWithCVImageBuffer:pixelBuffer];
    size_t width = CVPixelBufferGetWidth(pixelBuffer);
    size_t height = CVPixelBufferGetHeight(pixelBuffer);
    
    CGImageRef imageRef = [self.context createCGImage:ciImage fromRect:CGRectMake(0, 0, width, height)];
    if (!imageRef) {
        NSLog(@"Create Image fail with CVPixelBufferRef");
        return;
    }
    
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.smallPlayer.image = image;
    });
    
}

-(CIContext *)context {
    if (!_context) {
        _context = [CIContext contextWithOptions:nil];
    }
    return _context;
}
@end
/**
 typedef NS_ENUM(NSInteger, IJKMPMoviePlaybackState) {
     IJKMPMoviePlaybackStateStopped,
     IJKMPMoviePlaybackStatePlaying,
     IJKMPMoviePlaybackStatePaused,
     IJKMPMoviePlaybackStateInterrupted,
     IJKMPMoviePlaybackStateSeekingForward,
     IJKMPMoviePlaybackStateSeekingBackward
 };
 */
