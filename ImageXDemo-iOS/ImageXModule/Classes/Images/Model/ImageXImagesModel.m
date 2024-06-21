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
//  ImageXImagesModel.m
//  ImageXModule
//
//  Created by ByteDance on 2024/3/8.
//

#import "ImageXImagesModel.h"

@implementation ImageXImagesModel

+ (NSDictionary *)imagesData {
    return @{
        @"Decoding Images": @{
            @"class": @"ImageXDecodingViewController",
            @"urls": @{
                @"jpeg": @[
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.jpeg",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.jpeg",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.jpeg",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.jpeg",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.jpeg",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.jpeg",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.jpeg",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.jpeg",
                ],
                @"png": @[
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.png",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.png",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.png",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.png",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.png",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.png",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.png",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.png",
                ],
                @"heic": @[
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1_1.heic",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2_1.heic",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1_1.heic",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2_1.heic",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1_1.heic",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2_1.heic",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1_1.heic",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2_1.heic",
                ],
                @"webp": @[
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.webp",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.webp",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.webp",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.webp",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.webp",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.webp",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.webp",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.webp",
                ],
                @"bmp": @[
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.bmp",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.bmp",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.bmp",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.bmp",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.bmp",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.bmp",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.bmp",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.bmp",
                ],
                @"ico": @[
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.ico",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.ico",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.ico",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.ico",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.ico",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.ico",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.ico",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.ico",
                ],
                @"avif": @[
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.avif",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.avif",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.avif",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.avif",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.avif",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.avif",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.avif",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.avif",
                ],
                @"gif": @[
                    @"http://imagex-sdk.volcimagextest.com/r.gif",
                    @"http://imagex-sdk.volcimagextest.com/response.gif",
                    @"http://imagex-sdk.volcimagextest.com/r.gif",
                    @"http://imagex-sdk.volcimagextest.com/response.gif",
                    @"http://imagex-sdk.volcimagextest.com/r.gif",
                    @"http://imagex-sdk.volcimagextest.com/response.gif",
                    @"http://imagex-sdk.volcimagextest.com/r.gif",
                    @"http://imagex-sdk.volcimagextest.com/response.gif",
                ],
                @"awebp": @[
                    @"http://imagex-sdk.volcimagextest.com/r.webp",
                    @"http://imagex-sdk.volcimagextest.com/response.webp",
                    @"http://imagex-sdk.volcimagextest.com/r.webp",
                    @"http://imagex-sdk.volcimagextest.com/response.webp",
                    @"http://imagex-sdk.volcimagextest.com/r.webp",
                    @"http://imagex-sdk.volcimagextest.com/response.webp",
                    @"http://imagex-sdk.volcimagextest.com/r.webp",
                    @"http://imagex-sdk.volcimagextest.com/response.webp",
                ],
                @"heif": @[
                    @"http://imagex-sdk.volcimagextest.com/r.heif",
                    @"http://imagex-sdk.volcimagextest.com/response.heif",
                    @"http://imagex-sdk.volcimagextest.com/r.heif",
                    @"http://imagex-sdk.volcimagextest.com/response.heif",
                    @"http://imagex-sdk.volcimagextest.com/r.heif",
                    @"http://imagex-sdk.volcimagextest.com/response.heif",
                    @"http://imagex-sdk.volcimagextest.com/r.heif",
                    @"http://imagex-sdk.volcimagextest.com/response.heif",
                ],
                @"avis": @[
                    @"http://imagex-sdk.volcimagextest.com/r.avif",
                    @"http://imagex-sdk.volcimagextest.com/response.avif",
                    @"http://imagex-sdk.volcimagextest.com/r.avif",
                    @"http://imagex-sdk.volcimagextest.com/response.avif",
                    @"http://imagex-sdk.volcimagextest.com/r.avif",
                    @"http://imagex-sdk.volcimagextest.com/response.avif",
                    @"http://imagex-sdk.volcimagextest.com/r.avif",
                    @"http://imagex-sdk.volcimagextest.com/response.avif",
                ],
            }
        },
        @"Progressive Images": @{
            @"class": @"ImageXProgressiveViewController",
            @"urls": @{
                @"jpeg": @[
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.jpeg",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.jpeg",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.jpeg",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.jpeg",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.jpeg",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.jpeg",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.jpeg",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.jpeg",
                ],
                @"png": @[
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.png",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.png",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.png",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.png",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.png",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.png",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1.png",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2.png",
                ],
                @"heic": @[
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1_1.heic",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2_1.heic",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1_1.heic",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2_1.heic",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1_1.heic",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2_1.heic",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_1_1.heic",
                    @"http://imagex-sdk.volcimagextest.com/demo_image_2_1.heic",
                ],
                @"gif": @[
                    @"http://imagex-sdk.volcimagextest.com/r.gif",
                    @"http://imagex-sdk.volcimagextest.com/response.gif",
                    @"http://imagex-sdk.volcimagextest.com/r.gif",
                    @"http://imagex-sdk.volcimagextest.com/response.gif",
                    @"http://imagex-sdk.volcimagextest.com/r.gif",
                    @"http://imagex-sdk.volcimagextest.com/response.gif",
                    @"http://imagex-sdk.volcimagextest.com/r.gif",
                    @"http://imagex-sdk.volcimagextest.com/response.gif",
                ],
                @"awebp": @[
                    @"http://imagex-sdk.volcimagextest.com/r.webp",
                    @"http://imagex-sdk.volcimagextest.com/response.webp",
                    @"http://imagex-sdk.volcimagextest.com/r.webp",
                    @"http://imagex-sdk.volcimagextest.com/response.webp",
                    @"http://imagex-sdk.volcimagextest.com/r.webp",
                    @"http://imagex-sdk.volcimagextest.com/response.webp",
                    @"http://imagex-sdk.volcimagextest.com/r.webp",
                    @"http://imagex-sdk.volcimagextest.com/response.webp",
                ],
                @"heif": @[
                    @"http://imagex-sdk.volcimagextest.com/r.heif",
                    @"http://imagex-sdk.volcimagextest.com/response.heif",
                    @"http://imagex-sdk.volcimagextest.com/r.heif",
                    @"http://imagex-sdk.volcimagextest.com/response.heif",
                    @"http://imagex-sdk.volcimagextest.com/r.heif",
                    @"http://imagex-sdk.volcimagextest.com/response.heif",
                    @"http://imagex-sdk.volcimagextest.com/r.heif",
                    @"http://imagex-sdk.volcimagextest.com/response.heif",
                ],
            }
        },
        @"Animated Images": @{
            @"class": @"ImageXAnimatedViewController",
            @"urls": @{
                @"gif": @[
                    @"http://imagex-sdk.volcimagextest.com/r.gif",
                    @"http://imagex-sdk.volcimagextest.com/response.gif",
                    @"http://imagex-sdk.volcimagextest.com/r.gif",
                    @"http://imagex-sdk.volcimagextest.com/response.gif",
                    @"http://imagex-sdk.volcimagextest.com/r.gif",
                    @"http://imagex-sdk.volcimagextest.com/response.gif",
                    @"http://imagex-sdk.volcimagextest.com/r.gif",
                    @"http://imagex-sdk.volcimagextest.com/response.gif",

                ],
                @"awebp": @[
                    @"http://imagex-sdk.volcimagextest.com/r.webp",
                    @"http://imagex-sdk.volcimagextest.com/response.webp",
                    @"http://imagex-sdk.volcimagextest.com/r.webp",
                    @"http://imagex-sdk.volcimagextest.com/response.webp",
                    @"http://imagex-sdk.volcimagextest.com/r.webp",
                    @"http://imagex-sdk.volcimagextest.com/response.webp",
                    @"http://imagex-sdk.volcimagextest.com/r.webp",
                    @"http://imagex-sdk.volcimagextest.com/response.webp",
                ],
                @"heif": @[
                    @"http://imagex-sdk.volcimagextest.com/r.heif",
                    @"http://imagex-sdk.volcimagextest.com/response.heif",
                    @"http://imagex-sdk.volcimagextest.com/r.heif",
                    @"http://imagex-sdk.volcimagextest.com/response.heif",
                    @"http://imagex-sdk.volcimagextest.com/r.heif",
                    @"http://imagex-sdk.volcimagextest.com/response.heif",
                    @"http://imagex-sdk.volcimagextest.com/r.heif",
                    @"http://imagex-sdk.volcimagextest.com/response.heif",
                ]
            }
        }
    };
}

@end
