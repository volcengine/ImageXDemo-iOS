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
//  ImageXDecodingViewController.m
//  ImageXModule
//
//  Created by ByteDance on 2024/3/7.
//

#import "ImageXDecodingViewController.h"
#import "ImageXImagesModel.h"
#import "UIImageView+BDWebImage.h"
#import "BDImageView.h"
#import "ImageXDecodingDetailsViewController.h"
#import "ImageXSettingsModel.h"
#import "ImageXDecodingCollectionViewCell.h"
#import "ImageXUIUtils.h"
#import <Masonry/Masonry.h>

@interface ImageXDecodingViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *scrollContainerView;
@property (nonatomic, strong) NSArray<UIButton *> *buttons;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *addURLsButton;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *imageURLs;

@property (nonatomic, strong) NSMutableDictionary *records;
@property (nonatomic, strong) NSMutableDictionary *largeRecords;

@end

@implementation ImageXDecodingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.records = [NSMutableDictionary dictionary];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    self.buttons = createButtonsFromArray(@[@"jpeg", @"png", @"heic", @"webp", @"bmp", @"ico", @"avif", @"gif", @"awebp", @"heif", @"avis"]);
    [self constructViews];
}

- (void)constructViews {
    [self.view addSubview:self.containerView];
    [self.view addSubview:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(12);
        make.height.mas_equalTo(24);
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right);
    }];
    [self constructScrollView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.top.equalTo(self.scrollView.mas_bottom).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.bottom.equalTo(self.view.mas_bottom).offset(-34);
    }];
    
    [self.containerView addSubview:self.addURLsButton];
    [self.containerView addSubview:self.collectionView];
    [self.addURLsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).offset(16);
        make.left.equalTo(self.containerView.mas_left).offset(16);
        make.width.mas_equalTo(102);
        make.height.mas_equalTo(32);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addURLsButton.mas_bottom).offset(10);
        make.left.equalTo(self.containerView.mas_left).offset(10);
        make.right.equalTo(self.containerView.mas_right).offset(-10);
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-10);
    }];
}

- (void)constructScrollView {
    [self.scrollView addSubview:self.scrollContainerView];
    [self.scrollContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    
    UIButton *preButton = NULL;
    for (int i = 0; i < self.buttons.count; ++i) {
        UIButton *button = [self.buttons objectAtIndex:i];
        [self.scrollContainerView addSubview:button];
        [button addTarget:self action:@selector(clickType:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            button.selected = YES;
        }
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(self.scrollContainerView.mas_left);
            }else {
                make.left.equalTo(preButton.mas_right).offset(12);
            }
            make.top.equalTo(self.scrollContainerView.mas_top);
            make.width.mas_equalTo(48);
            make.height.mas_equalTo(24);
        }];
        preButton = button;
    }
    
    [self.scrollContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(preButton.mas_right).offset(5);
    }];
}

- (void)clickType:(UIButton *)sender {
    for (UIButton *button in self.buttons) {
        if (button.tag == sender.tag) {
            button.selected = YES;
        }else {
            button.selected = NO;
        }
    }
    self.imageURLs = [[NSArray alloc] initWithArray:ImageXImagesModel.imagesData[@"Decoding Images"][@"urls"][sender.titleLabel.text]];
    [self.collectionView reloadData];
    [self.records removeAllObjects];
}

- (void)addImageURLs {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"add_url", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 50, 250, 150)];
    textView.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
    textView.layer.cornerRadius = 5.0f;
    textView.scrollEnabled = YES;
    textView.text = NSLocalizedString(@"add_url_placeholder", nil);
    textView.textColor = [UIColor lightGrayColor];
    textView.delegate = self;
    [alertController.view addSubview:textView];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (textView.text.length > 0) {
            NSArray *imageURLs = [textView.text componentsSeparatedByString:@","];
            NSMutableArray *validURLs = [NSMutableArray array];
            for (NSString *urlString in imageURLs) {
                NSURL *url = [NSURL URLWithString:urlString];
                if (url && ![urlString containsString:@" "] && ![urlString containsString:@"\n"]) {
                    [validURLs addObject:urlString];
                }else {
                    NSLog(@"Invalid URL: %@", urlString);
                }
            }
            if ([validURLs count] > 0) {
                self.imageURLs = [self.imageURLs arrayByAddingObjectsFromArray:validURLs];
                [self.collectionView reloadData];
            }
        }
    }];
    [alertController addAction:doneAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Lazy Load

- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 8.0;
    }
    return _containerView;
}

- (UIButton *)addURLsButton {
    if (_addURLsButton == nil) {
        _addURLsButton = [[UIButton alloc] init];
        _addURLsButton.layer.cornerRadius = 6.0;
        [_addURLsButton setTitle:NSLocalizedString(@"add_url_button", nil) forState:UIControlStateNormal];
        [_addURLsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addURLsButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        [_addURLsButton setBackgroundColor:[UIColor colorWithRed:0x16 / 255.0 green:0x5D / 255.0 blue:0xFF / 255.0 alpha:1.0]];
        [_addURLsButton addTarget:self action:@selector(addImageURLs) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addURLsButton;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat itemSideLength = (screenWidth - 60) / 2;
        layout.itemSize = CGSizeMake(itemSideLength, itemSideLength);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ImageXDecodingCollectionViewCell class] forCellWithReuseIdentifier:@"ImageXDecodingCollectionViewCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
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

- (UIView *)scrollContainerView {
    if (_scrollContainerView == nil) {
        _scrollContainerView = [[UIView alloc] init];
    }
    return _scrollContainerView;
}

- (NSArray *)imageURLs {
    if (_imageURLs == nil) {
        _imageURLs = [[NSArray alloc] initWithArray:ImageXImagesModel.imagesData[@"Decoding Images"][@"urls"][@"jpeg"]];
    }
    return _imageURLs;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageURLs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageXDecodingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageXDecodingCollectionViewCell" forIndexPath:indexPath];
    cell.isLoaded = NO;
    __block NSInteger index = indexPath.row;
    // load images
    BDImageRequestOptions options = [ImageXSettingsModel sharedSettings].options;
    __weak typeof(self) weakSelf = self;
    // One of the functions that requests and displays images using a view control, like UIImageView or UIButton.
    [cell.imageView bd_setImageWithURL:[NSURL URLWithString:self.imageURLs[index]] placeholder:createCenteredThumbnailWithImage([UIImage imageNamed:@"Images/imageLoading"]) options:options completion:^(BDWebImageRequest * _Nullable request, UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BDWebImageResultFrom from) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (request.finished) {
            cell.isLoaded = YES;
            // the performance record, you can obtain information that you want in a image request.
            [strongSelf.records setObject:[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:request.recorder.imageMonitorV2Log options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding] forKey:@(index)];
            if (image == nil) {
                NSLog(@"load pic failed");
                if (error != nil) {
                    NSLog(@"errcode is %@", @(error.code));
                }
                cell.imageView.image = [UIImage imageNamed:@"Images/imageFailed"];
            }else {
                NSLog(@"load pic(%@) success from %@", [request.currentRequestURL absoluteString], @(from));
            }
        }
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageXDecodingCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if (!cell.isLoaded) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"image_is_loading", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    NSInteger index = indexPath.row;
    ImageXDecodingDetailsViewController *vc = [[ImageXDecodingDetailsViewController alloc] init];
    vc.url = self.imageURLs[index];
    vc.record = [self.records objectForKey:@(index)];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:NSLocalizedString(@"add_url_placeholder", nil)]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

@end
