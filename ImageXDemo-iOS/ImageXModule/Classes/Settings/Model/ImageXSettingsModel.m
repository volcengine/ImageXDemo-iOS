/**
 * MIT License
 
 * Copyright (c) 2024 Bytedance Inc.

 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:

 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.

 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
//  ImageXSettingsModel.m
//  ImageXModule
//
//  Created by ByteDance on 2024/3/1.
//

#import "ImageXSettingsModel.h"

@implementation ImageXSettingsModel

+ (instancetype)sharedSettings
{
    static ImageXSettingsModel *sharedSettings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSettings = [[self alloc] init];
    });
    return sharedSettings;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.options = [[NSUserDefaults standardUserDefaults] integerForKey:@"image_option"];
        self.options |= BDImageRequestHighPriority;
    }
    return self;
}

- (void)setOptions:(BDImageRequestOptions)options {
    _options = options;
    [[NSUserDefaults standardUserDefaults] setInteger:options forKey:@"image_option"];
}

+ (NSArray<NSArray<NSDictionary<NSString *, id> *> * > * _Nonnull)tableViewData {
    return @[
        @[
            @{
                @"name": NSLocalizedString(@"settings_appid", nil),
                @"rightLabel": NSLocalizedString(@"settings_change_appid", nil),
                @"methodName": @"changeAppID",
            },
            @{
                @"name": NSLocalizedString(@"settings_cloud_control", nil),
                @"rightLabel": NSLocalizedString(@"settings_see_cloud_control", nil),
                @"methodName": @"showCloudConfig",
            }
        ],
        @[
            @{
                @"name": NSLocalizedString(@"settings_disk_cache", nil),
                @"rightLabel": NSLocalizedString(@"settings_cache_clear", nil),
                @"methodName": @"cleanDiskCache",
            },
            @{
                @"name": NSLocalizedString(@"settings_memory_cache", nil),
                @"rightLabel": NSLocalizedString(@"settings_cache_clear", nil),
                @"methodName": @"cleanMemoryCache",
            },
            @{
                @"name": NSLocalizedString(@"ignore_disk_cache", nil),
                @"rightLabel": @"",
                @"methodName": @"",
            },
            @{
                @"name": NSLocalizedString(@"ignore_memory_cache", nil),
                @"rightLabel": @"",
                @"methodName": @"",
            }
        ]
    ];
}

@end
