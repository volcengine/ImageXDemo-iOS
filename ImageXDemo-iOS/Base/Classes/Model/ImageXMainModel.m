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
//  ImageXMainModel.m
//  Base
//
//  Created by ByteDance on 2024/2/28.
//

#import "ImageXMainModel.h"

@implementation ImageXMainModel

+ (NSArray<NSArray<NSDictionary<NSString *, id> *> * > * _Nonnull)tableViewData {
    return @[
        @[
            @{
                @"name": NSLocalizedString(@"label_image_decode", nil),
                @"imagePath": @"Images/decodeLogo",
                @"action": @"ImageXRootViewController"
            },
            @{
                @"name": NSLocalizedString(@"label_progressive", nil),
                @"imagePath": @"Images/progressiveLogo",
                @"action": @"ImageXRootViewController"
            },
            @{
                @"name": NSLocalizedString(@"label_animated", nil),
                @"imagePath": @"Images/animatedLogo",
                @"action": @"ImageXRootViewController"
            },
        ],
        @[
            @{
                @"name": NSLocalizedString(@"label_settings", nil),
                @"imagePath": @"Images/settingLogo",
                @"action": @"ImageXSettingsViewController"
            },
        ]
    ];
}

@end
