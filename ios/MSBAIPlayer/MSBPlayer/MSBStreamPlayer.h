//
//  MSBStreamPlayer.h
//  MSBAIPlayer
//
//  Created by yanzhen on 2020/6/20.
//  Copyright © 2020 MSBAI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSBAIPlayerProtocol.h"

@interface MSBStreamPlayer : NSObject<MSBAIPlayerProtocol>

+ (instancetype)playerWithURL:(NSURL *)URL;
- (instancetype)initWithURL:(NSURL *)URL;

- (instancetype)initWithURL:(NSURL *)URL mode:(MSBVideoDecoderMode)mode;

@end


