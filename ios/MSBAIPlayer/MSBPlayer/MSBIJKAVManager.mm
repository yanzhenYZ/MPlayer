//
//  MSBIJKAVManager.m
//  MSBPlayer
//
//  Created by yanzhen on 2020/8/17.
//  Copyright © 2020 MSBAI. All rights reserved.
//

#import "MSBIJKAVManager.h"
#import "MSBAVMedia.h"

#define AUDIO 0

@interface MSBIJKAVManager ()
#if AUDIO
@property (nonatomic, strong) NSFileHandle *audioHandle;
#endif
@end

@implementation MSBIJKAVManager
static id _managet;
+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _managet = [[MSBIJKAVManager alloc] init];
    });
    return _managet;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _managet = [super allocWithZone:zone];
    });
    return _managet;
}

- (BOOL)softOut {
    return !_videoToolbox && _videoDataBlock;
}

- (id)copyWithZone:(NSZone *)zone {
    return _managet;
}

-(void)audio:(int)freq channels:(int)channels data:(void *const)mAudioData size:(UInt32)size {
#if AUDIO
    if (!_audioHandle) {
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/test.pcm"];
        [NSFileManager.defaultManager removeItemAtPath:path error:nil];
        [NSFileManager.defaultManager createFileAtPath:path contents:nil attributes:nil];
        _audioHandle = [NSFileHandle fileHandleForWritingAtPath:path];
        NSLog(@"4321---%@:%@", path, _audioHandle);
    }
    NSData *data = [NSData dataWithBytes:mAudioData length:size];
    [_audioHandle writeData:data];
#endif
    
    if (_audioDataBlock) {
        _audioDataBlock(freq, channels, mAudioData, size);
    }
}

- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    if (pixelBuffer && _videoDataBlock) {
        _videoDataBlock(pixelBuffer);
    }
}

- (void)yuv420PToPixelBuffer:(uint8_t *)yBuffer vBuffer:(uint8_t *)uBuffer uBuffer:(uint8_t *)vBuffer width:(int)width height:(int)height dataWidth:(int)dataWidth {
    CVPixelBufferRef pixelBuffer = [MSBAVMedia yuv420PToPixelBuffer:yBuffer uBuffer:uBuffer vBuffer:vBuffer width:width height:height dataWidth:dataWidth];
    [self displayPixelBuffer:pixelBuffer];
    CVPixelBufferRelease(pixelBuffer);
}

@end
