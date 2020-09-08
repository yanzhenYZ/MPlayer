//
//  MSBEnum.h
//  MSBPlayer
//
//  Created by yanzhen on 2020/6/29.
//  Copyright © 2020 MSBAI. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MSBArtPlaybackStatus) {
    /** init后的初始状态 */
    MSBArtPlaybackStatusUnknow,
    MSBArtPlaybackStatusReady,
    MSBArtPlaybackStatusBuffering,
    MSBArtPlaybackStatusPlaying,
    MSBArtPlaybackStatusPaused,
    MSBArtPlaybackStatusSeeking,
    MSBArtPlaybackStatusEnded,
    MSBArtPlaybackStatusError,
};

typedef NS_ENUM(NSInteger, MSBVideoDecoderMode) {
    //硬件解码同步
    MSBVideoDecoderModeToolBoxSync,
    //硬件解码异步
    MSBVideoDecoderModeToolBoxAsync,
    //系统AVPlayer
    MSBVideoDecoderModeDisplayLayer,
    //视频软件解码
    MSBVideoDecoderModeSoftware,
};

//just for AI
typedef NS_ENUM(NSInteger, MSBAIPlaybackStatus) {
    MSBAIPlaybackStatusBuffering,
    MSBAIPlaybackStatusPlaying,
    MSBAIPlaybackStatusSeeking,
    MSBAIPlaybackStatusPaused,
    MSBAIPlaybackStatusEnded,
};
