//
//  MSBArtApplePlayer.h
//  MSBPlayer
//
//  Created by yanzhen on 2020/9/2.
//  Copyright © 2020 MSBAI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSBArtPlayerProtocol.h"

@interface MSBArtApplePlayer : NSObject<MSBArtPlayerProtocol>
- (instancetype)initWithURL:(NSURL *)url;
@end

