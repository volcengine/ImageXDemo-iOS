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
//  ImageXShowImagesViewController.m
//  ImageXModule
//
//  Created by ByteDance on 2024/3/5.
//

#import "ImageXRootViewController.h"
#import "ImageXSettingsViewController.h"
#import "ImageXImagesModel.h"
#import <Masonry/Masonry.h>

@interface ImageXRootViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *rectangleView;
@property (nonatomic, strong) UIView *grayView;

@property (nonatomic, strong) NSMutableArray *titles;

@end

@implementation ImageXRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titles = [NSMutableArray arrayWithArray:@[@"Decoding Images", @"Progressive Images", @"Animated Images"]];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0x1D / 255.0 green:0x21 / 255.0 blue:0x29 / 255.0 alpha:1.0];
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Images/settingLogo"] style:UIBarButtonItemStylePlain target:self action:@selector(jumpToSettings)];

    [self constructViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (CGRectGetMaxX(self.containerView.frame) > CGRectGetMaxX(self.view.frame)) {
        [self.scrollView setContentOffset:CGPointMake(50 * [self.curItem intValue], 0) animated:YES];
    }
}

- (void)constructViews {
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.grayView];
    
    CGFloat topOffset = UIApplication.sharedApplication.statusBarFrame.size.height + self.navigationController.navigationBar.bounds.size.height;
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(topOffset);
        make.height.mas_equalTo(45);
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right);
    }];
    [self constructScrollView];
    [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    NSInteger selected = [self.curItem intValue];
    Class viewController = NSClassFromString(ImageXImagesModel.imagesData[_titles[selected]][@"class"]);
    UIViewController *curViewController = [[viewController alloc] init];
    curViewController.view.frame = self.grayView.bounds;
    [self addChildViewController:curViewController];
    [self.grayView addSubview:curViewController.view];
    [curViewController didMoveToParentViewController:self];
}

- (void)constructScrollView {
    [self.scrollView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    UIView *preView = nil;
    
    for (int i = 0; i < [_titles count]; ++i) {
        UILabel *label = [[UILabel alloc] init];
        label.tag = i;
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString([_titles objectAtIndex:i], nil);
        if (i == [self.curItem intValue]) {
            label.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
            label.textColor = [UIColor colorWithRed:0x00 / 255.0 green:0x2C / 255.0 blue:0x47 / 255.0 alpha:1.0];
        }else {
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
            label.textColor = [UIColor colorWithRed:0x86 / 255.0 green:0x90 / 255.0 blue:0x9C / 255.0 alpha:1.0];
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectLabel:)]];
        CGFloat labelWidth = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}].width + 20;
        [self.containerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self.containerView);
            make.width.mas_equalTo(labelWidth);
            if (preView) {
                make.left.equalTo(preView.mas_right);
            }else {
                make.left.mas_equalTo(0);
            }
        }];
        preView = label;
        if (i == [self.curItem intValue]) {
            [self.containerView addSubview:self.rectangleView];
            [self.rectangleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.containerView.mas_bottom);
                make.top.equalTo(self.containerView.mas_bottom).offset(-3);
                make.left.equalTo(label.mas_left);
                make.right.equalTo(label.mas_right);
            }];
        }
    }
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(preView.mas_right);
    }];
}

- (void)selectLabel:(UITapGestureRecognizer *)gesture {
    self.curItem = @(gesture.view.tag);
    [self.rectangleView removeFromSuperview];
    [self.containerView addSubview:self.rectangleView];
    [self.rectangleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.containerView.mas_bottom);
        make.top.equalTo(self.containerView.mas_bottom).offset(-3);
        make.left.equalTo(gesture.view.mas_left);
        make.right.equalTo(gesture.view.mas_right);
    }];
    
    for (UIView *view in self.containerView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            if (label.tag == gesture.view.tag) {
                label.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
                label.textColor = [UIColor colorWithRed:0x00 / 255.0 green:0x2C / 255.0 blue:0x47 / 255.0 alpha:1.0];
            }else {
                label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
                label.textColor = [UIColor colorWithRed:0x86 / 255.0 green:0x90 / 255.0 blue:0x9C / 255.0 alpha:1.0];
            }
        }
    }
    for (UIViewController *childViewController in self.childViewControllers) {
        [childViewController removeFromParentViewController];
    }
    for (UIView *view in self.grayView.subviews) {
        [view removeFromSuperview];
    }
    Class viewController = NSClassFromString(ImageXImagesModel.imagesData[_titles[gesture.view.tag]][@"class"]);
    UIViewController *nextViewController = [[viewController alloc] init];
    nextViewController.view.frame = self.grayView.bounds;
    [self addChildViewController:nextViewController];
    [self.grayView addSubview:nextViewController.view];
    [nextViewController didMoveToParentViewController:self];
}

- (void)jumpToSettings {
    ImageXSettingsViewController *vc = [[ImageXSettingsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Lazy Load

- (UIView *)grayView {
    if (_grayView == nil) {
        _grayView = [[UIView alloc] init];
        _grayView.backgroundColor = [UIColor colorWithRed:0xF4 / 255.0 green:0xF5 / 255.0 blue:0xF7 / 255.0 alpha:1.0];
    }
    return _grayView;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}
    
- (UIImageView *)rectangleView {
    if (_rectangleView == nil) {
        _rectangleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/segmentRectangle"]];
    }
    return _rectangleView;
}

- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

@end
