//
//  MSBAIApplePlayer.h
//  MSBAIPlayer
//
//  Created by yanzhen on 2020/6/20.
//  Copyright © 2020 MSBAI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSBAIPlayerProtocol.h"

@interface MSBAIApplePlayer : NSObject<MSBAIPlayerProtocol>

+ (instancetype)playerWithURL:(NSURL *)URL;
- (instancetype)initWithURL:(NSURL *)URL;

@end

