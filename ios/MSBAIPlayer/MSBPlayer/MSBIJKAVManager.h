//
//  MSBIJKAVManager.h
//  MSBPlayer
//
//  Created by yanzhen on 2020/8/17.
//  Copyright © 2020 MSBAI. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface MSBIJKAVManager : NSObject
@property (nonatomic) BOOL videoToolbox;
@property (nonatomic, readonly) BOOL softOut;
@property (nonatomic, copy) void (^audioDataBlock)(int sampleRate, int channels, void *data, int size);
@property (nonatomic, copy) void (^videoDataBlock)(CVPixelBufferRef pixelBuffer);

+ (instancetype)manager;

- (void)audio:(int)freq channels:(int)channels data:(void * const)mAudioData size:(UInt32)size;
- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer;

-(void)yuv420PToPixelBuffer:(uint8_t *)yBuffer vBuffer:(uint8_t *)uBuffer uBuffer:(uint8_t *)vBuffer width:(int)width height:(int)height dataWidth:(int)dataWidth;
@end


